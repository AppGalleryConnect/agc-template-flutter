import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'business_profile_platform_interface.dart';

class MethodChannelBusinessProfile extends BusinessProfilePlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('business_profile');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
