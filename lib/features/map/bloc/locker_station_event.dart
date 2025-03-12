part of 'locker_station_bloc.dart';

@immutable
sealed class LockerStationEvent {}

class LockerStationInitialEvent extends LockerStationEvent {}

class LoadLockerStationEvent extends LockerStationEvent {
  final Position position;
  LoadLockerStationEvent(this.position);
}
