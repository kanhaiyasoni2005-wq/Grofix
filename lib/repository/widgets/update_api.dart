import 'package:in_app_update/in_app_update.dart';

Future<void> checkForUpdate() async {
  try {
    AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

    if (updateInfo.updateAvailability ==
        UpdateAvailability.updateAvailable) {

      // Force Update
      await InAppUpdate.performImmediateUpdate();
    }
  } catch (e) {
    print("Update Error: $e");
  }
}