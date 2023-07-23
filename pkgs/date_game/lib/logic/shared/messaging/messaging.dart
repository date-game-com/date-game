import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

bool _initialized = false;

Future<void> initializeMessaging() async {
  if (_initialized) return;
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // FirebaseMessaging.instance.onTokenRefresh.listen((String fcmToken) {
  //   // This callback is fired at each app startup and whenever a new
  //   // token is generated.
  //   debugPrint('Token refresh: $fcmToken');
  //   // TODO: If necessary send token to application server.
  // }).onError((err) {
  //   debugPrint('Error getting token: $err');
  // });
}

Future<void> helloMessaging() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('messaging token: $fcmToken');
}
