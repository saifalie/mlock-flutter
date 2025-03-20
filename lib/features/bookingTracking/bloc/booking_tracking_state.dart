import 'package:mlock_flutter/features/bookingTracking/models/booking_model.dart';

enum BookingTrackingStatus { initial, loading, loaded, error }

class BookingTrackingState {
  final BookingTrackingStatus status;
  final BookingModel? booking;
  final String? error;

  BookingTrackingState({required this.status, this.booking, this.error});

  factory BookingTrackingState.initial() =>
      BookingTrackingState(status: BookingTrackingStatus.initial);

  factory BookingTrackingState.loading() =>
      BookingTrackingState(status: BookingTrackingStatus.loading);

  factory BookingTrackingState.error(String? error) =>
      BookingTrackingState(status: BookingTrackingStatus.error, error: error);


}
