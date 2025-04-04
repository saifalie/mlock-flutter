import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/services/secure_storage.dart';

class ApiClient {
  final Dio _dio = Dio();
  // final Logger _logger = Logger(printer: MyCustomPrinter());
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal() {
    _setupDio();
  }

  void _setupDio() {
    //Base configuration
    _dio.options = BaseOptions(
      baseUrl: 'https://mlockserver.onrender.com/api',
      // baseUrl: 'http://192.168.29.156:7000/api',
      // baseUrl: 'http://localhost:7000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) {
        return (status != null && status >= 200 && status < 300) ||
            status == 404;
      },
    );

    _dio.interceptors.addAll([
      _authInterceptor(),
      _loggingInterceptor(),
      _errorInterceptor(),
    ]);
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get the access token from secure storage
        final accessToken = await SecureStorage.getAccessToken();
        logger.d('accessToken request init: $accessToken');

        // Add authorization header if token exists
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        return handler.next(options);
      },

      onError: (error, handler) async {
        logger.e('AuthInterceptor error: $error');

        // Handle only 401 Unauthorized errors
        if (error.response?.statusCode == 401) {
          try {
            logger.d('Attempting token refresh...');

            // Create new Dio instance to avoid interceptor loop
            final refreshDio = Dio();

            // Get refresh token
            final refreshToken = await SecureStorage.getRefreshToken();
            if (refreshToken == null) {
              logger.d('No refresh token available');
              await _handleAuthFailure();
              return handler.reject(error);
            }

            // Call refresh token endpoint
            final response = await refreshDio.post(
              'https://mlockserver.onrender.com/api/auth/refresh-token',
              // 'http://192.168.10.109:7000/api/auth/refresh-token',
              data: {'refreshToken': refreshToken},
            );

            // Handle successful token refresh
            final data = response.data['data'];
            logger.d('New tokens received');

            // Save new tokens
            await SecureStorage.saveTokens(
              accessToken: data['accessToken'],
              refreshToken: data['refreshToken'],
            );

            // Update request headers with new access token
            error.requestOptions.headers['Authorization'] =
                'Bearer ${data['accessToken']}';

            // Retry the original request
            final retryResponse = await _dio.fetch(error.requestOptions);
            return handler.resolve(retryResponse);
          } catch (refreshError) {
            logger.e('Token refresh failed: $refreshError');

            // Clear tokens and logout on refresh failure
            await _handleAuthFailure();

            // Reject with proper error message
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: 'Session expired. Please login again',
                response: error.response,
              ),
            );
          }
        }

        // For all other errors, just propagate them
        return handler.next(error);
      },
    );
  }

  Future<void> _handleAuthFailure() async {
    // clear tokens
    await SecureStorage.clearTokens();

    // sign out from firebase
    await _firebaseAuth.signOut();
    logger.d('_handleAuthFailure AuthInterceptor : called auth failure');
  }

  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.i('Request: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i(
          'Response: ${response.statusCode} ${response.requestOptions.path}',
        );
        return handler.next(response);
      },
      onError: (error, handler) {
        logger.i(
          'Error: ${error.response?.statusCode} ${error.requestOptions.path}',
          error: error.error,
          stackTrace: StackTrace.current,
        );
        return handler.next(error);
      },
    );
  }

  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        //handle different error types
        if (error.type == DioExceptionType.connectionTimeout) {
          error = error.copyWith(
            error: 'Connection timout. Please check your internet',
          );
        } else if (error.type == DioExceptionType.receiveTimeout) {
          error = error.copyWith(error: 'Server is taking too long to respond');
        } else if (error.type == DioExceptionType.connectionError) {
          error = error.copyWith(error: 'No internet connection');
        }

        return handler.next(error);
      },
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }
}
