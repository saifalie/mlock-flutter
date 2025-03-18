import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mlock_flutter/core/utils/latlng_converter.dart';
import 'package:mlock_flutter/features/auth/models/user/user_model.dart';

part 'locker_station_model.freezed.dart';
part 'locker_station_model.g.dart';

@freezed
abstract class LockerStationModel with _$LockerStationModel {
  const factory LockerStationModel({
    @JsonKey(name: '_id') required String id,
    required String stationName,
    required String status,
    required LocationModel location,
    required String address,
    required List<ImageModel> images,
    @Default([]) List<RatingModel> ratings,
    @Default([]) List<ReviewModel> reviews,
    required List<LockerModel> lockers,
    required List<LockerStationOpeningHoursModel> openingHours,
    List<UserModel>? users,
  }) = _LockerStationModel;

  factory LockerStationModel.fromJson(Map<String, dynamic> json) =>
      _$LockerStationModelFromJson(json);
}

@freezed
abstract class LocationModel with _$LocationModel {
  const factory LocationModel({
    required String type,

    @LatLngConverter() required LatLng coordinates, // Apply converter here
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
}

@freezed
abstract class ImageModel with _$ImageModel {
  const factory ImageModel({required String url}) = _ImageModel;

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);
}

@freezed
abstract class RatingModel with _$RatingModel {
  const factory RatingModel({
    required int rating,
    required UserModel user,
    required LockerStationModel lockerStation,
  }) = _RatingModel;

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);
}

@freezed
abstract class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String message,
    required UserModel user,
    required LockerStationModel lockerStation,
    required bool isVisible,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}

@freezed
abstract class LockerModel with _$LockerModel {
  const factory LockerModel({
    required int lockerNumber,
    required LockerStatus status,
    required DoorStatus doorStatus,
    String? currentUserId,
    required LockerSize size,
    required int rentalPrice,
  }) = _LockerModel;

  factory LockerModel.fromJson(Map<String, dynamic> json) =>
      _$LockerModelFromJson(json);
}

@freezed
abstract class LockerStationOpeningHoursModel
    with _$LockerStationOpeningHoursModel {
  const factory LockerStationOpeningHoursModel({
    required Days day,
    required String opensAt,
    required String closesAt,
    required bool isClosed,
  }) = _LockerStationOpeningHoursModel;

  factory LockerStationOpeningHoursModel.fromJson(Map<String, dynamic> json) =>
      _$LockerStationOpeningHoursModelFromJson(json);
}

enum LockerStatus { available, booked, maintenance }

enum DoorStatus { open, closed }

enum LockerSize { small, medium, large }

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }
