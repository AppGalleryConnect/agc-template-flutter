import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'business_video_platform_interface.dart';

/// An implementation of [BusinessVideoPlatform] that uses method channels.
class MethodChannelBusinessVideo extends BusinessVideoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('business_video');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
