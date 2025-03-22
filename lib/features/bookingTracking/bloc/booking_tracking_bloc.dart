import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/booking/repositories/booking_repository.dart';
import 'package:mlock_flutter/features/bookingTracking/models/booking_model.dart';
import 'package:mlock_flutter/features/bookingTracking/repositories/booking_tracking_repository.dart';

part 'booking_tracking_event.dart';
part 'booking_tracking_state.dart';

class BookingTrackingBloc
    extends Bloc<BookingTrackingEvent, BookingTrackingState> {
  final BookingTrackingRepository _bookingTrackingRepository;
  final BookingRepository _bookingRepository;
  BookingTrackingBloc({
    required BookingTrackingRepository bookingTrackingRepository,
    required BookingRepository bookingRepository,
  }) : _bookingTrackingRepository = bookingTrackingRepository,
       _bookingRepository = bookingRepository,
       super(BookingTrackingState.initial()) {
    on<FetchBookingDetailsBookingTrackingEvent>(
      _fetchBookingDetailsBookingTrackingEvent,
    );
    on<CheckoutBookingEvent>(_checkoutBookingEvent);
  }

  FutureOr<void> _fetchBookingDetailsBookingTrackingEvent(
    FetchBookingDetailsBookingTrackingEvent event,
    Emitter<BookingTrackingState> emit,
  ) async {
    emit(BookingTrackingState.loading());

    try {
      final result =
          await _bookingTrackingRepository.fetchLockerStationDetailsRepo();

      logger.d('BookingTracking Bloc result: $result');

      if (result['status'] == 'success') {
        final bookingModel = BookingModel.fromJson(result['data']['data']);
        emit(BookingTrackingState.loaded(bookingModel));
      } else if (result['status'] == 'not_found') {
        // Handle the "not found" case differently
        final message = result['data']['message'] ?? 'No active booking found';
        emit(BookingTrackingState.notFound(message));
      }
    } catch (e) {
      logger.e('BookingTrackingBloc Failed to load BookingDetails $e');
      emit(BookingTrackingState.error(e.toString()));
    }
  }

  FutureOr<void> _checkoutBookingEvent(
    CheckoutBookingEvent event,
    Emitter<BookingTrackingState> emit,
  ) async {
    try {
      if (state.booking == null) {
        throw Exception('No active booking found');
      }

      // First emit processing state
      emit(BookingTrackingState.checkoutProcessing(state.booking!));

      // Calculate extra payment if needed
      double extraPayment = 0;

      if (event.hasExtraTime && event.extraTimeSeconds > 0) {
        // Calculate payment based on rental price per minute
        // Convert extra time seconds to minutes and multiply by rental price
        extraPayment = (event.extraTimeSeconds / 60) * event.rentalPrice;

        // If there's an extra payment, handle payment first
        if (extraPayment > 0) {
          // Round up to nearest integer for payment processing
          final int paymentAmount = extraPayment.ceil();

          // Use your existing booking repository to handle the payment
          // Similar to how InitiateBookingEvent works but for extra time
          final result = await _bookingRepository.processExtraTimePaymentRepo(
            bookingId: event.bookingId,
            extraTimeSeconds: event.extraTimeSeconds,
            amount: paymentAmount,
          );

          if (result['status'] != 'success') {
            throw Exception(result['message'] ?? 'Extra time payment failed');
          }
        }
      }

      // Now process the checkout itself
      final checkoutResult = await _bookingRepository.checkoutBookingRepo(
        bookingId: event.bookingId,
        extraTimeSeconds: event.hasExtraTime ? event.extraTimeSeconds : 0,
      );

      // Handle the result and emit success state
      if (checkoutResult['status'] == 'success') {
        // Update booking model with checkout info
        final updatedBooking = BookingModel.fromJson(checkoutResult['data']);
        emit(
          BookingTrackingState.checkoutSuccess(
            updatedBooking,
            extraTimePayment: event.hasExtraTime ? extraPayment : null,
          ),
        );
      } else {
        throw Exception(checkoutResult['message'] ?? 'Checkout failed');
      }
    } catch (e) {
      logger.e('CheckoutBookingEvent error: $e');
      emit(BookingTrackingState.error(e.toString()));
    }
  }
}
