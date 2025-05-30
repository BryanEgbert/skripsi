import 'package:permission_handler/permission_handler.dart';

Future<bool> ensureCameraPermission() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    var result = await Permission.camera.request();
    if (!result.isGranted) {
      // You can show a dialog or message here
      return false;
    }
  }

  return true;
}
