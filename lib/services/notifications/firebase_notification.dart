import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mlock_flutter/core/utils/logger.dart';

class FirebaseNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    logger.d('fcmToken: $fCMToken');
  }
}
