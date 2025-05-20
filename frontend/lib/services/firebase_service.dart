import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleMessage(RemoteMessage? message) async {
  if (message == null) return;
}

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
