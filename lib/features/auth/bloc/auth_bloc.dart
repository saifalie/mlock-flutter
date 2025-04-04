import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/auth/models/user/user_model.dart';
import 'package:mlock_flutter/features/auth/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mlock_flutter/services/notifications/firebase_notification.dart';
import 'package:mlock_flutter/services/secure_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseNotification _firebaseNotification;

  var authCheckHit = 0;

  late StreamSubscription<User?> _authSubscription;
  bool _initialDelayCompleted = false;
  AuthBloc({
    required AuthRepository authRepository,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseNotification firebaseNotification,
  }) : _authRepository = authRepository,
       _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn,
       _firebaseNotification = firebaseNotification,
       super(AuthState.initial()) {
    on<GoogleSignInRequestedEvent>(_googleSignInRequestedEvent);
    on<AuthCheckRequestedEvent>(_authCheckRequestedEvent);
    on<SignOutRequestedEvent>(_signOutRequestedEvent);
    on<InitialDelayCompletedEvent>(_onInitialDelayCompleted);
    on<UpdateFcmTokenEvent>(_updateFcmTokenEvent);

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

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthState.initial());
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Get FCM token
      final fcmToken = await _firebaseNotification.getToken() ?? '';

      final credentinal = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credentinal,
      );
      await _handleAuthentication(userCredential.user!, emit, fcmToken);
    } catch (e) {
      logger.e('google signin error : $e');
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _handleAuthentication(
    User user,
    Emitter<AuthState> emit,
    String fcmToken,
  ) async {
    final idToken = await user.getIdToken();
    final name = user.displayName;
    final profilePicture = user.photoURL;

    try {
      final authResponse = await _authRepository.signInWithGoogle(
        idToken!,
        name!,
        profilePicture!,
        fcmToken,
      );

      final user = authResponse['user'];
      final tokens = authResponse['tokens'];

      // emit(
      //   AuthState.authenticated(
      //     UserModel.fromJson(user),
      //     tokens['access_token'],
      //   ),
      // );

      logger.d(
        'user info: id: ${user['id']} name: ${user['name']} profilePicture ${user['profilePicture']} email: ${user['email']}',
      );

      emit(
        AuthState.authenticated(
          UserModel(
            id: user['id'],
            name: user['name'],
            profilePicture: user['profilePicture'],
            email: user['email'],
            // coordinates: user['location']['coordinates'],
          ),
          tokens['accessToken'],
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

      final fcmToken = await _firebaseNotification.getToken() ?? '';

      if (user == null) {
        await SecureStorage.clearTokens();
        emit(AuthState.unauthenticated());
        return;
      }

      final accessToken = await SecureStorage.getAccessToken();
      if (accessToken == null) {
        await _handleAuthentication(user, emit, fcmToken);
        return;
      }
      final userData = await _authRepository.getUserData(true);
      logger.d('userdata authbloc ${userData['currentLocker']}');

      emit(AuthState.authenticated(UserModel.fromJson(userData), accessToken));

      emit(
        AuthState.authenticated(
          UserModel(
            id: userData['_id'],
            email: userData['email'],
            name: userData['name'],
            currentLocker: userData['currentLocker'],
            profilePicture: userData['profilePicture'],
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

  FutureOr<void> _updateFcmTokenEvent(
    UpdateFcmTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Only update if user is authenticated
      if (state.status == AuthStatus.authenticated) {
        final currentUser = _firebaseAuth.currentUser;
        if (currentUser != null) {
          // Call repository method to update FCM token
          await _authRepository.updateFcmTokenRepo(event.fcmToken);
          logger.d('FCM token updated successfully');
        }
      }
    } catch (e) {
      logger.e('Error updating FCM token: $e');
    }
  }
}
