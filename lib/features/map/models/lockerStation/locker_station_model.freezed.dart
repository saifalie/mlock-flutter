// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'locker_station_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LockerStationModel {

@JsonKey(name: '_id') String get id; String get stationName; String get status; LocationModel get location; String get address; List<ImageModel> get images; List<RatingModel> get ratings; List<ReviewModel> get reviews; List<LockerModel> get lockers; List<LockerStationOpeningHoursModel> get openingHours; List<UserModel>? get users;
/// Create a copy of LockerStationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LockerStationModelCopyWith<LockerStationModel> get copyWith => _$LockerStationModelCopyWithImpl<LockerStationModel>(this as LockerStationModel, _$identity);

  /// Serializes this LockerStationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockerStationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.status, status) || other.status == status)&&(identical(other.location, location) || other.location == location)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.ratings, ratings)&&const DeepCollectionEquality().equals(other.reviews, reviews)&&const DeepCollectionEquality().equals(other.lockers, lockers)&&const DeepCollectionEquality().equals(other.openingHours, openingHours)&&const DeepCollectionEquality().equals(other.users, users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,stationName,status,location,address,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(ratings),const DeepCollectionEquality().hash(reviews),const DeepCollectionEquality().hash(lockers),const DeepCollectionEquality().hash(openingHours),const DeepCollectionEquality().hash(users));

@override
String toString() {
  return 'LockerStationModel(id: $id, stationName: $stationName, status: $status, location: $location, address: $address, images: $images, ratings: $ratings, reviews: $reviews, lockers: $lockers, openingHours: $openingHours, users: $users)';
}


}

/// @nodoc
abstract mixin class $LockerStationModelCopyWith<$Res>  {
  factory $LockerStationModelCopyWith(LockerStationModel value, $Res Function(LockerStationModel) _then) = _$LockerStationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String stationName, String status, LocationModel location, String address, List<ImageModel> images, List<RatingModel> ratings, List<ReviewModel> reviews, List<LockerModel> lockers, List<LockerStationOpeningHoursModel> openingHours, List<UserModel>? users
});


$LocationModelCopyWith<$Res> get location;

}
/// @nodoc
class _$LockerStationModelCopyWithImpl<$Res>
    implements $LockerStationModelCopyWith<$Res> {
  _$LockerStationModelCopyWithImpl(this._self, this._then);

  final LockerStationModel _self;
  final $Res Function(LockerStationModel) _then;

/// Create a copy of LockerStationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? stationName = null,Object? status = null,Object? location = null,Object? address = null,Object? images = null,Object? ratings = null,Object? reviews = null,Object? lockers = null,Object? openingHours = null,Object? users = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stationName: null == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationModel,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ImageModel>,ratings: null == ratings ? _self.ratings : ratings // ignore: cast_nullable_to_non_nullable
as List<RatingModel>,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<ReviewModel>,lockers: null == lockers ? _self.lockers : lockers // ignore: cast_nullable_to_non_nullable
as List<LockerModel>,openingHours: null == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as List<LockerStationOpeningHoursModel>,users: freezed == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<UserModel>?,
  ));
}
/// Create a copy of LockerStationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationModelCopyWith<$Res> get location {
  
  return $LocationModelCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _LockerStationModel implements LockerStationModel {
  const _LockerStationModel({@JsonKey(name: '_id') required this.id, required this.stationName, required this.status, required this.location, required this.address, required final  List<ImageModel> images, final  List<RatingModel> ratings = const [], final  List<ReviewModel> reviews = const [], required final  List<LockerModel> lockers, required final  List<LockerStationOpeningHoursModel> openingHours, final  List<UserModel>? users}): _images = images,_ratings = ratings,_reviews = reviews,_lockers = lockers,_openingHours = openingHours,_users = users;
  factory _LockerStationModel.fromJson(Map<String, dynamic> json) => _$LockerStationModelFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String stationName;
@override final  String status;
@override final  LocationModel location;
@override final  String address;
 final  List<ImageModel> _images;
@override List<ImageModel> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

 final  List<RatingModel> _ratings;
@override@JsonKey() List<RatingModel> get ratings {
  if (_ratings is EqualUnmodifiableListView) return _ratings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ratings);
}

 final  List<ReviewModel> _reviews;
