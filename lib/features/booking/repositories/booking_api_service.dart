import 'package:mlock_flutter/services/api/api_initialization.dart';

class BookingApiService {
  final ApiClient _apiClient;

  BookingApiService(this._apiClient);

  Future<Map<String, dynamic>> createBookingApi({
    required String lockerId,
    required String lockerStationId,
    required String duration,
    required double rentalPrice,
    required int amount,
    required String currency,
  }) async {
    final response = await _apiClient.post(
      '/booking/create',
      data: {
        'lockerId': lockerId,
        'lockerStationId': lockerStationId,
        'duration': duration,
        'rentalPrice': rentalPrice,
        'currency': currency,
        'amount': amount,
      },
    );

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to create booking : ${response.data}');
    }
  }

  Future<Map<String, dynamic>> verifyPaymentApi({
    required String orderId,
    required String paymentId,
    required String signature,
    required String bookingId,
    required String lockerId,
    required String lockerStationId,
    required int amount,
    required String currency,
    required String status,
    required String method,
  }) async {
    final response = await _apiClient.post(
      '/booking/verify',
      data: {
        'orderId': orderId,
        'paymentId': paymentId,
        'signature': signature,
        'lockerId': lockerId,
        'lockerStationId': lockerStationId,
        'amount': amount,
        'currency': currency,
        'status': status,
        'method': method,
        'bookingId': bookingId,
      },
    );

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to verify payment: ${response.data}');
    }
  }
}
