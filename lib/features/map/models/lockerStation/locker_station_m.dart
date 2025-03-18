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
    return LockerStation(
      id: json['_id'] as String,
      stationName: json['stationName'] as String,
      status: json['status'] as String,
      location: StationLocation.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      address: json['address'] as String,
      images:
          json['images'] != null
              ? (json['images'] as List)
                  .map(
                    (img) => LockerImage.fromJson(img as Map<String, dynamic>),
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
                    (r) => RatingAndReview.fromJson(r as Map<String, dynamic>),
                  )
                  .toList()
              : [],
      averageRating:
          json['averageRating'] != null
              ? (json['averageRating'] as num).toDouble()
              : null,
    );
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
    return OpeningHours(
      day: json['day'] as String,
      opensAt: json['opensAt'] as String,
      closesAt: json['closesAt'] as String,
      isClosed: json['isClosed'] as bool,
    );
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
    return Locker(
      id: json['_id'] as String,
      lockerNumber: json['lockerNumber'] as int,
      status: json['status'] as String,
      doorStatus: json['doorStatus'] as String,
      size: json['size'] as String,
      rentalPrice: (json['rentalPrice'] as num).toDouble(),
    );
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
      id: json['_id'] as String,
      rating: json['rating'] as int,
      message: json['message'] as String?,
      userId:
          json['user'] is String
              ? json['user'] as String
              : json['user']['_id'] as String,
      isVisible: json['isVisible'] as bool,
    );
  }
}
