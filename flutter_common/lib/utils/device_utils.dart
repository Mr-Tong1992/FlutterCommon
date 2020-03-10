import 'package:flutter_common/flutter_common.dart';

/// 平台类型
enum OSPlatform{
  Android,
  iOS,
}

class DeviceUtils {

  /// 平台类型
  static Future<OSPlatform> osPlatform () async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if(androidInfo != null){
      return OSPlatform.Android;
    }
    return OSPlatform.iOS;
  }
}