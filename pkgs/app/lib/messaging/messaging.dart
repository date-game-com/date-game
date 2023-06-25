import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../shared/firebase_options.dart';
import '../shared/utils.dart';

bool _initialized = false;

Future<void> initializeMessaging() async {
  if (_initialized) return;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.instance.onTokenRefresh.listen((String fcmToken) {
    // This callback is fired at each app startup and whenever a new
    // token is generated.
    debugPrint('Token refresh: $fcmToken');
    // TODO: If necessary send token to application server.
  }).onError((err) {
    debugPrint('Error getting token: $err');
  });
}

Future<void> helloMessaging() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('messaging token: $fcmToken');
}
