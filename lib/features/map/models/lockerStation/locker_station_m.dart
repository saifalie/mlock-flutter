import 'package:mlock_flutter/core/utils/logger.dart';

class LockerStation {
  final String id;
  final String stationName;
  final String status;
  final StationLocation location;
  final String address;
  final List<LockerImage> images;
  final List<OpeningHours> openingHours;
  final List<Locker> lockers; // No longer nullable
  final List<RatingAndReview> ratingAndReviews; // No longer nullable
  final double? averageRating;

  LockerStation({
    required this.id,
    required this.stationName,
    required this.status,
    required this.location,
    required this.address,
    required this.images,
    required this.openingHours,
    this.lockers = const [], // Default to empty list
    this.ratingAndReviews = const [], // Default to empty list
    this.averageRating,
  });

  // Simple fromJson converter
  factory LockerStation.fromJson(Map<String, dynamic> json) {
    try {
      return LockerStation(
        id: json['_id']?.toString() ?? '',
        stationName: json['stationName']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        location: StationLocation.fromJson(
          json['location'] as Map<String, dynamic>,
        ),
        address: json['address']?.toString() ?? '',
        images:
            json['images'] != null
                ? (json['images'] as List)
                    .map(
                      (img) =>
                          LockerImage.fromJson(img as Map<String, dynamic>),
                    )
                    .toList()
                : [],
        openingHours:
            json['openingHours'] != null
                ? (json['openingHours'] as List)
                    .map(
                      (oh) => OpeningHours.fromJson(oh as Map<String, dynamic>),
                    )
                    .toList()
                : [],
        // Always return a list (empty if needed)
        lockers:
            json['lockers'] != null &&
                    json['lockers'] is List &&
                    (json['lockers'] as List).isNotEmpty &&
                    (json['lockers'][0] is Map<String, dynamic>)
                ? (json['lockers'] as List)
                    .map((l) => Locker.fromJson(l as Map<String, dynamic>))
                    .toList()
                : [],
        ratingAndReviews:
            json['ratingAndReviews'] != null &&
                    json['ratingAndReviews'] is List &&
                    (json['ratingAndReviews'] as List).isNotEmpty &&
                    (json['ratingAndReviews'][0] is Map<String, dynamic>)
                ? (json['ratingAndReviews'] as List)
                    .map(
                      (r) =>
                          RatingAndReview.fromJson(r as Map<String, dynamic>),
                    )
                    .toList()
                : [],
        averageRating:
            json['averageRating'] != null
                ? (json['averageRating'] as num).toDouble()
                : null,
      );
    } catch (e, stackTrace) {
      logger.e("ERROR in LockerStation.fromJson: $e");
      logger.e("Stack trace: $stackTrace");
      rethrow;
    }
  }
}

class StationLocation {
  final String type;
  final List<double> coordinates;

  StationLocation({required this.type, required this.coordinates});

  factory StationLocation.fromJson(Map<String, dynamic> json) {
    return StationLocation(
      type: json['type'] as String,
      coordinates:
          (json['coordinates'] as List)
              .map((c) => (c as num).toDouble())
              .toList(),
    );
  }
}

class LockerImage {
  final String url;

  LockerImage({required this.url});

  factory LockerImage.fromJson(Map<String, dynamic> json) {
    return LockerImage(url: json['url'] as String);
  }
}

class OpeningHours {
  final String day;
  final String opensAt;
  final String closesAt;
  final bool isClosed;

  OpeningHours({
    required this.day,
    required this.opensAt,
    required this.closesAt,
    required this.isClosed,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    try {
      return OpeningHours(
        day: json['day']?.toString() ?? '',
        opensAt: json['opensAt']?.toString() ?? '',
        closesAt: json['closesAt']?.toString() ?? '',
        isClosed: json['isClosed'] as bool? ?? false,
      );
    } catch (e) {
      logger.e("ERROR in OpeningHours.fromJson: $e");
      rethrow;
    }
  }
}

class Locker {
  final String id;
  final int lockerNumber;
  final String status;
  final String doorStatus;
  final String size;
  final double rentalPrice;

  Locker({
    required this.id,
    required this.lockerNumber,
    required this.status,
    required this.doorStatus,
    required this.size,
    required this.rentalPrice,
  });
  factory Locker.fromJson(Map<String, dynamic> json) {
    try {
      return Locker(
        id: json['_id']?.toString() ?? '',
        lockerNumber: (json['lockerNumber'] as num?)?.toInt() ?? 0,
        status: json['status']?.toString() ?? '',
        doorStatus: json['doorStatus']?.toString() ?? '',
        size: json['size']?.toString() ?? '',
        rentalPrice: (json['rentalPrice'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e, stackTrace) {
      logger.e("ERROR in Locker.fromJson: $e");
      logger.e("Stack trace: $stackTrace");
      rethrow;
    }
  }
}

class RatingAndReview {
  final String id;
  final int rating;
  final String? message;
  final String userId;
  final bool isVisible;

  RatingAndReview({
    required this.id,
    required this.rating,
    this.message,
    required this.userId,
    required this.isVisible,
  });

  factory RatingAndReview.fromJson(Map<String, dynamic> json) {
    return RatingAndReview(
      id: json['_id']?.toString() ?? '', // Handle null
      rating: (json['rating'] as int?) ?? 0, // Default value
      message: json['message']?.toString(),
      userId:
          json['user'] is String
              ? json['user'] as String
              : json['user']?['_id']?.toString() ?? '', // Handle nested or null
      isVisible: json['isVisible'] as bool? ?? false,
    );
  }
}
