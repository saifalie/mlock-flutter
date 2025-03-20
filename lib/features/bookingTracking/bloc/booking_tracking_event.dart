import 'package:flutter/material.dart';

@immutable
sealed class BookingTrackingEvent {}

class FetchBookingDetailsEvent extends BookingTrackingEvent {}
