import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'business_interaction_method_channel.dart';

abstract class BusinessInteractionPlatform extends PlatformInterface {
  /// Constructs a BusinessInteractionPlatform.
  BusinessInteractionPlatform() : super(token: _token);

  static final Object _token = Object();

  static BusinessInteractionPlatform _instance = MethodChannelBusinessInteraction();

  /// The default instance of [BusinessInteractionPlatform] to use.
  ///
  /// Defaults to [MethodChannelBusinessInteraction].
  static BusinessInteractionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BusinessInteractionPlatform] when
  /// they register themselves.
  static set instance(BusinessInteractionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
