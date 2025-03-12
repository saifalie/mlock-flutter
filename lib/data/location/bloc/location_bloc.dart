import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? _positionStream;
  LocationBloc() : super(LocationState.initial()) {
    on<StartTrackingEvent>(_startTrackingEvent);
    on<UpdatePositionEvent>(_updatePositionEvent);
  }

  FutureOr<void> _startTrackingEvent(
    StartTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    try {
      //------new code
      // Cancel any existing stream to prevent leaks
      await _positionStream?.cancel();
      _positionStream = null;

      //----------------------------
      final position = await Geolocator.getCurrentPosition();
      emit(LocationState.locationUpdated(position, 1000));

      _positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 10,
        ),
      ).listen((position) {
        add(UpdatePositionEvent(position));
      });
    } catch (e) {
      logger.e('StartTrackingEvent method error: $e');
      emit(LocationState.error(e.toString()));
    }
  }

  FutureOr<void> _updatePositionEvent(
    UpdatePositionEvent event,
    Emitter<LocationState> emit,
  ) {
    emit(LocationState.locationUpdated(event.position, 500));
  }

  @override
  Future<void> close() {
    _positionStream?.cancel();
    return super.close();
  }
}
