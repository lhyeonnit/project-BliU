import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  Future<void> requestPermission() async {
    await Permission.notification.request();

    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    final int androidVersion = int.parse(androidInfo.version.release);

    if (androidVersion >= 13) {
      await Permission.photos.request();
    } else {
      await Permission.storage.request();
    }
  }
}