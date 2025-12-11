import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'business_setting_method_channel.dart';

abstract class BusinessSettingPlatform extends PlatformInterface {
  /// Constructs a BusinessSettingPlatform.
  BusinessSettingPlatform() : super(token: _token);

  static final Object _token = Object();

  static BusinessSettingPlatform _instance = MethodChannelBusinessSetting();

  /// The default instance of [BusinessSettingPlatform] to use.
  ///
  /// Defaults to [MethodChannelBusinessSetting].
  static BusinessSettingPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BusinessSettingPlatform] when
  /// they register themselves.
  static set instance(BusinessSettingPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
