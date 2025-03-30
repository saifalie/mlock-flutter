part of 'station_detail_bloc.dart';

@immutable
sealed class StationDetailEvent {}

class StationDetailInitialEvent extends StationDetailEvent {}

class LoadStationDetailEvent extends StationDetailEvent {
  final String lockerId;
  LoadStationDetailEvent(this.lockerId);
}

class ToggleSaveStationEvent extends StationDetailEvent {
  final String stationId;
  ToggleSaveStationEvent(this.stationId);
}
