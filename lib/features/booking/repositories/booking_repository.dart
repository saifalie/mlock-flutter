import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/booking/repositories/booking_api_service.dart';

class BookingRepository {
  final BookingApiService bookingApiService;
  final String razorpayKeyId;

  BookingRepository({
    required this.bookingApiService,
    required this.razorpayKeyId,
  });

  Future<Map<String, dynamic>> createBookingRepo({
    required String lockerId,
    required String lockerStationId,
    required String duration,
    required double rentalPrice,
    required int amount,
    required String currency,
  }) async {
    try {
      final response = await bookingApiService.createBookingApi(
        lockerId: lockerId,
        lockerStationId: lockerStationId,
        duration: duration,
        rentalPrice: rentalPrice,
        amount: amount,
        currency: currency,
      );
      logger.d('createBookingRepo method --response--: $response');
      return response;
    } catch (e) {
      logger.e('Error BookingRepo createBookingRepo method: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyPayment({
    required String orderId,
    required String paymentId,
    required String bookingId,
    required String lockerId,
    required String lockerStationId,
    required String signature,
    required int amount,
    required String currency,
    required String status,
    required String method,
  }) async {
    try {
      final response = await bookingApiService.verifyPaymentApi(
        orderId: orderId,
        paymentId: paymentId,
        signature: signature,
        bookingId: bookingId,
        lockerId: lockerId,
        lockerStationId: lockerStationId,
        amount: amount,
        currency: currency,
        status: status,
        method: method,
      );
      return response['data'];
    } catch (e) {
      logger.e('Faild to verify payment: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> cancelBookingRepo({
    required String bookingId,
    required String reason,
  }) async {
    try {
      final response = await bookingApiService.cancelBookingApi(
        bookingId: bookingId,
        reason: reason,
      );
      logger.d('cancelBookingRepo response: $response');
      return response;
    } catch (e) {
      logger.e('Error cancelling booking: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> processExtraTimePaymentRepo({
    required String bookingId,
    required int extraTimeSeconds,
    required int amount,
  }) async {
    try {
      final response = await bookingApiService.processExtraTimePaymentApi(
        bookingId: bookingId,
        extraTimeSeconds: extraTimeSeconds,
        amount: amount,
      );
      logger.d('processExtraTimePayment response: $response');
      return response;
    } catch (e) {
      logger.e('Error processExtraTimePayment booking: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkoutBookingRepo({
    required String bookingId,
    int extraTimeSeconds = 0,
  }) async {
    try {
      final response = await bookingApiService.checkoutBookingApi(
        bookingId: bookingId,
        extraTimeSeconds: extraTimeSeconds,
      );
      logger.d('checkoutBookingRepo response: $response');
      return response;
    } catch (e) {
      logger.e('Error checkout booking: $e');
      rethrow;
    }
  }
}
