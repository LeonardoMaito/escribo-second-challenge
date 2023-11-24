
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AndroidVersion {

  static Future<String?> getAndroidVersion() async {
    try {
      final String version = await const MethodChannel('my_channel').invokeMethod('getAndroidVersion');
      return version;
    } on PlatformException catch (e) {
      print("FAILED TO GET ANDROID VERSION: ${e.message}");
      return null;
    }
  }

  static Future<bool> fetchAndroidVersion() async {
    final String? version = await getAndroidVersion();
    if (version != null) {
      String? firstPart;
      if (version.toString().contains(".")) {
        int indexOfFirstDot = version.indexOf(".");
        firstPart = version.substring(0, indexOfFirstDot);
      } else {
        firstPart = version;
      }
      int intValue = int.parse(firstPart);
      if (intValue >= 13) {
        return true;
      } else {
        final PermissionStatus status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          return true;
        } else {
          await Permission.storage.request();
        }
      }
      print("ANDROID VERSION: $intValue");
    }
    return false;
  }

}