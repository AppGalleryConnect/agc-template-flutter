import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'business_setting_platform_interface.dart';

/// An implementation of [BusinessSettingPlatform] that uses method channels.
class MethodChannelBusinessSetting extends BusinessSettingPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('business_setting');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
