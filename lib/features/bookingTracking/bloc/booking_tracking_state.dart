part of 'booking_tracking_bloc.dart';

enum BookingTrackingStatus {
  initial,
  loading,
  loaded,
  error,
  notFound,
  checkoutProcessing,
  checkoutSuccess,
}

@immutable
class BookingTrackingState {
  final BookingTrackingStatus status;
  final BookingModel? booking;
  final String? error;
  final double? extraTimePayment;

  const BookingTrackingState({
    required this.status,
    this.booking,
    this.error,
    this.extraTimePayment,
  });

  //inital
  factory BookingTrackingState.initial() =>
      BookingTrackingState(status: BookingTrackingStatus.initial);

  //loading
  factory BookingTrackingState.loading() =>
      BookingTrackingState(status: BookingTrackingStatus.loading);

  // loaded
  factory BookingTrackingState.loaded(BookingModel booking) =>
      BookingTrackingState(
        status: BookingTrackingStatus.loaded,
        booking: booking,
      );

  // error
  factory BookingTrackingState.error(String? error) =>
      BookingTrackingState(status: BookingTrackingStatus.error, error: error);

  // notFound
  factory BookingTrackingState.notFound(String? message) =>
      BookingTrackingState(
        status: BookingTrackingStatus.notFound,
        error: message,
      );

  // checkoutProcessing
  factory BookingTrackingState.checkoutProcessing(BookingModel booking) {
    return BookingTrackingState(
      status: BookingTrackingStatus.checkoutProcessing,
      booking: booking,
    );
  }

  //checkout success
  factory BookingTrackingState.checkoutSuccess(
    BookingModel booking, {
    double? extraTimePayment,
  }) {
    return BookingTrackingState(
      status: BookingTrackingStatus.checkoutSuccess,
      booking: booking,
      extraTimePayment: extraTimePayment,
    );
  }
}
