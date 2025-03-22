import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/services/api/api_initialization.dart';

class BookingTrackingApi {
  final ApiClient _apiClient;

  BookingTrackingApi(this._apiClient);
  Future<Map<String, dynamic>> fetchLockerStationDetailsApi() async {
    final response = await _apiClient.get('/booking/tracking');

    logger.d('bookingTracking api data: $response');

    if (response.statusCode == 200) {
      return {'status': 'success', 'data': response.data};
    } else if (response.statusCode == 404) {
      return {'status': 'not_found', 'data': response.data};
    } else {
      throw Exception(
        'Failed to get the lockerStation Details : ${response.data}',
      );
    }
  }
}
