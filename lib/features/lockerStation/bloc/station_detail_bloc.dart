import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/lockerStation/repository/station_detail_repo.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';

part 'station_detail_event.dart';
part 'station_detail_state.dart';

class StationDetailBloc extends Bloc<StationDetailEvent, StationDetailState> {
  final StationDetailRepo _stationDetailRepo;

  StationDetailBloc({required StationDetailRepo stationDetailRepo})
    : _stationDetailRepo = stationDetailRepo,
      super(StationDetailState.initial()) {
    on<LoadStationDetailEvent>(_loadStationDetailEvent);
  }

  FutureOr<void> _loadStationDetailEvent(
    LoadStationDetailEvent event,
    Emitter<StationDetailState> emit,
  ) async {
    try {
      emit(StationDetailState.loading());

      final station = await _stationDetailRepo.getParticularStation(
        stationId: event.lockerId,
      );
      logger.d(
        'StationDetailBLoc _loadStationDetail method station data: $station',
      );

      emit(StationDetailState.loaded(station));
    } catch (e) {
      logger.e('StationDetailBloc LoadStationEvent method: $e');
      StationDetailState.error(e.toString());
    }
  }
}
