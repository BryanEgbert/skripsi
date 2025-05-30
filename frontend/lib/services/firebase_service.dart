import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<void> handleMessage(RemoteMessage? message) async {
  if (message == null) return;
}

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> initRemoteConfig() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(hours: 1),
        minimumFetchInterval: Duration(seconds: 10),
      ),
    );
    await _remoteConfig.setDefaults({
      "backend_host": "10.0.2.2:8080",
      "mock_location_service": true,
    });
    await _remoteConfig.fetchAndActivate();
  }
}
