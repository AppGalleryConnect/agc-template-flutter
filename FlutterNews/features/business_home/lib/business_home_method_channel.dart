import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'business_home_platform_interface.dart';

/// An implementation of [BusinessHomePlatform] that uses method channels.
class MethodChannelBusinessHome extends BusinessHomePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('business_home');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
