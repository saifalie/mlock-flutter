import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/booking/repositories/booking_repository.dart';
import 'package:mlock_flutter/features/bookingTracking/models/booking_model.dart';
import 'package:mlock_flutter/features/bookingTracking/repositories/booking_tracking_repository.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

part 'booking_tracking_event.dart';
part 'booking_tracking_state.dart';

class BookingTrackingBloc
    extends Bloc<BookingTrackingEvent, BookingTrackingState> {
  final BookingTrackingRepository _bookingTrackingRepository;
  final BookingRepository _bookingRepository;
  final Razorpay _razorpay = Razorpay();
  final String _razorpayKeyId;

  BookingTrackingBloc({
    required BookingTrackingRepository bookingTrackingRepository,
    required BookingRepository bookingRepository,
    required String razorpayKeyId,
  }) : _bookingTrackingRepository = bookingTrackingRepository,
       _bookingRepository = bookingRepository,
       _razorpayKeyId = razorpayKeyId,
       super(BookingTrackingState.initial()) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    on<FetchBookingDetailsBookingTrackingEvent>(
      _fetchBookingDetailsBookingTrackingEvent,
    );
    on<CheckoutBookingEvent>(_handleCheckout);
    on<InitiateCheckoutPayment>(_initiateCheckoutPayment);
    on<ProcessCheckoutPayment>(_processCheckoutPayment);
    on<DirectCheckoutEvent>(_directCheckout);
    on<CheckoutFailedEvent>(_handleCheckoutFailure);
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
        final message = result['data']['message'] ?? 'No active booking found';
        emit(BookingTrackingState.notFound(message));
      }
    } catch (e) {
      logger.e('BookingTrackingBloc Failed to load BookingDetails $e');
      emit(BookingTrackingState.error(e.toString()));
    }
  }

  FutureOr<void> _handleCheckout(
    CheckoutBookingEvent event,
    Emitter<BookingTrackingState> emit,
  ) async {
    if (state.booking == null) return;

    try {
      final booking = state.booking!;
      final extraPayment =
          event.hasExtraTime
              ? (event.extraTimeSeconds / 60) * event.rentalPrice
              : 0;

      if (event.hasExtraTime && extraPayment > 0) {
        emit(
          BookingTrackingState.checkoutPaymentPending(
            booking: booking,
            orderId: '', // Will be set after payment initiation
            userName: event.userName,
            userEmail: event.userEmail,
            userPhone: event.userPhone,
          ),
        );

        add(
          InitiateCheckoutPayment(
            bookingId: booking.id,
            amount: extraPayment.ceil(),
            userEmail: event.userEmail,
            userPhone: event.userPhone,
            userName: event.userName,
          ),
        );
      } else {
        add(DirectCheckoutEvent(bookingId: booking.id));
      }
    } catch (e) {
      emit(BookingTrackingState.error(e.toString()));
    }
  }

  FutureOr<void> _initiateCheckoutPayment(
    InitiateCheckoutPayment event,
    Emitter<BookingTrackingState> emit,
  ) async {
    try {
      final response = await _bookingRepository.processExtraTimePaymentRepo(
        bookingId: event.bookingId,
        amount: event.amount,
        extraTimeSeconds: state.booking!.extraTime,
      );

      // Correctly extract payment details from response
      final paymentData = response['payment'];
      final orderId = paymentData['id'];
      final amountInPaise = paymentData['amount'];

      logger.d(
        'key: $_razorpayKeyId , amount: $amountInPaise , order_id: $orderId , ',
      );

      final options = {
        'key': _razorpayKeyId,
        'amount': amountInPaise,
        'currency': 'INR',
        'name': 'MLock Extra Time',
        'description': 'Locker Rental',
        'order_id': orderId,
        'prefill': {
          'email': event.userEmail,
          'contact': event.userPhone,
          'name': event.userName,
        },
        'theme': {'color': '#3f51b5'},
        'method': {
          'upi': true,
          'netbanking': true,
          'card': false,
          'wallet': true,
          'emi': true,
        },
        'config': {
          'display': {
            'blocks': {
              'upi': {
                'name': 'Pay using UPI',
                'instruments': [
                  {
                    'method': 'upi',
                    'flows': ['intent', 'collect'],
                    'apps': [], // Empty array to show all available UPI apps
                  },
                ],
              },
            },
            'sequence': [
              'block.upi',
              'block.netbanking',
              'block.wallet',
              'block.card',
            ],
            'preferences': {'show_default_blocks': true},
          },
        },
      };

      // Update state with actual order ID
      emit(
        BookingTrackingState.checkoutPaymentPending(
          booking: state.booking!,
          orderId: orderId,
          userName: event.userName,
          userEmail: event.userEmail,
          userPhone: event.userPhone,
        ),
      );

      _razorpay.open(options);
    } catch (e) {
      logger.e('Paymetn initiation failed: $e');
      add(
        CheckoutFailedEvent(
          error: 'Payment initiation failed: ${e.toString()}',
        ),
      );
    }
  }

  FutureOr<void> _processCheckoutPayment(
    ProcessCheckoutPayment event,
    Emitter<BookingTrackingState> emit,
  ) async {
    if (state.booking == null) return;

    try {
      emit(BookingTrackingState.checkoutProcessing(state.booking!));

      // Verify payment first
      await _bookingRepository.verifyCheckoutPaymentRepo(
        orderId: event.orderId,
        paymentId: event.paymentId,
        signature: event.signature,
        bookingId: state.booking!.id,
        amount: event.amount,
      );

      // Process final checkout
      final checkoutResult = await _bookingRepository.directCheckoutRepo(
        bookingId: state.booking!.id,
      );

      emit(
        BookingTrackingState.checkoutSuccess(
          booking: BookingModel.fromJson(checkoutResult['data']),
          extraTimePayment:
              state.booking!.extraTime * state.booking!.rentalPrice / 60,
        ),
      );
    } catch (e) {
      logger.e('Payment processing failed: $e');
      add(
        CheckoutFailedEvent(
          error: 'Payment processing failed: ${e.toString()}',
        ),
      );
    }
  }

  FutureOr<void> _directCheckout(
    DirectCheckoutEvent event,
    Emitter<BookingTrackingState> emit,
  ) async {
    try {
      emit(BookingTrackingState.checkoutProcessing(state.booking!));

      final result = await _bookingRepository.directCheckoutRepo(
        bookingId: event.bookingId,
      );

      emit(
        BookingTrackingState.checkoutSuccess(
          booking: BookingModel.fromJson(result['data']),
        ),
      );
    } catch (e) {
      logger.e('Checkout failed: $e');
      emit(BookingTrackingState.error('Checkout failed: ${e.toString()}'));
    }
  }

  FutureOr<void> _handleCheckoutFailure(
    CheckoutFailedEvent event,
    Emitter<BookingTrackingState> emit,
  ) {
    emit(BookingTrackingState.paymentFailure(event.error));
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (state.status == BookingTrackingStatus.checkoutPaymentPending) {
      add(
        ProcessCheckoutPayment(
          orderId: response.orderId!,
          paymentId: response.paymentId!,
          signature: response.signature!,
          amount: state.booking!.extraTime * state.booking!.rentalPrice ~/ 60,
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    add(CheckoutFailedEvent(error: response.message ?? 'Payment failed'));
  }

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }
}
