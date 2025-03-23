import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/rating/repositories/ratingandreview_api.dart';

class RatingandreviewRepo {
  final RatingandreviewApi _ratingandreviewApi;

  RatingandreviewRepo(this._ratingandreviewApi);

  Future<void> submitRating(
    double rating,
    String? message,
    String lockerStationId,
  ) async {
    try {
      await _ratingandreviewApi.submitRating(rating, message, lockerStationId);
    } catch (e) {
      logger.e('RatingRepo error: $e');
      rethrow;
    }
  }
}
