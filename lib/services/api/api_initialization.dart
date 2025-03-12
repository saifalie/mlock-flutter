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
      baseUrl: 'http://10.0.2.2:7000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
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
        // get the access token from secure storage
        final accessToken = await SecureStorage.getAccessToken();
        logger.d('accessToken request init: $accessToken');

        //add authorization header if token exists
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        return handler.next(options);
      },

      onError: (error, handler) async {
        // handle 401 Unauthorized errors
        logger.e('got the error ${error}');
        if (error.response?.statusCode == 401) {
          try {
            logger.d('got the token expire error -- $error');
            // create new Dio instance to avoid interceptor loop
            final refreshDio = Dio();

            //get refresh token

            final refreshToken = await SecureStorage.getRefreshToken();
            logger.d('refresh token: $refreshToken');
            if (refreshToken == null) {
              logger.d('refresh token is null');
              await _handleAuthFailure();
              return handler.reject(error);
            }

            logger.d('go the new refresh token auth interceptor error');
            // call refresh token endpoint

            final response = await refreshDio.post(
              'http://10.0.2.2:7000/api/auth/refresh-token',
              data: {'refresh_token': refreshToken},
            );

            final data = response.data['data'];

            logger.d('authInterceptor new tokens from the server');

            // save new tokens
            await SecureStorage.saveTokens(
              accessToken: data['access_token'],
              refreshToken: data['refresh_token'],
            );

            // update request headers with new access token
            error.requestOptions.headers['Authorization'] =
                'Bearer ${data['access_token']}';

            //repeat the original request
            final retryResponse = await _dio.fetch(error.requestOptions);

            logger.d('auth Interceptor called the fetch method again');
            return handler.resolve(retryResponse);
          } catch (e) {
            // if refresh fails, clear tokens and logout user
            // await _handleAuthFailure();

            // navigate to login screen
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: 'Session expired. Please login again',
              ),
            );
          }
        }

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
