import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/auth/models/user/user_model.dart';
import 'package:mlock_flutter/features/auth/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mlock_flutter/services/secure_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  var authCheckHit = 0;

  late StreamSubscription<User?> _authSubscription;
  bool _initialDelayCompleted = false;
  AuthBloc({
    required AuthRepository authRepository,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  }) : _authRepository = authRepository,
       _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn,
       super(AuthState.initial()) {
    on<GoogleSignInRequestedEvent>(_googleSignInRequestedEvent);
    on<AuthCheckRequestedEvent>(_authCheckRequestedEvent);
    on<SignOutRequestedEvent>(_signOutRequestedEvent);
    on<InitialDelayCompletedEvent>(_onInitialDelayCompleted);

    // _authSubscription = _firebaseAuth.authStateChanges().listen((user) {
    //   if (user != null) {
    //     add(AuthCheckRequestedEvent());
    //   } else {
    //     add(AuthCheckRequestedEvent());
    //   }
    // });

    // Add initial delay before listening to auth changes
    Future.delayed(const Duration(seconds: 1)).then((_) {
      add(InitialDelayCompletedEvent());
    });
  }

  void _onInitialDelayCompleted(
    InitialDelayCompletedEvent event,
    Emitter<AuthState> emit,
  ) {
    _initialDelayCompleted = true;
    // Now start listening to auth changes
    _authSubscription = _firebaseAuth.authStateChanges().listen((user) {
      if (_initialDelayCompleted) {
        add(AuthCheckRequestedEvent());
      }
    });
  }

  FutureOr<void> _googleSignInRequestedEvent(
    GoogleSignInRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthState.initial());
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credentinal = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credentinal,
      );
      await _handleAuthentication(userCredential.user!, emit);
    } catch (e) {
      logger.e('google signin error : $e');
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _handleAuthentication(User user, Emitter<AuthState> emit) async {
    final idToken = await user.getIdToken();
    final name = user.displayName;
    final profilePicture = user.photoURL;

    try {
      final authResponse = await _authRepository.signInWithGoogle(
        idToken!,
        name!,
        profilePicture!,
      );

      final user = authResponse['user'];
      final tokens = authResponse['tokens'];

      // emit(
      //   AuthState.authenticated(
      //     UserModel.fromJson(user),
      //     tokens['access_token'],
      //   ),
      // );

      emit(
        AuthState.authenticated(
          UserModel(
            id: user['_id'],
            name: user['name'],
            profilePicture: user['profile_picture'],
            email: user['email'],
            // coordinates: user['location']['coordinates'],
          ),
          tokens['access_token'],
        ),
      );
    } catch (e) {
      logger.e('Error in _handleAuthentication : $e');
      emit(AuthState.error(e.toString()));
    }
  }

  FutureOr<void> _authCheckRequestedEvent(
    AuthCheckRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    logger.d('AuthCheck Method hit --->');
    authCheckHit++;
    logger.d('authhit $authCheckHit');
    if (state.status == AuthStatus.loading) return;
    emit(AuthState.loading());

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final user = _firebaseAuth.currentUser;
      logger.d('Auth Check - Firebase User: $user');

      if (user == null) {
        await SecureStorage.clearTokens();
        emit(AuthState.unauthenticated());
        return;
      }

      final accessToken = await SecureStorage.getAccessToken();
      if (accessToken == null) {
        await _handleAuthentication(user, emit);
        return;
      }
      final userData = await _authRepository.getUserData(true);
      logger.d('userdata authbloc $userData');

      emit(AuthState.authenticated(UserModel.fromJson(userData), accessToken));

      emit(
        AuthState.authenticated(
          UserModel(
            id: userData['_id'],
            email: userData['email'],
            name: userData['name'],
            currentLocker: userData['current_locker'],
            profilePicture: userData['profile_picture'],
            coordinates: userData['location']['coordinates'],
          ),

          accessToken,
        ),
      );
    } catch (e) {
      logger.e('Auth Check Error: $e');

      if (e is! SocketException) {
        await _firebaseAuth.signOut();
        await _googleSignIn.signOut();
        await SecureStorage.clearTokens();
      }
      emit(AuthState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _signOutRequestedEvent(
    SignOutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());

      logger.d('Sign Out Method called');
      //sign out from firebase
      await _firebaseAuth.signOut();

      // sign out from google
      await _googleSignIn.signOut();

      //clear secure storage
      await SecureStorage.clearTokens();
      logger.d('Sign Out Method called');
      emit(AuthState.unauthenticated());
    } catch (e) {
      logger.e('got error while sign out');
      emit(AuthState.error(e.toString()));
    }
  }
}
