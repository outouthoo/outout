import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> checkPermission(TargetPlatform platform) async {
    if (platform == TargetPlatform.android) {
      bool isAllPermissionGranted = await _requestPermission();
      if (!isAllPermissionGranted) {
        isAllPermissionGranted = await _requestPermission();
        if (isAllPermissionGranted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  static Future<bool> _requestPermission() async {
    Map<Permission, PermissionStatus> permissionStatusesMap = await [
      Permission.camera,
      Permission.storage,
      Permission.microphone
    ].request();

    bool isAllPermissionGranted = true;

    List<PermissionStatus> permissionStatusList =
    permissionStatusesMap.values.toList();

    for (int i = 0; i < permissionStatusList.length; i++) {
      if (!permissionStatusList[i].isGranted) {
        isAllPermissionGranted = false;
      }
    }
    return isAllPermissionGranted;
  }
}