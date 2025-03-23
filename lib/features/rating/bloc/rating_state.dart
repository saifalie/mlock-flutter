part of 'rating_bloc.dart';

enum RatingStatus { initial, loading, success, error }

class RatingState {
  final RatingStatus status;
  final String? error;

  const RatingState({required this.status, this.error});

  factory RatingState.initial() => RatingState(status: RatingStatus.initial);
  factory RatingState.loading() => RatingState(status: RatingStatus.loading);
  factory RatingState.success() => RatingState(status: RatingStatus.success);
  factory RatingState.error(String error) =>
      RatingState(status: RatingStatus.error, error: error);
}