@override@JsonKey() List<ReviewModel> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}

 final  List<LockerModel> _lockers;
@override List<LockerModel> get lockers {
  if (_lockers is EqualUnmodifiableListView) return _lockers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lockers);
}

 final  List<LockerStationOpeningHoursModel> _openingHours;
@override List<LockerStationOpeningHoursModel> get openingHours {
  if (_openingHours is EqualUnmodifiableListView) return _openingHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_openingHours);
}

 final  List<UserModel>? _users;
@override List<UserModel>? get users {
  final value = _users;
  if (value == null) return null;
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LockerStationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LockerStationModelCopyWith<_LockerStationModel> get copyWith => __$LockerStationModelCopyWithImpl<_LockerStationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LockerStationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LockerStationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.status, status) || other.status == status)&&(identical(other.location, location) || other.location == location)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._ratings, _ratings)&&const DeepCollectionEquality().equals(other._reviews, _reviews)&&const DeepCollectionEquality().equals(other._lockers, _lockers)&&const DeepCollectionEquality().equals(other._openingHours, _openingHours)&&const DeepCollectionEquality().equals(other._users, _users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,stationName,status,location,address,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_ratings),const DeepCollectionEquality().hash(_reviews),const DeepCollectionEquality().hash(_lockers),const DeepCollectionEquality().hash(_openingHours),const DeepCollectionEquality().hash(_users));

@override
String toString() {
  return 'LockerStationModel(id: $id, stationName: $stationName, status: $status, location: $location, address: $address, images: $images, ratings: $ratings, reviews: $reviews, lockers: $lockers, openingHours: $openingHours, users: $users)';
}


}

/// @nodoc
abstract mixin class _$LockerStationModelCopyWith<$Res> implements $LockerStationModelCopyWith<$Res> {
  factory _$LockerStationModelCopyWith(_LockerStationModel value, $Res Function(_LockerStationModel) _then) = __$LockerStationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String stationName, String status, LocationModel location, String address, List<ImageModel> images, List<RatingModel> ratings, List<ReviewModel> reviews, List<LockerModel> lockers, List<LockerStationOpeningHoursModel> openingHours, List<UserModel>? users
});


@override $LocationModelCopyWith<$Res> get location;

}
/// @nodoc
class __$LockerStationModelCopyWithImpl<$Res>
    implements _$LockerStationModelCopyWith<$Res> {
  __$LockerStationModelCopyWithImpl(this._self, this._then);

  final _LockerStationModel _self;
  final $Res Function(_LockerStationModel) _then;

/// Create a copy of LockerStationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? stationName = null,Object? status = null,Object? location = null,Object? address = null,Object? images = null,Object? ratings = null,Object? reviews = null,Object? lockers = null,Object? openingHours = null,Object? users = freezed,}) {
  return _then(_LockerStationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stationName: null == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationModel,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<ImageModel>,ratings: null == ratings ? _self._ratings : ratings // ignore: cast_nullable_to_non_nullable
as List<RatingModel>,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<ReviewModel>,lockers: null == lockers ? _self._lockers : lockers // ignore: cast_nullable_to_non_nullable
as List<LockerModel>,openingHours: null == openingHours ? _self._openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as List<LockerStationOpeningHoursModel>,users: freezed == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<UserModel>?,
  ));
}

/// Create a copy of LockerStationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationModelCopyWith<$Res> get location {
  
  return $LocationModelCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// @nodoc
