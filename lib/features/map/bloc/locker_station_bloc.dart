import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_model.dart';

part 'locker_station_event.dart';
part 'locker_station_state.dart';

class LockerStationBloc extends Bloc<LockerStationEvent, LockerStationState> {
  Position? _lastPosition;
  DateTime _lastUpdate = DateTime(1970);

  LockerStationBloc() : super(LockerStationState.initial()) {
    on<LoadLockerStationEvent>(_loadLockerStationEvent);
  }

  FutureOr<void> _loadLockerStationEvent(
    LoadLockerStationEvent event,
    Emitter<LockerStationState> emit,
  ) async {
    try {
      // Allow first load if no previous position exists
      final bool hasPreviousPosition = _lastPosition != null;

      // Time-based throttle only if there's a previous position
      if (hasPreviousPosition &&
          DateTime.now().difference(_lastUpdate).inSeconds < 2) {
        return;
      }

      // Distance-based throttle only if there's a previous position
      if (hasPreviousPosition) {
        final distance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          event.position.latitude,
          event.position.longitude,
        );

        if (distance < 100) return;

       
      }

      // Update tracking variables
      _lastPosition = event.position;
      _lastUpdate = DateTime.now();

      emit(LockerStationState.loading());

      // Simulate API call delay
      await Future.delayed(Duration(milliseconds: 500));

      // Generate dummy stations around current position
      final dummyStations = [
        LockerStationModel(
          id: '1',
          stationName: 'Central Station',
          status: 'active',
          location: LocationModel(
            type: 'Point',
            coordinates: LatLng(
              event.position.latitude + 0.002,
              event.position.longitude + 0.001,
            ),
          ),
          address: '123 Main Street',
          images: [],
          ratings: [],
          reviews: [],
          lockers: [],
          openingHours: [],
        ),
        LockerStationModel(
          id: '2',
          stationName: 'Park Lockers',
          status: 'active',
          location: LocationModel(
            type: 'Point',
            coordinates: LatLng(
              event.position.latitude - 0.001,
              event.position.longitude + 0.002,
            ),
          ),
          address: 'Central Park',
          images: [],
          ratings: [],
          reviews: [],
          lockers: [],
          openingHours: [],
        ),
      ];

      emit(LockerStationState.loaded(lockerStations: dummyStations));
    } catch (e) {
      logger.e('LoadLockerStation Event error: $e');
      emit(
        LockerStationState.error('Failed to load stations: ${e.toString()}'),
      );
    }
  }
}
