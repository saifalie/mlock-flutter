part of 'location_bloc.dart';

enum LocationStatus { initial, loading, error, loaded, updated }

class LocationState {
  final Position? position;
  final double? radiusMeters;
  final String? error;
  final LocationStatus status;

  const LocationState({
    required this.status,
    this.radiusMeters,
    this.error,
    this.position,
  });

  factory LocationState.initial() =>
      LocationState(status: LocationStatus.initial,);
  factory LocationState.loading() =>
      LocationState(status: LocationStatus.loading);
  factory LocationState.locationUpdated(
    Position position,
    double radiusMeters,
  ) => LocationState(
    status: LocationStatus.updated,
    position: position,
    radiusMeters: radiusMeters,
  );
  factory LocationState.error(String error) =>
      LocationState(status: LocationStatus.error, error: error);
}