mixin _$LocationModel {

 String get type;@LatLngConverter() LatLng get coordinates;
/// Create a copy of LocationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationModelCopyWith<LocationModel> get copyWith => _$LocationModelCopyWithImpl<LocationModel>(this as LocationModel, _$identity);

  /// Serializes this LocationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationModel&&(identical(other.type, type) || other.type == type)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,coordinates);

@override
String toString() {
  return 'LocationModel(type: $type, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $LocationModelCopyWith<$Res>  {
  factory $LocationModelCopyWith(LocationModel value, $Res Function(LocationModel) _then) = _$LocationModelCopyWithImpl;
@useResult
$Res call({
 String type,@LatLngConverter() LatLng coordinates
});




}
/// @nodoc
class _$LocationModelCopyWithImpl<$Res>
    implements $LocationModelCopyWith<$Res> {
  _$LocationModelCopyWithImpl(this._self, this._then);

  final LocationModel _self;
  final $Res Function(LocationModel) _then;

/// Create a copy of LocationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? coordinates = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as LatLng,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LocationModel implements LocationModel {
  const _LocationModel({required this.type, @LatLngConverter() required this.coordinates});
  factory _LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);

@override final  String type;
@override@LatLngConverter() final  LatLng coordinates;

/// Create a copy of LocationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationModelCopyWith<_LocationModel> get copyWith => __$LocationModelCopyWithImpl<_LocationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationModel&&(identical(other.type, type) || other.type == type)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,coordinates);

@override
String toString() {
  return 'LocationModel(type: $type, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$LocationModelCopyWith<$Res> implements $LocationModelCopyWith<$Res> {
  factory _$LocationModelCopyWith(_LocationModel value, $Res Function(_LocationModel) _then) = __$LocationModelCopyWithImpl;
@override @useResult
$Res call({
 String type,@LatLngConverter() LatLng coordinates
});




}
/// @nodoc
class __$LocationModelCopyWithImpl<$Res>
    implements _$LocationModelCopyWith<$Res> {
  __$LocationModelCopyWithImpl(this._self, this._then);

  final _LocationModel _self;
  final $Res Function(_LocationModel) _then;

/// Create a copy of LocationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? coordinates = null,}) {
  return _then(_LocationModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as LatLng,
  ));
}


}


/// @nodoc
mixin _$ImageModel {

 String get url;
/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageModelCopyWith<ImageModel> get copyWith => _$ImageModelCopyWithImpl<ImageModel>(this as ImageModel, _$identity);

  /// Serializes this ImageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageModel&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'ImageModel(url: $url)';
}


}

/// @nodoc
abstract mixin class $ImageModelCopyWith<$Res>  {
  factory $ImageModelCopyWith(ImageModel value, $Res Function(ImageModel) _then) = _$ImageModelCopyWithImpl;
@useResult
$Res call({
 String url
});




}
/// @nodoc
class _$ImageModelCopyWithImpl<$Res>
    implements $ImageModelCopyWith<$Res> {
  _$ImageModelCopyWithImpl(this._self, this._then);

  final ImageModel _self;
  final $Res Function(ImageModel) _then;

/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ImageModel implements ImageModel {
  const _ImageModel({required this.url});
  factory _ImageModel.fromJson(Map<String, dynamic> json) => _$ImageModelFromJson(json);

@override final  String url;

/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageModelCopyWith<_ImageModel> get copyWith => __$ImageModelCopyWithImpl<_ImageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageModel&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'ImageModel(url: $url)';
}


}

