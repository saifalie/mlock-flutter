import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';
import 'package:mlock_flutter/features/map/repository/map_repository.dart';

part 'locker_station_event.dart';
part 'locker_station_state.dart';

class LockerStationBloc extends Bloc<LockerStationEvent, LockerStationState> {
  final MapRepository _mapRepository;
  Position? _lastPosition;
  DateTime _lastUpdate = DateTime(1970);

  LockerStationBloc({required MapRepository mapRepository})
    : _mapRepository = mapRepository,
      super(LockerStationState.initial()) {
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
      // await Future.delayed(Duration(milliseconds: 500));

      // final response = await _mapRepository.fetchNearbyLockerStation(
      //   latitude: event.position.latitude.toString(),
      //   longitude: event.position.longitude.toString(),
      // );

      final List<LockerStation> stations =
          await _mapRepository.getAllLockerStation();

      // logger.d('near by lockerstation bloc: ${resposne.runtimeType}');
      // logger.d('near by lockerstation bloc: ${resposne}');

      logger.d('stations bloc: $stations');

      emit(LockerStationState.loaded(lockerStations: stations));
    } catch (e) {
      logger.e('LoadLockerStation Event error: $e');
      emit(
        LockerStationState.error('Failed to load stations: ${e.toString()}'),
      );
    }
  }
}

// LockerStationModel jsonToLockerStationModel(List<dynamic> data) {
//   final stations = data.map(
//     (station) => {
//       List<ImageModel> images = station['images'].map((image)=>ImageModel(url: image['url']));
//       LockerStationModel(
//         id: station['_id'],
//         stationName: station['station_name'],
//         status: station['status'],
//         location: LocationModel(
//           type: station['location']['type'],
//           coordinates: station['location']['coordinates'],
//         ),
//         address: station['address'],
//         images: images,
//         lockers: [],
//         openingHours: [],
//       ),
//     },
//   );
// }





      // final dummyStations = [
      //   LockerStationModel(
      //     id: '1',
      //     stationName: 'Central Station',
      //     status: 'active',
      //     location: LocationModel(
      //       type: 'Point',
      //       coordinates: LatLng(
      //         event.position.latitude + 0.002,
      //         event.position.longitude + 0.001,
      //       ),
      //     ),
      //     address: '123 Main Street',
      //     images: [
      //       ImageModel(
      //         url:
      //             'https://images.unsplash.com/photo-1741531472824-b3fc55e2ff9c?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //       ),
      //       ImageModel(
      //         url:
      //             'https://images.unsplash.com/photo-1734945773941-1c3e6b340762?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //       ),
      //     ],
      //     ratings: [],
      //     reviews: [],
      //     lockers: [],
      //     openingHours: [],
      //   ),
      //   LockerStationModel(
      //     id: '2',
      //     stationName: 'Park Lockers',
      //     status: 'active',
      //     location: LocationModel(
      //       type: 'Point',
      //       coordinates: LatLng(
      //         event.position.latitude - 0.001,
      //         event.position.longitude + 0.002,
      //       ),
      //     ),
      //     address: 'Central Park',
      //     images: [
      //       ImageModel(
      //         url:
      //             'https://images.unsplash.com/photo-1737394787213-00f7b799857c?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //       ),
      //       ImageModel(
      //         url:
      //             'https://images.unsplash.com/photo-1691948580560-e412fe7fa911?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //       ),
      //     ],
      //     ratings: [],
      //     reviews: [],
      //     lockers: [],
      //     openingHours: [],
      //   ),
      // ];