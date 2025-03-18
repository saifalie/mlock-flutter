part of 'locker_station_bloc.dart';

enum LockerStationStatus { initial, loading, loaded, error }

@immutable
class LockerStationState {
  final List<LockerStation>? lockerStations;
  final String? error;
  final LockerStationStatus status;

  const LockerStationState({
    required this.status,
    this.lockerStations,
    this.error,
  });

  factory LockerStationState.initial() =>
      LockerStationState(status: LockerStationStatus.initial);
  factory LockerStationState.loading() =>
      LockerStationState(status: LockerStationStatus.loaded);
  factory LockerStationState.loaded({
    required List<LockerStation> lockerStations,
  }) => LockerStationState(
    status: LockerStationStatus.loaded,
    lockerStations: lockerStations,
  );
  factory LockerStationState.error(String error) =>
      LockerStationState(status: LockerStationStatus.error, error: error);
}