/// @nodoc
abstract mixin class _$ImageModelCopyWith<$Res> implements $ImageModelCopyWith<$Res> {
  factory _$ImageModelCopyWith(_ImageModel value, $Res Function(_ImageModel) _then) = __$ImageModelCopyWithImpl;
@override @useResult
$Res call({
 String url
});




}
/// @nodoc
class __$ImageModelCopyWithImpl<$Res>
    implements _$ImageModelCopyWith<$Res> {
  __$ImageModelCopyWithImpl(this._self, this._then);

  final _ImageModel _self;
  final $Res Function(_ImageModel) _then;

/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,}) {
  return _then(_ImageModel(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RatingModel {

 int get rating; UserModel get user; LockerStationModel get lockerStation;
/// Create a copy of RatingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RatingModelCopyWith<RatingModel> get copyWith => _$RatingModelCopyWithImpl<RatingModel>(this as RatingModel, _$identity);

  /// Serializes this RatingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingModel&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.user, user) || other.user == user)&&(identical(other.lockerStation, lockerStation) || other.lockerStation == lockerStation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rating,user,lockerStation);

@override
String toString() {
  return 'RatingModel(rating: $rating, user: $user, lockerStation: $lockerStation)';
}


}

/// @nodoc
abstract mixin class $RatingModelCopyWith<$Res>  {
  factory $RatingModelCopyWith(RatingModel value, $Res Function(RatingModel) _then) = _$RatingModelCopyWithImpl;
@useResult
$Res call({
 int rating, UserModel user, LockerStationModel lockerStation
});


$UserModelCopyWith<$Res> get user;$LockerStationModelCopyWith<$Res> get lockerStation;

}
/// @nodoc
class _$RatingModelCopyWithImpl<$Res>
    implements $RatingModelCopyWith<$Res> {
  _$RatingModelCopyWithImpl(this._self, this._then);

  final RatingModel _self;
  final $Res Function(RatingModel) _then;

/// Create a copy of RatingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rating = null,Object? user = null,Object? lockerStation = null,}) {
  return _then(_self.copyWith(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,lockerStation: null == lockerStation ? _self.lockerStation : lockerStation // ignore: cast_nullable_to_non_nullable
as LockerStationModel,
  ));
}
/// Create a copy of RatingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of RatingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LockerStationModelCopyWith<$Res> get lockerStation {
  
  return $LockerStationModelCopyWith<$Res>(_self.lockerStation, (value) {
    return _then(_self.copyWith(lockerStation: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _RatingModel implements RatingModel {
  const _RatingModel({required this.rating, required this.user, required this.lockerStation});
  factory _RatingModel.fromJson(Map<String, dynamic> json) => _$RatingModelFromJson(json);

@override final  int rating;
@override final  UserModel user;
@override final  LockerStationModel lockerStation;

/// Create a copy of RatingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RatingModelCopyWith<_RatingModel> get copyWith => __$RatingModelCopyWithImpl<_RatingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RatingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RatingModel&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.user, user) || other.user == user)&&(identical(other.lockerStation, lockerStation) || other.lockerStation == lockerStation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rating,user,lockerStation);

@override
String toString() {
  return 'RatingModel(rating: $rating, user: $user, lockerStation: $lockerStation)';
}


}

/// @nodoc
abstract mixin class _$RatingModelCopyWith<$Res> implements $RatingModelCopyWith<$Res> {
  factory _$RatingModelCopyWith(_RatingModel value, $Res Function(_RatingModel) _then) = __$RatingModelCopyWithImpl;
@override @useResult
$Res call({
 int rating, UserModel user, LockerStationModel lockerStation
});


@override $UserModelCopyWith<$Res> get user;@override $LockerStationModelCopyWith<$Res> get lockerStation;

}
/// @nodoc
class __$RatingModelCopyWithImpl<$Res>
    implements _$RatingModelCopyWith<$Res> {
  __$RatingModelCopyWithImpl(this._self, this._then);

  final _RatingModel _self;
  final $Res Function(_RatingModel) _then;

/// Create a copy of RatingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rating = null,Object? user = null,Object? lockerStation = null,}) {
  return _then(_RatingModel(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,lockerStation: null == lockerStation ? _self.lockerStation : lockerStation // ignore: cast_nullable_to_non_nullable
as LockerStationModel,
  ));
}

/// Create a copy of RatingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of RatingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LockerStationModelCopyWith<$Res> get lockerStation {
  
  return $LockerStationModelCopyWith<$Res>(_self.lockerStation, (value) {
    return _then(_self.copyWith(lockerStation: value));
  });
}
}


/// @nodoc
mixin _$ReviewModel {

 String get message; UserModel get user; LockerStationModel get lockerStation; bool get isVisible;
/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewModelCopyWith<ReviewModel> get copyWith => _$ReviewModelCopyWithImpl<ReviewModel>(this as ReviewModel, _$identity);

  /// Serializes this ReviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewModel&&(identical(other.message, message) || other.message == message)&&(identical(other.user, user) || other.user == user)&&(identical(other.lockerStation, lockerStation) || other.lockerStation == lockerStation)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,user,lockerStation,isVisible);

@override
String toString() {
  return 'ReviewModel(message: $message, user: $user, lockerStation: $lockerStation, isVisible: $isVisible)';
}


}

/// @nodoc
abstract mixin class $ReviewModelCopyWith<$Res>  {
  factory $ReviewModelCopyWith(ReviewModel value, $Res Function(ReviewModel) _then) = _$ReviewModelCopyWithImpl;
@useResult
$Res call({
 String message, UserModel user, LockerStationModel lockerStation, bool isVisible
});


$UserModelCopyWith<$Res> get user;$LockerStationModelCopyWith<$Res> get lockerStation;

}
/// @nodoc
class _$ReviewModelCopyWithImpl<$Res>
    implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._self, this._then);

  final ReviewModel _self;
  final $Res Function(ReviewModel) _then;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? user = null,Object? lockerStation = null,Object? isVisible = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,lockerStation: null == lockerStation ? _self.lockerStation : lockerStation // ignore: cast_nullable_to_non_nullable
as LockerStationModel,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LockerStationModelCopyWith<$Res> get lockerStation {
  
  return $LockerStationModelCopyWith<$Res>(_self.lockerStation, (value) {
    return _then(_self.copyWith(lockerStation: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _ReviewModel implements ReviewModel {
  const _ReviewModel({required this.message, required this.user, required this.lockerStation, required this.isVisible});
  factory _ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);

@override final  String message;
@override final  UserModel user;
@override final  LockerStationModel lockerStation;
@override final  bool isVisible;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewModelCopyWith<_ReviewModel> get copyWith => __$ReviewModelCopyWithImpl<_ReviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewModel&&(identical(other.message, message) || other.message == message)&&(identical(other.user, user) || other.user == user)&&(identical(other.lockerStation, lockerStation) || other.lockerStation == lockerStation)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,user,lockerStation,isVisible);

@override
String toString() {
  return 'ReviewModel(message: $message, user: $user, lockerStation: $lockerStation, isVisible: $isVisible)';
}


}

/// @nodoc
abstract mixin class _$ReviewModelCopyWith<$Res> implements $ReviewModelCopyWith<$Res> {
  factory _$ReviewModelCopyWith(_ReviewModel value, $Res Function(_ReviewModel) _then) = __$ReviewModelCopyWithImpl;
@override @useResult
$Res call({
 String message, UserModel user, LockerStationModel lockerStation, bool isVisible
});


@override $UserModelCopyWith<$Res> get user;@override $LockerStationModelCopyWith<$Res> get lockerStation;

}
/// @nodoc
class __$ReviewModelCopyWithImpl<$Res>
    implements _$ReviewModelCopyWith<$Res> {
  __$ReviewModelCopyWithImpl(this._self, this._then);

  final _ReviewModel _self;
  final $Res Function(_ReviewModel) _then;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? user = null,Object? lockerStation = null,Object? isVisible = null,}) {
  return _then(_ReviewModel(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,lockerStation: null == lockerStation ? _self.lockerStation : lockerStation // ignore: cast_nullable_to_non_nullable
as LockerStationModel,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LockerStationModelCopyWith<$Res> get lockerStation {
  
  return $LockerStationModelCopyWith<$Res>(_self.lockerStation, (value) {
    return _then(_self.copyWith(lockerStation: value));
  });
}
}


/// @nodoc
mixin _$LockerModel {

 int get lockerNumber; LockerStatus get status; DoorStatus get doorStatus; String? get currentUserId; LockerSize get size; int get rentalPrice;
/// Create a copy of LockerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LockerModelCopyWith<LockerModel> get copyWith => _$LockerModelCopyWithImpl<LockerModel>(this as LockerModel, _$identity);

  /// Serializes this LockerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockerModel&&(identical(other.lockerNumber, lockerNumber) || other.lockerNumber == lockerNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.doorStatus, doorStatus) || other.doorStatus == doorStatus)&&(identical(other.currentUserId, currentUserId) || other.currentUserId == currentUserId)&&(identical(other.size, size) || other.size == size)&&(identical(other.rentalPrice, rentalPrice) || other.rentalPrice == rentalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lockerNumber,status,doorStatus,currentUserId,size,rentalPrice);

@override
String toString() {
  return 'LockerModel(lockerNumber: $lockerNumber, status: $status, doorStatus: $doorStatus, currentUserId: $currentUserId, size: $size, rentalPrice: $rentalPrice)';
}


}

/// @nodoc
abstract mixin class $LockerModelCopyWith<$Res>  {
  factory $LockerModelCopyWith(LockerModel value, $Res Function(LockerModel) _then) = _$LockerModelCopyWithImpl;
@useResult
$Res call({
 int lockerNumber, LockerStatus status, DoorStatus doorStatus, String? currentUserId, LockerSize size, int rentalPrice
});




}
/// @nodoc
class _$LockerModelCopyWithImpl<$Res>
    implements $LockerModelCopyWith<$Res> {
  _$LockerModelCopyWithImpl(this._self, this._then);

  final LockerModel _self;
  final $Res Function(LockerModel) _then;

/// Create a copy of LockerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lockerNumber = null,Object? status = null,Object? doorStatus = null,Object? currentUserId = freezed,Object? size = null,Object? rentalPrice = null,}) {
  return _then(_self.copyWith(
lockerNumber: null == lockerNumber ? _self.lockerNumber : lockerNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LockerStatus,doorStatus: null == doorStatus ? _self.doorStatus : doorStatus // ignore: cast_nullable_to_non_nullable
as DoorStatus,currentUserId: freezed == currentUserId ? _self.currentUserId : currentUserId // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as LockerSize,rentalPrice: null == rentalPrice ? _self.rentalPrice : rentalPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LockerModel implements LockerModel {
  const _LockerModel({required this.lockerNumber, required this.status, required this.doorStatus, this.currentUserId, required this.size, required this.rentalPrice});
  factory _LockerModel.fromJson(Map<String, dynamic> json) => _$LockerModelFromJson(json);

@override final  int lockerNumber;
@override final  LockerStatus status;
@override final  DoorStatus doorStatus;
@override final  String? currentUserId;
@override final  LockerSize size;
@override final  int rentalPrice;

/// Create a copy of LockerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LockerModelCopyWith<_LockerModel> get copyWith => __$LockerModelCopyWithImpl<_LockerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LockerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LockerModel&&(identical(other.lockerNumber, lockerNumber) || other.lockerNumber == lockerNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.doorStatus, doorStatus) || other.doorStatus == doorStatus)&&(identical(other.currentUserId, currentUserId) || other.currentUserId == currentUserId)&&(identical(other.size, size) || other.size == size)&&(identical(other.rentalPrice, rentalPrice) || other.rentalPrice == rentalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lockerNumber,status,doorStatus,currentUserId,size,rentalPrice);

@override
String toString() {
  return 'LockerModel(lockerNumber: $lockerNumber, status: $status, doorStatus: $doorStatus, currentUserId: $currentUserId, size: $size, rentalPrice: $rentalPrice)';
}


}

/// @nodoc
abstract mixin class _$LockerModelCopyWith<$Res> implements $LockerModelCopyWith<$Res> {
  factory _$LockerModelCopyWith(_LockerModel value, $Res Function(_LockerModel) _then) = __$LockerModelCopyWithImpl;
@override @useResult
$Res call({
 int lockerNumber, LockerStatus status, DoorStatus doorStatus, String? currentUserId, LockerSize size, int rentalPrice
});




}
/// @nodoc
class __$LockerModelCopyWithImpl<$Res>
    implements _$LockerModelCopyWith<$Res> {
  __$LockerModelCopyWithImpl(this._self, this._then);

  final _LockerModel _self;
  final $Res Function(_LockerModel) _then;

/// Create a copy of LockerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lockerNumber = null,Object? status = null,Object? doorStatus = null,Object? currentUserId = freezed,Object? size = null,Object? rentalPrice = null,}) {
  return _then(_LockerModel(
lockerNumber: null == lockerNumber ? _self.lockerNumber : lockerNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LockerStatus,doorStatus: null == doorStatus ? _self.doorStatus : doorStatus // ignore: cast_nullable_to_non_nullable
as DoorStatus,currentUserId: freezed == currentUserId ? _self.currentUserId : currentUserId // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as LockerSize,rentalPrice: null == rentalPrice ? _self.rentalPrice : rentalPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LockerStationOpeningHoursModel {

 Days get day; String get opensAt; String get closesAt; bool get isClosed;
/// Create a copy of LockerStationOpeningHoursModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LockerStationOpeningHoursModelCopyWith<LockerStationOpeningHoursModel> get copyWith => _$LockerStationOpeningHoursModelCopyWithImpl<LockerStationOpeningHoursModel>(this as LockerStationOpeningHoursModel, _$identity);

  /// Serializes this LockerStationOpeningHoursModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockerStationOpeningHoursModel&&(identical(other.day, day) || other.day == day)&&(identical(other.opensAt, opensAt) || other.opensAt == opensAt)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,opensAt,closesAt,isClosed);

@override
String toString() {
  return 'LockerStationOpeningHoursModel(day: $day, opensAt: $opensAt, closesAt: $closesAt, isClosed: $isClosed)';
}


}

/// @nodoc
abstract mixin class $LockerStationOpeningHoursModelCopyWith<$Res>  {
  factory $LockerStationOpeningHoursModelCopyWith(LockerStationOpeningHoursModel value, $Res Function(LockerStationOpeningHoursModel) _then) = _$LockerStationOpeningHoursModelCopyWithImpl;
@useResult
$Res call({
 Days day, String opensAt, String closesAt, bool isClosed
});




}
/// @nodoc
class _$LockerStationOpeningHoursModelCopyWithImpl<$Res>
    implements $LockerStationOpeningHoursModelCopyWith<$Res> {
  _$LockerStationOpeningHoursModelCopyWithImpl(this._self, this._then);

  final LockerStationOpeningHoursModel _self;
  final $Res Function(LockerStationOpeningHoursModel) _then;

/// Create a copy of LockerStationOpeningHoursModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? opensAt = null,Object? closesAt = null,Object? isClosed = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as Days,opensAt: null == opensAt ? _self.opensAt : opensAt // ignore: cast_nullable_to_non_nullable
as String,closesAt: null == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as String,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LockerStationOpeningHoursModel implements LockerStationOpeningHoursModel {
  const _LockerStationOpeningHoursModel({required this.day, required this.opensAt, required this.closesAt, required this.isClosed});
  factory _LockerStationOpeningHoursModel.fromJson(Map<String, dynamic> json) => _$LockerStationOpeningHoursModelFromJson(json);

@override final  Days day;
@override final  String opensAt;
@override final  String closesAt;
@override final  bool isClosed;

/// Create a copy of LockerStationOpeningHoursModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LockerStationOpeningHoursModelCopyWith<_LockerStationOpeningHoursModel> get copyWith => __$LockerStationOpeningHoursModelCopyWithImpl<_LockerStationOpeningHoursModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LockerStationOpeningHoursModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LockerStationOpeningHoursModel&&(identical(other.day, day) || other.day == day)&&(identical(other.opensAt, opensAt) || other.opensAt == opensAt)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,opensAt,closesAt,isClosed);

@override
String toString() {
  return 'LockerStationOpeningHoursModel(day: $day, opensAt: $opensAt, closesAt: $closesAt, isClosed: $isClosed)';
}


}

/// @nodoc
abstract mixin class _$LockerStationOpeningHoursModelCopyWith<$Res> implements $LockerStationOpeningHoursModelCopyWith<$Res> {
  factory _$LockerStationOpeningHoursModelCopyWith(_LockerStationOpeningHoursModel value, $Res Function(_LockerStationOpeningHoursModel) _then) = __$LockerStationOpeningHoursModelCopyWithImpl;
@override @useResult
$Res call({
 Days day, String opensAt, String closesAt, bool isClosed
});




}
/// @nodoc
class __$LockerStationOpeningHoursModelCopyWithImpl<$Res>
    implements _$LockerStationOpeningHoursModelCopyWith<$Res> {
  __$LockerStationOpeningHoursModelCopyWithImpl(this._self, this._then);

  final _LockerStationOpeningHoursModel _self;
  final $Res Function(_LockerStationOpeningHoursModel) _then;

/// Create a copy of LockerStationOpeningHoursModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? opensAt = null,Object? closesAt = null,Object? isClosed = null,}) {
  return _then(_LockerStationOpeningHoursModel(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as Days,opensAt: null == opensAt ? _self.opensAt : opensAt // ignore: cast_nullable_to_non_nullable
as String,closesAt: null == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as String,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
