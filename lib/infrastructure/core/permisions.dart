
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<PermissionStatus> hasCameraPermision() async {
    if (await Permission.camera.isDenied ||
        await Permission.camera.isPermanentlyDenied) {
      return Permission.camera.request();
    }
    return Permission.camera.status;
  }

  static Future<PermissionStatus> hasGalleryPermission() async {
    if (await Permission.mediaLibrary.isDenied ||
        await Permission.mediaLibrary.isPermanentlyDenied) {
      return Permission.mediaLibrary.request();
    }
    return Permission.mediaLibrary.status;
  }
}
