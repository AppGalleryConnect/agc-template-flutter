import 'package:flutter_test/flutter_test.dart';
import 'package:business_home/business_home.dart';
import 'package:business_home/business_home_platform_interface.dart';
import 'package:business_home/business_home_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBusinessHomePlatform
    with MockPlatformInterfaceMixin
    implements BusinessHomePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BusinessHomePlatform initialPlatform = BusinessHomePlatform.instance;

  test('$MethodChannelBusinessHome is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBusinessHome>());
  });

  test('getPlatformVersion', () async {
    BusinessHome businessHomePlugin = BusinessHome();
    MockBusinessHomePlatform fakePlatform = MockBusinessHomePlatform();
    BusinessHomePlatform.instance = fakePlatform;

    expect(await businessHomePlugin.getPlatformVersion(), '42');
  });
}
