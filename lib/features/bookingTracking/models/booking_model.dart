import 'package:mlock_flutter/features/bookingTracking/models/payment_model.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';

enum PaymentStatus { PAID, OVERDUE, PENDING }

class BookingModel {
  final String id;
  final String user;
  final Locker locker;
  final LockerStation lockerStation;
  final int duration;
  final DateTime? checkinTime;
  final DateTime? checkoutTime;
  final DateTime? userCheckoutTime;
  final int extraTime;
  final double rentalPrice;
  final List<PaymentModel> payments;
  final PaymentStatus paymentStatus;

  BookingModel({
    required this.id,
    required this.user,
    required this.locker,
    required this.lockerStation,
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
    return BookingModel(
      id: json['_id'] as String,
      user: json['user'] as String,
      locker: Locker.fromJson(json['locker'] as Map<String, dynamic>),
      lockerStation: LockerStation.fromJson(
        json['lockerStation'] as Map<String, dynamic>,
      ),
      duration: json['duration'] as int,
      checkinTime:
          json['checkinTime'] != null
              ? DateTime.parse(json['checkinTime'] as String)
              : null,
      checkoutTime:
          json['checkoutTime'] != null
              ? DateTime.parse(json['checkoutTime'] as String)
              : null,
      userCheckoutTime:
          json['userCheckoutTime'] != null
              ? DateTime.parse(json['userCheckoutTime'] as String)
              : null,
      extraTime: json['extraTime'] as int,
      rentalPrice: (json['rentalPrice'] as num).toDouble(),
      payments:
          json['payments'] != null
              ? (json['payments'] as List)
                  .map((p) => PaymentModel.fromJson(p as Map<String, dynamic>))
                  .toList()
              : [],
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) =>
            e.name.toUpperCase() ==
            (json['paymentStatus'] as String).toUpperCase(),
        orElse: () => PaymentStatus.OVERDUE,
      ),
    );
  }
}
