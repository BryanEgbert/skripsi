import 'package:permission_handler/permission_handler.dart';

Future<bool> ensureCameraPermission() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    PermissionStatus result = await Permission.camera.request();
    if (result.isDenied) {
      return false;
    }
  }

  return true;
}
