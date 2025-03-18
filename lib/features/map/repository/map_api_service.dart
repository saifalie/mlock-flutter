
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/services/api/api_initialization.dart';

class MapApiService {
  final ApiClient _apiClient;

  MapApiService(this._apiClient);

  Future<Map<String, dynamic>> fetchNearbyLockerStation({
    required String latitude,
    required String longitude,
  }) async {
    final response = await _apiClient.get(
      '/lockerStation/nearMe?latitude=$latitude&longitude=$longitude',
    );

    logger.d(response.data);
    return response.data;
  }

  Future<Map<String, dynamic>> getAllLockerStation() async {
    final response = await _apiClient.get('/lockerStation');
    logger.d(response.data);
    return response.data;
  }
}
