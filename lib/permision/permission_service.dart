import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class PermissionService {

  static Future<void> askPermissions() async {

    // Notification
    await Permission.notification.request();

    // Location
    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission ==
        LocationPermission.deniedForever) {
      openAppSettings();
    }
  }
}