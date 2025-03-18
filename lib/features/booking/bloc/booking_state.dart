part of 'booking_bloc.dart';

enum BookingStatus {
  initial,
  bookingInitiated,
  paymentPending,
  paymentProcessing,
  bookingConfirmed,
  error,
}

class BookingState {
  final BookingStatus status;
  final String? lockerId;
  final String? duration;
  final int? amount;
  final String? orderId;
  final String? paymentId;
  final String? signature;
  final String? error;
  final String? bookingId;
  final String? userName;
  final String? userEmail;
  final String? userPhone;

  const BookingState({
    required this.status,
    this.lockerId,
    this.duration,
    this.amount,
    this.orderId,
    this.paymentId,
    this.signature,
    this.error,
    this.bookingId,
    this.userEmail,
    this.userName,
    this.userPhone,
  });

  factory BookingState.initial() => BookingState(status: BookingStatus.initial);

  factory BookingState.bookingInitiated({
    required String lockerId,
    required String duration,
    required int amount,
    required String userName,
    required String userEmail,
    required String userPhone,
  }) => BookingState(
    status: BookingStatus.bookingInitiated,
    lockerId: lockerId,
    duration: duration,
    amount: amount,
    userEmail: userEmail,
    userName: userName,
    userPhone: userPhone,
  );

  factory BookingState.paymentPending({
    required String lockerId,
    required String duration,
    required int amount,
    required String orderId,
    required String bookingId,
    required String userName,
    required String userEmail,
    required String userPhone,
  }) => BookingState(
    status: BookingStatus.paymentPending,
    lockerId: lockerId,
    duration: duration,
    amount: amount,
    orderId: orderId,
    bookingId: bookingId,
    userName: userName,
    userEmail: userEmail,
    userPhone: userPhone,
  );

  factory BookingState.paymentProcessing({
    required String lockerId,
    required String duration,
    required int amount,
    required String orderId,
    required String paymentId,
    required String signature,
    required String bookingId,
    required String userName,
    required String userEmail,
    required String userPhone,
  }) => BookingState(
    status: BookingStatus.paymentProcessing,
    lockerId: lockerId,
    duration: duration,
    amount: amount,
    orderId: orderId,
    paymentId: paymentId,
    signature: signature,
    bookingId: bookingId,
    userName: userName,
    userEmail: userEmail,
    userPhone: userPhone,
  );

  factory BookingState.bookingConfirmed({
    required String lockerId,
    required String duration,
    required int amount,
    required String orderId,
    required String paymentId,
    required String signature,
    required String bookingId,
    required String userName,
    required String userEmail,
    required String userPhone,
  }) => BookingState(
    status: BookingStatus.bookingConfirmed,

    lockerId: lockerId,
    duration: duration,
    amount: amount,
    orderId: orderId,
    paymentId: paymentId,
    signature: signature,
    bookingId: bookingId,
    userName: userName,
    userEmail: userEmail,
    userPhone: userPhone,
  );

  factory BookingState.error({
    String? lockerId,
    String? duration,
    int? amount,
    String? orderId,
    String? paymentId,
    String? signature,
    String? bookingId,
    String? userName,
    String? userEmail,
    String? userPhone,
    required String error,
  }) => BookingState(
    status: BookingStatus.error,
    lockerId: lockerId,
    duration: duration,
    amount: amount,
    orderId: orderId,
    paymentId: paymentId,
    signature: signature,
    bookingId: bookingId,
    userName: userName,
    userEmail: userEmail,
    userPhone: userPhone,
    error: error,
  );
}
