part of 'booking_tracking_bloc.dart';

@immutable
sealed class BookingTrackingEvent {}

class FetchBookingDetailsBookingTrackingEvent extends BookingTrackingEvent {}

// Add this new event
class CheckoutBookingEvent extends BookingTrackingEvent {
  final String bookingId;
  final bool hasExtraTime;
  final int extraTimeSeconds;
  final double rentalPrice; // Price per minute

  CheckoutBookingEvent({
    required this.bookingId,
    required this.hasExtraTime,
    required this.extraTimeSeconds,
    required this.rentalPrice,
  });
}
