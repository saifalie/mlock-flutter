import 'package:mlock_flutter/core/utils/logger.dart';
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

  Future<Map<String, dynamic>> cancelBookingApi({
    required String bookingId,
    required String reason,
  }) async {
    final response = await _apiClient.post(
      '/booking/cancel',
      data: {'bookingId': bookingId, 'reason': reason},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to cancel booking: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> processExtraTimePaymentApi({
    required String bookingId,
    required int amount,
    required int extraTimeSeconds,
  }) async {
    final response = await _apiClient.post(
      '/booking/extra-time-payment',
      data: {
        'bookingId': bookingId,
        'amount': amount,
        'extraTimeSeconds': extraTimeSeconds,
      },
    );

    if (response.statusCode == 200) {
      logger.d('processExtraTimePaymentApi method data: ${response.data}');
      return response.data;
    } else {
      throw Exception('Extra time payment failed: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> verifyCheckoutPaymentApi({
    required String orderId,
    required String paymentId,
    required String signature,
    required String bookingId,
    required int amount,
  }) async {
    final response = await _apiClient.post(
      '/booking/verify-checkout',
      data: {
        'orderId': orderId,
        'paymentId': paymentId,
        'signature': signature,
        'bookingId': bookingId,
        'amount': amount,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Payment verification failed: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> directCheckoutApi({
    required String bookingId,
  }) async {
    final response = await _apiClient.post(
      '/booking/direct-checkout',
      data: {'bookingId': bookingId},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Direct checkout failed: ${response.data}');
    }
  }
}
