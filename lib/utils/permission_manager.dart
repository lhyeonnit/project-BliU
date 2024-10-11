import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  Future<void> requestPermission() async {
    await Permission.notification.request();
  }
}