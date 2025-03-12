// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

@JsonKey(name: '_id') String get id;// Map '_id' from JSON to 'id'
 String get name; String get email; String? get profilePicture; String? get currentLocker; List<dynamic>? get coordinates; List<String> get favourite; List<String> get history; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.currentLocker, currentLocker) || other.currentLocker == currentLocker)&&const DeepCollectionEquality().equals(other.coordinates, coordinates)&&const DeepCollectionEquality().equals(other.favourite, favourite)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,profilePicture,currentLocker,const DeepCollectionEquality().hash(coordinates),const DeepCollectionEquality().hash(favourite),const DeepCollectionEquality().hash(history),createdAt,updatedAt);

@override
String toString() {
  return 'UserModel(id: $id, name: $name, email: $email, profilePicture: $profilePicture, currentLocker: $currentLocker, coordinates: $coordinates, favourite: $favourite, history: $history, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String name, String email, String? profilePicture, String? currentLocker, List<dynamic>? coordinates, List<String> favourite, List<String> history, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? profilePicture = freezed,Object? currentLocker = freezed,Object? coordinates = freezed,Object? favourite = null,Object? history = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,currentLocker: freezed == currentLocker ? _self.currentLocker : currentLocker // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,favourite: null == favourite ? _self.favourite : favourite // ignore: cast_nullable_to_non_nullable
as List<String>,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({@JsonKey(name: '_id') required this.id, required this.name, required this.email, this.profilePicture, this.currentLocker, final  List<dynamic>? coordinates, final  List<String> favourite = const [], final  List<String> history = const [], this.createdAt, this.updatedAt}): _coordinates = coordinates,_favourite = favourite,_history = history;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override@JsonKey(name: '_id') final  String id;
// Map '_id' from JSON to 'id'
@override final  String name;
@override final  String email;
@override final  String? profilePicture;
@override final  String? currentLocker;
 final  List<dynamic>? _coordinates;
@override List<dynamic>? get coordinates {
  final value = _coordinates;
  if (value == null) return null;
  if (_coordinates is EqualUnmodifiableListView) return _coordinates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String> _favourite;
@override@JsonKey() List<String> get favourite {
  if (_favourite is EqualUnmodifiableListView) return _favourite;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favourite);
}

 final  List<String> _history;
@override@JsonKey() List<String> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.currentLocker, currentLocker) || other.currentLocker == currentLocker)&&const DeepCollectionEquality().equals(other._coordinates, _coordinates)&&const DeepCollectionEquality().equals(other._favourite, _favourite)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,profilePicture,currentLocker,const DeepCollectionEquality().hash(_coordinates),const DeepCollectionEquality().hash(_favourite),const DeepCollectionEquality().hash(_history),createdAt,updatedAt);

@override
String toString() {
  return 'UserModel(id: $id, name: $name, email: $email, profilePicture: $profilePicture, currentLocker: $currentLocker, coordinates: $coordinates, favourite: $favourite, history: $history, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String name, String email, String? profilePicture, String? currentLocker, List<dynamic>? coordinates, List<String> favourite, List<String> history, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? profilePicture = freezed,Object? currentLocker = freezed,Object? coordinates = freezed,Object? favourite = null,Object? history = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,currentLocker: freezed == currentLocker ? _self.currentLocker : currentLocker // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self._coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,favourite: null == favourite ? _self._favourite : favourite // ignore: cast_nullable_to_non_nullable
as List<String>,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
