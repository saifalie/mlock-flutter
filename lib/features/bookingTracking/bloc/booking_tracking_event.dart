part of 'booking_tracking_bloc.dart';

@immutable
sealed class BookingTrackingEvent {}

class FetchBookingDetailsBookingTrackingEvent extends BookingTrackingEvent {}

// Add this new event
class CheckoutBookingEvent extends BookingTrackingEvent {
  final String bookingId;
  final bool hasExtraTime;
  final int extraTimeSeconds;
  final double rentalPrice;
  final String userEmail;
  final String userPhone;
  final String userName;

  CheckoutBookingEvent({
    required this.bookingId,
    required this.hasExtraTime,
    required this.extraTimeSeconds,
    required this.rentalPrice,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
  });
}

class InitiateCheckoutPayment extends BookingTrackingEvent {
  final String bookingId;
  final int amount;

  final String userEmail;
  final String userPhone;
  final String userName;

  InitiateCheckoutPayment({
    required this.bookingId,
    required this.amount,

    required this.userEmail,
    required this.userPhone,
    required this.userName,
  });
}

class ProcessCheckoutPayment extends BookingTrackingEvent {
  final String orderId;
  final String paymentId;
  final String signature;
  final int amount;

  ProcessCheckoutPayment({
    required this.orderId,
    required this.paymentId,
    required this.signature,
    required this.amount,
  });
}

class DirectCheckoutEvent extends BookingTrackingEvent {
  final String bookingId;

  DirectCheckoutEvent({required this.bookingId});
}

class CheckoutFailedEvent extends BookingTrackingEvent {
  final String error;

  CheckoutFailedEvent({required this.error});
}
