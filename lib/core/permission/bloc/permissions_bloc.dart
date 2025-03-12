import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  DateTime _lastCheckTime = DateTime(1970);
  PermissionsBloc() : super(PermissionsState.initial()) {
    on<CheckPermissionsEvent>(_checkPermissionsEvent);
    on<RequestLocationPermissionEvent>(_requestLocationPermissionEvent);
  }

  FutureOr<void> _checkPermissionsEvent(
    CheckPermissionsEvent event,
    Emitter<PermissionsState> emit,
  ) async {
    // Throttle checks to 1 per second
    if (DateTime.now().difference(_lastCheckTime) < Duration(seconds: 1)) {
      return;
    }
    _lastCheckTime = DateTime.now();
    // Only proceed if not already loading
    if (state.status != PermissionStatusI.loading) {
      emit(PermissionsState.loading(DateTime.now()));

      final status = await Permission.location.status;
      logger.d('check permission event');

      // Only emit new state if status changed
      if (status.isGranted && state.status != PermissionStatusI.granted) {
        emit(PermissionsState.granted(DateTime.now()));
      } else if (!status.isGranted &&
          state.status != PermissionStatusI.denied) {
        emit(PermissionsState.denied(DateTime.now()));
      }
    }
  }

  FutureOr<void> _requestLocationPermissionEvent(
    RequestLocationPermissionEvent event,
    Emitter<PermissionsState> emit,
  ) async {
    logger.d('request permission event');
    emit(PermissionsState.loading(DateTime.now()));

    final status = await Permission.location.request();
    logger.d('permission status: $status');
    if (status.isGranted) {
      logger.d('permission status granteddddd');
      emit(PermissionsState.granted(DateTime.now()));
    } else if (status.isPermanentlyDenied) {
      logger.d('permission status permanentely dineedddd');
      emit(PermissionsState.deniedPermanently(DateTime.now()));
    } else {
      logger.d('permission status deiniedddd');
      emit(PermissionsState.denied(DateTime.now()));
    }
  }
}
