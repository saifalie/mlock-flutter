import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/services/api/auth_api_services.dart';
import 'package:mlock_flutter/services/secure_storage.dart';

class AuthRepository {
  final AuthApiServices _authApiServices;
  final Map<String, dynamic> _userCache = {};
  DateTime? _lastFetchTime;

  AuthRepository({required AuthApiServices authApiServices})
    : _authApiServices = authApiServices;

  Future<Map<String, dynamic>> signInWithGoogle(
    String idToken,
    String name,
    String profilePicture,
  ) async {
    try {
      final response = await _authApiServices.signInWithGoogle(
        idToken,
        name,
        profilePicture,
      );

      // Save tokens from nested 'tokens'
      final tokensData = response['data']['tokens'];
      logger.d(
        'tokens- ${tokensData['access_token']} ${tokensData['refresh_token']}',
      );
      await SecureStorage.saveTokens(
        accessToken: tokensData['access_token'],
        refreshToken: tokensData['refresh_token'],
      );

      // Return the whole data if needed
      return response['data'];
    } catch (e) {
      logger.e('Error in signInWithGoogle Repo :$e');
      rethrow;
    }
  }

  Future<void> refreshTokens() async {
    try {
      final refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken == null) {
        throw Exception(
          'refreshToken Repo Refresh Token not there in the secure storage',
        );
      }
      final response = await _authApiServices.refreshToken(refreshToken);

      await SecureStorage.saveTokens(
        accessToken: response['data']['access_token'],
        refreshToken: response['data']['refresh_token'],
      );
    } catch (e) {
      logger.e('Error in refreshToken Repo : $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserData(bool forecRefresh) async {
    try {
      if (!forecRefresh && _isCacheValid()) {
        return _userCache;
      }

      final response = await _authApiServices.getUserDataApi();

      return response;
    } catch (e) {
      logger.e('Error in GetuserData repo error: $e');
      rethrow;
    }
  }

  bool _isCacheValid() {
    return _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < Duration(minutes: 15);
  }
}
