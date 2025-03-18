part of 'station_detail_bloc.dart';

enum StationDetailStatus { initial, loading, loaded, error }

@immutable
class StationDetailState {
  final LockerStation? station;
  final String? error;
  final StationDetailStatus status;

  const StationDetailState({required this.status, this.error, this.station});

  factory StationDetailState.initial() =>
      StationDetailState(status: StationDetailStatus.initial);

  factory StationDetailState.loading() =>
      StationDetailState(status: StationDetailStatus.loading);

  factory StationDetailState.loaded(LockerStation station) =>
      StationDetailState(status: StationDetailStatus.loaded, station: station);

  factory StationDetailState.error(String error) =>
      StationDetailState(status: StationDetailStatus.error, error: error);
}
