import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'business_mine_method_channel.dart';

abstract class BusinessMinePlatform extends PlatformInterface {
  /// Constructs a BusinessMinePlatform.
  BusinessMinePlatform() : super(token: _token);

  static final Object _token = Object();

  static BusinessMinePlatform _instance = MethodChannelBusinessMine();

  /// The default instance of [BusinessMinePlatform] to use.
  ///
  /// Defaults to [MethodChannelBusinessMine].
  static BusinessMinePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BusinessMinePlatform] when
  /// they register themselves.
  static set instance(BusinessMinePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
