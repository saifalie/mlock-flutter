part of 'saved_page_bloc.dart';

@immutable
sealed class SavedPageEvent {}

final class LoadSavedStationEvent extends SavedPageEvent {}

final class RefreshSavedStationEvent extends SavedPageEvent {}

class ToggleSaveStationEvent extends SavedPageEvent {
  final String stationId;
  ToggleSaveStationEvent(this.stationId);
}
