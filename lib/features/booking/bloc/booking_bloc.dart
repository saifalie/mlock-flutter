import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/booking/repositories/booking_repository.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;
  final Razorpay _razorpay = Razorpay();

  BookingBloc({required BookingRepository bookingRepository})
    : _bookingRepository = bookingRepository,
      super(BookingState.initial()) {
    on<InitiateBookingEvent>(_initiateBookingEvent);
    on<ProcessPyamentEvent>(_processPyamentEvent);
    on<CompleteBookingEvent>(_completeBookingEvent);
    on<CancelBookingEvent>(_cancelBookingEvent);

    // Initialize Razorpay
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWalled);
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    logger.d('====== PAYMENT SUCCESS CALLBACK TRIGGERED ======');
    logger.d('PaymentId: ${response.paymentId}');
    logger.d('OrderId: ${response.orderId}');
    logger.d('Signature: ${response.signature}');

    add(
      ProcessPyamentEvent(
        orderId: response.orderId ?? '',
        paymentId: response.paymentId ?? '',
        signature: response.signature ?? '',
      ),
    );
    logger.d('====== PROCESS PAYMENT EVENT DISPATCHED ======');
  }

  _handlePaymentError(PaymentFailureResponse response) {
    logger.d('payment failure');
    add(CancelBookingEvent(error: 'Payment failed ${response.message}'));
  }

  _handleExternalWalled(ExternalWalletResponse response) {
    logger.d('payment external wallet');
    add(
      CancelBookingEvent(
        error: 'External wallet selected ${response.walletName}',
      ),
    );
  }

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }

  FutureOr<void> _initiateBookingEvent(
    InitiateBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      //first set state to booking initiated
      emit(
        BookingState.bookingInitiated(
          lockerId: event.lockerId,
          duration: event.duration,
          amount: event.amount,
          userName: event.userName,
          userEmail: event.userEmail,
          userPhone: event.userPhone,
        ),
      );

      logger.d('Creating booking on server with amount: ${event.amount}');

      // create booking on server

      final response = await _bookingRepository.createBookingRepo(
        lockerId: event.lockerId,
        duration: event.duration,
        rentalPrice: event.rentalPrice,
        amount: event.amount,
        currency: 'INR',
      );

      // Extract booking and payment details
      final paymentDetails = response['data']['payment'];
      final booking = response['data']['booking'];

      logger.d('payment details bloc: $paymentDetails');
      logger.d('booking details bloc: $booking');
      logger.d('payment id bloc: ${paymentDetails['id']}');
      logger.d('booking id bloc: ${booking['_id']}');

      // Set state to payment pending
      emit(
        BookingState.paymentPending(
          lockerId: event.lockerId,
          duration: event.duration,
          amount: event.amount,
          orderId: paymentDetails['id'],
          bookingId: booking['_id'],
          userName: event.userName,
          userEmail: event.userEmail,
          userPhone: event.userPhone,
        ),
      );

      logger.d('razorpaykeyId: ${_bookingRepository.razorpayKeyId}');

      // Prepare Razorpay options
      var options = {
        'key': _bookingRepository.razorpayKeyId,
        'amount': paymentDetails['amount'], // Should be in paise
        'currency': 'INR',
        'name': 'MLock',
        'description': 'Locker Rental',
        'order_id': paymentDetails['id'],
        'prefill': {
          'name': event.userName,
          'email': event.userEmail,
          'contact': event.userPhone,
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

      logger.d('Opening Razorpay checkout with options: $options');

      _razorpay.open(options);
    } catch (e) {
      logger.e('BookingBloc initiatedPayment method error: $e');
      emit(BookingState.error(error: e.toString()));
    }
  }

  FutureOr<void> _processPyamentEvent(
    ProcessPyamentEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      logger.d('====== PROCESSING PAYMENT EVENT ======');
      logger.d('Event details: ${event.orderId}, ${event.paymentId}');
      logger.d('Current state: ${state.status}');
      if (state.status != BookingStatus.paymentPending) {
        throw Exception(
          'Cannot process payment without initiating booking first',
        );
      }

      logger.d(
        'lockerId: ${state.lockerId}, duration: ${state.duration}, amount: ${state.amount}, orderId: ${event.orderId} , paymentId: ${event.paymentId}, signature: ${event.signature}, bookingId: ${state.bookingId}, userName:${state.userName}, userEmail: ${state.userEmail}, userPhone: ${state.userPhone}',
      );

      //Set state to payment processing
      emit(
        BookingState.paymentProcessing(
          lockerId: state.lockerId!,
          duration: state.duration!,
          amount: state.amount!,
          orderId: event.orderId,
          paymentId: event.paymentId,
          signature: event.signature,
          bookingId: state.bookingId!,
          userName: state.userName!,
          userEmail: state.userEmail!,
          userPhone: state.userPhone!,
        ),
      );

      //verify payment with server

      logger.d('Verifying payment with server');
      logger.d('amount: ${state.amount}');

      final verificationResult = await _bookingRepository.verifyPayment(
        orderId: event.orderId,
        paymentId: event.paymentId,
        signature: event.signature,
        bookingId: state.bookingId!,
        lockerId: state.lockerId!,
        amount: state.amount!,
        currency: 'INR',
        status: 'captured',
        method: 'card',
      );
      logger.d('====== EMITTING BOOKING CONFIRMED STATE ======');
      emit(
        BookingState.bookingConfirmed(
          lockerId: state.lockerId!,
          duration: state.duration!,
          amount: state.amount!,
          orderId: state.orderId!,
          paymentId: state.paymentId!,
          signature: state.signature!,
          bookingId: state.bookingId!,
          userName: state.userName!,
          userEmail: state.userEmail!,
          userPhone: state.userPhone!,
        ),
      );
        logger.d('====== BOOKING CONFIRMED STATE EMITTED ======');

      logger.d('Payment verification result: $verificationResult');
    } catch (e) {
      logger.e('Error BookingBlc in process payment method $e');
      emit(
        BookingState.error(
          error: e.toString(),
          lockerId: state.lockerId,
          duration: state.duration,
          amount: state.amount,
          orderId: state.orderId,
          paymentId: state.paymentId,
          signature: state.signature,
          bookingId: state.bookingId,
          userEmail: state.userEmail,
          userName: state.userName,
          userPhone: state.userPhone,
        ),
      );
    }
  }

  FutureOr<void> _completeBookingEvent(
    CompleteBookingEvent event,
    Emitter<BookingState> emit,
  ) {
    //reset state after booking is complete
    emit(BookingState.initial());
  }

  FutureOr<void> _cancelBookingEvent(
    CancelBookingEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(
      BookingState.error(
        error: event.error ?? 'Booking cancelled',
        lockerId: state.lockerId,
        duration: state.duration,
        amount: state.amount,
        orderId: state.orderId,
        paymentId: state.paymentId,
        signature: state.signature,
        bookingId: state.bookingId,
        userName: state.userName,
        userEmail: state.userEmail,
        userPhone: state.userPhone,
      ),
    );
  }
}
