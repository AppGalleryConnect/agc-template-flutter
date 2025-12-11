import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'business_profile_method_channel.dart';

abstract class BusinessProfilePlatform extends PlatformInterface {
  BusinessProfilePlatform() : super(token: _token);
  static final Object _token = Object();
  static BusinessProfilePlatform _instance = MethodChannelBusinessProfile();
  static BusinessProfilePlatform get instance => _instance;
  static set instance(BusinessProfilePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
