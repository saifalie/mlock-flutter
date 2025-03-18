part of 'booking_bloc.dart';

@immutable
sealed class BookingEvent {}

class InitiateBookingEvent extends BookingEvent {
  final String lockerId;
  final String duration;
  final int amount;
  final double rentalPrice;
  final String userName;
  final String userEmail;
  final String userPhone;

  InitiateBookingEvent({
    required this.lockerId,
    required this.duration,
    required this.amount,
    required this.rentalPrice,
    required this.userEmail,
    required this.userName,
    required this.userPhone,
  });
}

class ProcessPyamentEvent extends BookingEvent {
  final String orderId;
  final String paymentId;
  final String signature;

  ProcessPyamentEvent({
    required this.orderId,
    required this.paymentId,
    required this.signature,
  });
}

class CompleteBookingEvent extends BookingEvent {}

class CancelBookingEvent extends BookingEvent {
  final String? error;
  CancelBookingEvent({this.error});
}
