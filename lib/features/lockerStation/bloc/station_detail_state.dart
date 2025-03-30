part of 'station_detail_bloc.dart';

enum StationDetailStatus { initial, loading, loaded, error }

@immutable
class StationDetailState {
  final LockerStation? station;
  final String? error;
  final StationDetailStatus status;
  final bool isSaved;

  const StationDetailState({
    required this.status,
    this.error,
    this.station,
    this.isSaved = false,
  });

  StationDetailState copyWith({
    StationDetailStatus? status,
    LockerStation? station,
    String? error,
    bool? isSaved,
  }) {
    return StationDetailState(
      status: status ?? this.status,
      station: station ?? this.station,
      error: error ?? this.error,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  factory StationDetailState.initial() =>
      StationDetailState(status: StationDetailStatus.initial);

  factory StationDetailState.loading() =>
      StationDetailState(status: StationDetailStatus.loading);

  factory StationDetailState.loaded(
    LockerStation station, {
    bool isSaved = false,
  }) => StationDetailState(
    status: StationDetailStatus.loaded,
    station: station,
    isSaved: isSaved,
  );

  factory StationDetailState.error(String error) =>
      StationDetailState(status: StationDetailStatus.error, error: error);
}
