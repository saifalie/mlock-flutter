// rating_event.dart
part of 'rating_bloc.dart';

@immutable
sealed class RatingEvent {}

class SubmitRatingEvent extends RatingEvent {
  final double rating;
  final String? message;
  final String lockerStationId;

  SubmitRatingEvent({
    required this.rating,
    this.message,
    required this.lockerStationId,
  });
}

class SkipRatingEvent extends RatingEvent {}
