import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/lockerStation/repository/station_detail_repo.dart';
import 'package:mlock_flutter/features/map/models/lockerStation/locker_station_m.dart';
import 'package:mlock_flutter/features/saved/repositories/saved_page_repo.dart';
part 'saved_page_event.dart';
part 'saved_page_state.dart';

class SavedPageBloc extends Bloc<SavedPageEvent, SavedPageState> {
  final SavedPageRepo _savedPageRepo;
  final StationDetailRepo _stationDetailRepo;

  SavedPageBloc({
    required SavedPageRepo savedPageRepo,
    required StationDetailRepo stationDetailRepo,
  }) : _savedPageRepo = savedPageRepo,
       _stationDetailRepo = stationDetailRepo,
       super(SavedPageState.initial()) {
    on<LoadSavedStationEvent>(_loadSavedStationEvent);
    on<RefreshSavedStationEvent>(_refreshSavedStationEvent);
    on<ToggleSaveStationEvent>(_toggleSaveStationEvent);
  }

  FutureOr<void> _loadSavedStationEvent(
    LoadSavedStationEvent event,
    Emitter<SavedPageState> emit,
  ) async {
    try {
      emit(SavedPageState.loading());

      final stations = await _savedPageRepo.getSavedStationsRepo();

      logger.d('SAVED BLOC DATA: $stations');
      emit(SavedPageState.loaded(stations));
    } catch (e) {
      logger.e('Error loading saved stations: $e');
      emit(SavedPageState.error('Failed to load saved stations'));
    }
  }

  FutureOr<void> _refreshSavedStationEvent(
    RefreshSavedStationEvent event,
    Emitter<SavedPageState> emit,
  ) async {
    try {
      final stations = await _savedPageRepo.getSavedStationsRepo();

      logger.d('RefreshSavedStation bloc method data: $stations');

      emit(SavedPageState.loaded(stations));
    } catch (e) {
      logger.e('Error refreshing saved stations: $e');
      emit(SavedPageState.error('Failed to refresh stations'));
    }
  }

  FutureOr<void> _toggleSaveStationEvent(
    ToggleSaveStationEvent event,
    Emitter<SavedPageState> emit,
  ) async {
    try {
      // // 1. Immediately update UI
      // if (state.stations != null) {
      //   final newList =
      //       state.stations!.where((s) => s.id != event.stationId).toList();
      //   emit(SavedPageState.loaded(newList));
      // }

      // 2. Update server
      await _stationDetailRepo.toggleSaveStationRepo(event.stationId);

      // 3. Force fresh data refresh
      add(RefreshSavedStationEvent());
    } catch (e) {
      // Revert on error
      add(RefreshSavedStationEvent());
    }
  }
}
