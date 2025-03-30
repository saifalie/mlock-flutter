import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/services/api/api_initialization.dart';

class StationDetailApi {
  final ApiClient _apiClient;

  StationDetailApi(this._apiClient);

  Future<Map<String, dynamic>> fetchParticularStation({
    required String stationId,
  }) async {
    final response = await _apiClient.get('/lockerStation/$stationId');

    logger.d('station detail api: ${response.data}');

    return response.data;
  }

  Future<Map<String, dynamic>> toggleSaveStation(String stationId) async {
    final response = await _apiClient.put('/lockerStation/$stationId/save');
    return response.data;
  }

  Future<Map<String, dynamic>> checkSavedStatus(String stationId) async {
    final response = await _apiClient.get(
      '/lockerStation/$stationId/saved-status',
    );

    return response.data;
  }
}
