import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';


enum PaymentStatus { PAID, OVERDUE, PENDING }

class BookingModel {
  final String id;
  final String user;
  final Locker? locker;
  final LockerStation? lockerStation;
  final int duration;
  final DateTime? checkinTime;
  final DateTime? checkoutTime;
  final DateTime? userCheckoutTime;
  final int extraTime;
  final double rentalPrice;
  final List<dynamic> payments;
  final PaymentStatus paymentStatus;

  BookingModel({
    required this.id,
    required this.user,
    this.locker,
    this.lockerStation,
    required this.duration,
    this.checkinTime,
    this.checkoutTime,
    this.userCheckoutTime,
    required this.extraTime,
    required this.paymentStatus,
    required this.rentalPrice,
    this.payments = const [],
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    logger.d("=== DEBUG: BookingModel.fromJson ===");
    logger.d("JSON: $json");

    // Log each field separately
    logger.d("_id: ${json['_id']} (${json['_id'].runtimeType})");
    logger.d("user: ${json['user']} (${json['user'].runtimeType})");
    logger.d("locker: ${json['locker']} (${json['locker']?.runtimeType})");
    logger.d(
      "lockerStation: ${json['lockerStation']} (${json['lockerStation']?.runtimeType})",
    );
    logger.d(
      "payments: ${json['payments']} (${json['payments']?.runtimeType})",
    );

    try {
      return BookingModel(
        id: json['_id']?.toString() ?? '',
        user: json['user']?.toString() ?? '',
        locker:
            json['locker'] != null
                ? Locker.fromJson(json['locker'] as Map<String, dynamic>)
                : null,
        lockerStation:
            json['lockerStation'] != null
                ? LockerStation.fromJson(
                  json['lockerStation'] as Map<String, dynamic>,
                )
                : null,
        duration: (json['duration'] as num?)?.toInt() ?? 0,
        checkinTime:
            json['checkinTime'] != null
                ? DateTime.parse(json['checkinTime'].toString())
                : null,
        checkoutTime:
            json['checkoutTime'] != null
                ? DateTime.parse(json['checkoutTime'].toString())
                : null,
        userCheckoutTime:
            json['userCheckoutTime'] != null
                ? DateTime.parse(json['userCheckoutTime'].toString())
                : null,
        extraTime: (json['extraTime'] as num?)?.toInt() ?? 0,
        rentalPrice: (json['rentalPrice'] as num?)?.toDouble() ?? 0.0,
        payments:
            json['payments'] != null
                ? (json['payments'] as List)
                    .map((p) => p?.toString() ?? '')
                    .toList()
                : [],
        paymentStatus: _parsePaymentStatus(json['paymentStatus']),
      );
    } catch (e, stackTrace) {
      logger.e("ERROR in BookingModel.fromJson: $e");
      logger.e("Stack trace: $stackTrace");
      rethrow;
    }
  }

  static PaymentStatus _parsePaymentStatus(dynamic status) {
    if (status == null) return PaymentStatus.OVERDUE;
    final String statusStr = status.toString().toUpperCase();
    return PaymentStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => PaymentStatus.OVERDUE,
    );
  }
}
