import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlock_flutter/core/constants/navigation.constants.dart';
import 'package:mlock_flutter/core/utils/logger.dart';
import 'package:mlock_flutter/features/auth/bloc/auth_bloc.dart';

class FirebaseNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;
  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    _fcmToken = await _firebaseMessaging.getToken();
    logger.d('Initial FCM Token: $_fcmToken');

    // Listen for token refreshes
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      logger.d('FCM token refreshed: $newToken');

      _handleTokenUpdate(newToken);
    });
  }

  void _handleTokenUpdate(String newToken) {
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      try {
        final authBloc = BlocProvider.of<AuthBloc>(context);
        authBloc.add(UpdateFcmTokenEvent(newToken));
      } catch (e) {
        logger.e('Error updating FCM token: $e');
      }
    }
  }

  // Method to get token on demand
  Future<String?> getToken() async {
    _fcmToken ??= await _firebaseMessaging.getToken();
    return _fcmToken;
  }
}
