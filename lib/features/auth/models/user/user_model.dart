import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') required String id, // Map '_id' from JSON to 'id'
    required String name,
    required String email,
    String? profilePicture,
    String? currentLocker,
    List<dynamic>? coordinates,
    @Default([]) List<String> favourite,
    @Default([]) List<String> history,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
