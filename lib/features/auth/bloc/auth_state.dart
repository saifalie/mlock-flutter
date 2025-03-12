part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, authenticated, error, unauthenticated }

@immutable
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;
  final String? accessToken;

  const AuthState({
    required this.status,
    this.user,
    this.error,
    this.accessToken,
  });

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);
  factory AuthState.loading() => AuthState(status: AuthStatus.loading);
  factory AuthState.authenticated(UserModel user, String accessToken) =>
      AuthState(
        status: AuthStatus.authenticated,
        user: user,
        accessToken: accessToken,
      );
  factory AuthState.error(String error) =>
      AuthState(status: AuthStatus.error, error: error);
  factory AuthState.unauthenticated() =>
      AuthState(status: AuthStatus.unauthenticated);
}
