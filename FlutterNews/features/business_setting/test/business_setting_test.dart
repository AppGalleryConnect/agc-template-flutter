import 'package:flutter_test/flutter_test.dart';
import 'package:business_setting/business_setting.dart';
import 'package:business_setting/business_setting_platform_interface.dart';
import 'package:business_setting/business_setting_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBusinessSettingPlatform
    with MockPlatformInterfaceMixin
    implements BusinessSettingPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BusinessSettingPlatform initialPlatform = BusinessSettingPlatform.instance;

  test('$MethodChannelBusinessSetting is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBusinessSetting>());
  });

  test('getPlatformVersion', () async {
    BusinessSetting businessSettingPlugin = BusinessSetting();
    MockBusinessSettingPlatform fakePlatform = MockBusinessSettingPlatform();
    BusinessSettingPlatform.instance = fakePlatform;

    expect(await businessSettingPlugin.getPlatformVersion(), '42');
  });
}
