import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'business_home_method_channel.dart';

abstract class BusinessHomePlatform extends PlatformInterface {
  /// Constructs a BusinessHomePlatform.
  BusinessHomePlatform() : super(token: _token);

  static final Object _token = Object();

  static BusinessHomePlatform _instance = MethodChannelBusinessHome();

  /// The default instance of [BusinessHomePlatform] to use.
  ///
  /// Defaults to [MethodChannelBusinessHome].
  static BusinessHomePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BusinessHomePlatform] when
  /// they register themselves.
  static set instance(BusinessHomePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
