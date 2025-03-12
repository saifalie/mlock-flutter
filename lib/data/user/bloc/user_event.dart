part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class LoadUserDataEvent extends UserEvent {
  final bool forceRefresh;

  LoadUserDataEvent({this.forceRefresh = false});
}

class UpdateUserDataEvent extends UserEvent {}

class ClearUserDataEvent extends UserEvent {}
