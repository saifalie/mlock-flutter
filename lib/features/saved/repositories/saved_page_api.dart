import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/services/api/api_initialization.dart';

class SavedPageApi {
  final ApiClient _apiClient;

  SavedPageApi(this._apiClient);

  Future<Map<String, dynamic>> getSavdStations() async {
    final response = await _apiClient.get('/lockerStation/saved');

    logger.d('SAVED API DATA: ${response.data}');

    return response.data;
  }
}
