import 'package:flutter_test/flutter_test.dart';
import 'package:business_interaction/business_interaction.dart';
import 'package:business_interaction/business_interaction_platform_interface.dart';
import 'package:business_interaction/business_interaction_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBusinessInteractionPlatform
    with MockPlatformInterfaceMixin
    implements BusinessInteractionPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BusinessInteractionPlatform initialPlatform = BusinessInteractionPlatform.instance;

  test('$MethodChannelBusinessInteraction is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBusinessInteraction>());
  });

  test('getPlatformVersion', () async {
    BusinessInteraction businessInteractionPlugin = BusinessInteraction();
    MockBusinessInteractionPlatform fakePlatform = MockBusinessInteractionPlatform();
    BusinessInteractionPlatform.instance = fakePlatform;

    expect(await businessInteractionPlugin.getPlatformVersion(), '42');
  });
}
