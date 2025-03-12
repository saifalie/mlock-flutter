part of 'user_bloc.dart';

enum UserStatus { initial, loading, loaded, error }

@immutable
class UserState {
  final UserModel? user;
  final String? error;
  final UserStatus status;

  const UserState({required this.status, this.user, this.error});

  factory UserState.initial() => UserState(status: UserStatus.initial);
  factory UserState.loading() => UserState(status: UserStatus.loaded);
  factory UserState.loaded(UserModel user) =>
      UserState(status: UserStatus.loaded, user: user);
  factory UserState.error(String error) =>
      UserState(status: UserStatus.error, error: error);
}
