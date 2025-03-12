import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:mlock_flutter/data/user/repository/user_repository.dart';
import 'package:mlock_flutter/features/auth/models/user/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  UserBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(UserState.initial()) {
    on<LoadUserDataEvent>(_loadUserDataEvent);
    on<ClearUserDataEvent>(_clearUserDataEvent);
  }

  FutureOr<void> _loadUserDataEvent(
    LoadUserDataEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserState.loading());

    try {
      final user = await _userRepository.getUserData(
        forceRefresh: event.forceRefresh,
      );

      emit(UserState.loaded(user));
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  FutureOr<void> _clearUserDataEvent(
    ClearUserDataEvent event,
    Emitter<UserState> emit,
  ) async {
    await _userRepository.clearUserData();
    emit(UserState.initial());
  }
}
