import 'package:mlock_flutter/services/api/api_initialization.dart';

class AuthApiServices {
  final ApiClient _apiClient;

  AuthApiServices(this._apiClient);

  Future<Map<String, dynamic>> signInWithGoogle(
    String idToken,
    String? name,
    String? profilePicture,
  ) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: {
        'id_token': idToken,
        'name': name,
        'profile_picture': profilePicture,
      },
    );

    return response.data;
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      '/auth/refresh-token',
      data: {'refresh_token': refreshToken},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getUserDataApi() async {
    final response = await _apiClient.get('/auth/me');

    final data = response.data['data'];

    //here it will return the user object

    return data;
  }
}
