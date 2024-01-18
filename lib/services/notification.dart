import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static Future<void> init() async {
    if (kDebugMode) {
      FirebaseMessaging.instance
          .getToken()
          .then((m) => debugPrint('firebase_message_token: $m'));
    }
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Received a message while in the foreground'
          '\nmessage.data: ${message.data}');
      if (message.notification != null) {
        debugPrint('Message also contained a notification: '
            '${message.notification}');
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Received a message while in the background'
      '\nmessage.data: ${message.data}');
  if (message.notification != null) {
    debugPrint('Message also contained a notification: '
        '${message.notification}');
  }
}
