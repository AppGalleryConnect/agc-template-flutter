import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'business_interaction_platform_interface.dart';

/// An implementation of [BusinessInteractionPlatform] that uses method channels.
class MethodChannelBusinessInteraction extends BusinessInteractionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('business_interaction');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
