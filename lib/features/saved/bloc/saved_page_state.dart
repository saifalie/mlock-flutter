part of 'saved_page_bloc.dart';

enum SavedPageStatus { initial, loading, loaded, error }

class SavedPageState {
  final SavedPageStatus status;
  final String? error;
  final List<LockerStation>? stations;
  final bool? isEmpty;

  const SavedPageState({
    required this.status,
    this.error,
    this.stations,
    this.isEmpty,
  });

  factory SavedPageState.initial() =>
      SavedPageState(status: SavedPageStatus.initial);
  factory SavedPageState.loading() =>
      SavedPageState(status: SavedPageStatus.loading);
  factory SavedPageState.loaded(List<LockerStation> stations) => SavedPageState(
    status: SavedPageStatus.loaded,
    stations: stations,
    isEmpty: stations.isEmpty,
  );

  factory SavedPageState.error(String error) =>
      SavedPageState(status: SavedPageStatus.error, error: error);
}
