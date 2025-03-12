part of 'permissions_bloc.dart';

enum PermissionStatusI {
  initial,
  granted,
  denied,
  deniedPermanently,
  loading,
  error,
}

@immutable
class PermissionsState {
  final PermissionStatusI status;
  final String? error;
  final DateTime? timestamp;

  const PermissionsState({required this.status, this.error, this.timestamp});

  // Add equality checks
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PermissionsState && status == other.status);
  }

  @override
  int get hashCode => status.hashCode;

  factory PermissionsState.initial() => PermissionsState(
    status: PermissionStatusI.initial,
    timestamp: DateTime(1970),
  );
  factory PermissionsState.granted(DateTime timestamp) =>
      PermissionsState(status: PermissionStatusI.granted, timestamp: timestamp);
  factory PermissionsState.denied(DateTime timestamp) =>
      PermissionsState(status: PermissionStatusI.denied, timestamp: timestamp);
  factory PermissionsState.loading(DateTime timestamp) =>
      PermissionsState(status: PermissionStatusI.loading, timestamp: timestamp);
  factory PermissionsState.error(String error, DateTime timestamp) =>
      PermissionsState(
        status: PermissionStatusI.error,
        error: error,
        timestamp: timestamp,
      );
  factory PermissionsState.deniedPermanently(DateTime timestamp) =>
      PermissionsState(
        status: PermissionStatusI.deniedPermanently,
        timestamp: timestamp,
      );
}
