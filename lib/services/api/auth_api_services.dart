import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/services/api/api_initialization.dart';

class AuthApiServices {
  final ApiClient _apiClient;

  AuthApiServices(this._apiClient);

  Future<Map<String, dynamic>> signInWithGoogle(
    String idToken,
    String? name,
    String? profilePicture,
    String fcmToken,
  ) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: {
        'idToken': idToken,
        'name': name,
        'profilePicture': profilePicture,
        'fcmToken': fcmToken,
      },
    );

    return response.data;
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      '/auth/refresh-token',
      data: {'refreshToken': refreshToken},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getUserDataApi() async {
    final response = await _apiClient.get('/auth/me');

    final data = response.data['data'];

    //here it will return the user object

    return data;
  }

  Future<Map<String, dynamic>> updateFcmTokenApi(String fcmToken) async {
    try {
      final response = await _apiClient.put(
        '/auth/fcm-token',
        data: {'fcmToken': fcmToken},
      );

      return response.data;
    } catch (e) {
      logger.e('Error in updateFcmToken API: $e');
      rethrow;
    }
  }
}
