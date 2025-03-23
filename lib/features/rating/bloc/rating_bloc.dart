// rating_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/rating/repositories/ratingandreview_repo.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingandreviewRepo _ratingandreviewRepo;

  RatingBloc({required RatingandreviewRepo ratingandreviewRepo})
    : _ratingandreviewRepo = ratingandreviewRepo,
      super(RatingState.initial()) {
    on<SubmitRatingEvent>(_submitRating);
    on<SkipRatingEvent>(_skipRating);
  }

  FutureOr<void> _submitRating(
    SubmitRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingState.loading());
    try {
      await _ratingandreviewRepo.submitRating(
        event.rating,
        event.message,
        event.lockerStationId,
      );
      emit(RatingState.success());
    } catch (e) {
      logger.e('Rating submission error: $e');
      emit(RatingState.error(e.toString()));
    }
  }

  FutureOr<void> _skipRating(SkipRatingEvent event, Emitter<RatingState> emit) {
    emit(RatingState.success()); // Directly go to success state
  }
}
