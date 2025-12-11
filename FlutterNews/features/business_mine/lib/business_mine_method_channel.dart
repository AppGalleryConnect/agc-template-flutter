import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'business_mine_platform_interface.dart';

/// An implementation of [BusinessMinePlatform] that uses method channels.
class MethodChannelBusinessMine extends BusinessMinePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('business_mine');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
