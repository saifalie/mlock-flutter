// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locker_station_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LockerStationModel _$LockerStationModelFromJson(Map<String, dynamic> json) =>
    _LockerStationModel(
      id: json['_id'] as String,
      stationName: json['stationName'] as String,
      status: json['status'] as String,
      location: LocationModel.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      address: json['address'] as String,
      images:
          (json['images'] as List<dynamic>)
              .map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      ratings:
          (json['ratings'] as List<dynamic>?)
              ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lockers:
          (json['lockers'] as List<dynamic>)
              .map((e) => LockerModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      openingHours:
          (json['openingHours'] as List<dynamic>)
              .map(
                (e) => LockerStationOpeningHoursModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      users:
          (json['users'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$LockerStationModelToJson(_LockerStationModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'stationName': instance.stationName,
      'status': instance.status,
      'location': instance.location,
      'address': instance.address,
      'images': instance.images,
      'ratings': instance.ratings,
      'reviews': instance.reviews,
      'lockers': instance.lockers,
      'openingHours': instance.openingHours,
      'users': instance.users,
    };

_LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    _LocationModel(
      type: json['type'] as String,
      coordinates: const LatLngConverter().fromJson(
        json['coordinates'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$LocationModelToJson(_LocationModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': const LatLngConverter().toJson(instance.coordinates),
    };

_ImageModel _$ImageModelFromJson(Map<String, dynamic> json) =>
    _ImageModel(url: json['url'] as String);

Map<String, dynamic> _$ImageModelToJson(_ImageModel instance) =>
    <String, dynamic>{'url': instance.url};

_RatingModel _$RatingModelFromJson(Map<String, dynamic> json) => _RatingModel(
  rating: (json['rating'] as num).toInt(),
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  lockerStation: LockerStationModel.fromJson(
    json['lockerStation'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$RatingModelToJson(_RatingModel instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'user': instance.user,
      'lockerStation': instance.lockerStation,
    };

_ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => _ReviewModel(
  message: json['message'] as String,
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  lockerStation: LockerStationModel.fromJson(
    json['lockerStation'] as Map<String, dynamic>,
  ),
  isVisible: json['isVisible'] as bool,
);

Map<String, dynamic> _$ReviewModelToJson(_ReviewModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user,
      'lockerStation': instance.lockerStation,
      'isVisible': instance.isVisible,
    };

_LockerModel _$LockerModelFromJson(Map<String, dynamic> json) => _LockerModel(
  lockerNumber: (json['lockerNumber'] as num).toInt(),
  status: $enumDecode(_$LockerStatusEnumMap, json['status']),
  doorStatus: $enumDecode(_$DoorStatusEnumMap, json['doorStatus']),
  currentUserId: json['currentUserId'] as String?,
  size: $enumDecode(_$LockerSizeEnumMap, json['size']),
  rentalPrice: (json['rentalPrice'] as num).toInt(),
);

Map<String, dynamic> _$LockerModelToJson(_LockerModel instance) =>
    <String, dynamic>{
      'lockerNumber': instance.lockerNumber,
      'status': _$LockerStatusEnumMap[instance.status]!,
      'doorStatus': _$DoorStatusEnumMap[instance.doorStatus]!,
      'currentUserId': instance.currentUserId,
      'size': _$LockerSizeEnumMap[instance.size]!,
      'rentalPrice': instance.rentalPrice,
    };

const _$LockerStatusEnumMap = {
  LockerStatus.available: 'available',
  LockerStatus.booked: 'booked',
  LockerStatus.maintenance: 'maintenance',
};

const _$DoorStatusEnumMap = {
  DoorStatus.open: 'open',
  DoorStatus.closed: 'closed',
};

const _$LockerSizeEnumMap = {
  LockerSize.small: 'small',
  LockerSize.medium: 'medium',
  LockerSize.large: 'large',
};

_LockerStationOpeningHoursModel _$LockerStationOpeningHoursModelFromJson(
  Map<String, dynamic> json,
) => _LockerStationOpeningHoursModel(
  day: $enumDecode(_$DaysEnumMap, json['day']),
  opensAt: json['opensAt'] as String,
  closesAt: json['closesAt'] as String,
  isClosed: json['isClosed'] as bool,
);

Map<String, dynamic> _$LockerStationOpeningHoursModelToJson(
  _LockerStationOpeningHoursModel instance,
) => <String, dynamic>{
  'day': _$DaysEnumMap[instance.day]!,
  'opensAt': instance.opensAt,
  'closesAt': instance.closesAt,
  'isClosed': instance.isClosed,
};

const _$DaysEnumMap = {
  Days.monday: 'monday',
  Days.tuesday: 'tuesday',
  Days.wednesday: 'wednesday',
  Days.thursday: 'thursday',
  Days.friday: 'friday',
  Days.saturday: 'saturday',
  Days.sunday: 'sunday',
};
