import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/bookingTracking/repositories/booking_tracking_api.dart';

class BookingTrackingRepository {
  final BookingTrackingApi _bookingTrackingApi;

  BookingTrackingRepository(this._bookingTrackingApi);

  Future<Map<String, dynamic>> fetchLockerStationDetailsRepo() async {
    try {
      final response = await _bookingTrackingApi.fetchLockerStationDetailsApi();

      logger.d('fetchBookingdetailsRepo method --response--: $response');

      // Return both status and data to let bloc know if it's a "not found" case
      return response;
    } catch (e) {
      logger.e(
        'Error BookingTrackingRepo fetchLockerStationDetailsRepo method: $e',
      );
      rethrow;
    }
  }
}
