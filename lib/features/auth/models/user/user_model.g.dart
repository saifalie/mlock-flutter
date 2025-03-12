// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  profilePicture: json['profilePicture'] as String?,
  currentLocker: json['currentLocker'] as String?,
  coordinates: json['coordinates'] as List<dynamic>?,
  favourite:
      (json['favourite'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  history:
      (json['history'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
      'currentLocker': instance.currentLocker,
      'coordinates': instance.coordinates,
      'favourite': instance.favourite,
      'history': instance.history,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
