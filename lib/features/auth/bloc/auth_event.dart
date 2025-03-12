part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class InitialDelayCompletedEvent extends AuthEvent {}

class GoogleSignInRequestedEvent extends AuthEvent {}

class AuthCheckRequestedEvent extends AuthEvent {}

class SignOutRequestedEvent extends AuthEvent {}
