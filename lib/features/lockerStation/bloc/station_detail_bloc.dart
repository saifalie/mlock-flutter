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
    on<ToggleSaveStationEvent>(_toggleSaveStationEvent);
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

      // Check if station is saved
      final isSaved = await _stationDetailRepo.isStationSavedRepo(station.id);

      logger.d('Station loaded - Saved status: $isSaved');

      emit(StationDetailState.loaded(station, isSaved: isSaved));
    } catch (e) {
      logger.e('StationDetailBloc LoadStationEvent method: $e');
      StationDetailState.error(e.toString());
    }
  }

  FutureOr<void> _toggleSaveStationEvent(
    ToggleSaveStationEvent event,
    Emitter<StationDetailState> emit,
  ) async {
    try {
      if (state.status != StationDetailStatus.loaded || state.station == null)
        return null;

      final currentStation = state.station;
      final newSavedStatus = !state.isSaved;

      // Update local state immediately for better UX
      emit(state.copyWith(isSaved: newSavedStatus));

      // Persist the change
      if (newSavedStatus) {
        await _stationDetailRepo.toggleSaveStationRepo(event.stationId);
      } else {
        await _stationDetailRepo.toggleSaveStationRepo(event.stationId);
      }

      // Perform server operation
      // await _stationDetailRepo.toggleSaveStationRepo(currentStation!.id);
      logger.d(
        'Station ${event.stationId} save status updated to $newSavedStatus',
      );
    } catch (e) {
      logger.e('Toggle save error: $e');
      // Revert state on error
      emit(state.copyWith(isSaved: !state.isSaved));
    }
  }
}
