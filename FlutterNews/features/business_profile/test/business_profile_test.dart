import 'package:flutter_test/flutter_test.dart';
import 'package:business_profile/business_profile.dart';
import 'package:business_profile/business_profile_platform_interface.dart';
import 'package:business_profile/business_profile_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBusinessProfilePlatform
    with MockPlatformInterfaceMixin
    implements BusinessProfilePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BusinessProfilePlatform initialPlatform = BusinessProfilePlatform.instance;

  test('$MethodChannelBusinessProfile is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBusinessProfile>());
  });

  test('getPlatformVersion', () async {
    BusinessProfile businessProfilePlugin = BusinessProfile();
    MockBusinessProfilePlatform fakePlatform = MockBusinessProfilePlatform();
    BusinessProfilePlatform.instance = fakePlatform;

    expect(await businessProfilePlugin.getPlatformVersion(), '42');
  });
}
