part of 'permissions_bloc.dart';

@immutable
sealed class PermissionsEvent {}

class CheckPermissionsEvent extends PermissionsEvent {}

class RequestLocationPermissionEvent extends PermissionsEvent {}
