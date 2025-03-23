import 'package:mlock_flutter/services/api/api_initialization.dart';

class RatingandreviewApi {
  final ApiClient _apiClient;

  RatingandreviewApi(this._apiClient);

  Future<void> submitRating(
    double rating,
    String? message,
    String lockerStationId,
  ) async {
    final data = {
      'rating': rating,
      if (message != null && message.isNotEmpty) 'message': message,
      'lockerStationId': lockerStationId,
    };

    await _apiClient.post('/lockerStation/create-rating-review', data: data);
  }
}
