part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {}

class StartTrackingEvent extends LocationEvent {}

class UpdatePositionEvent extends LocationEvent {
  final Position position;
  UpdatePositionEvent(this.position);
}
