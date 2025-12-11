import 'package:flutter_test/flutter_test.dart';
import 'package:business_mine/business_mine.dart';
import 'package:business_mine/business_mine_platform_interface.dart';
import 'package:business_mine/business_mine_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBusinessMinePlatform
    with MockPlatformInterfaceMixin
    implements BusinessMinePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BusinessMinePlatform initialPlatform = BusinessMinePlatform.instance;

  test('$MethodChannelBusinessMine is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBusinessMine>());
  });

  test('getPlatformVersion', () async {
    BusinessMine businessMinePlugin = BusinessMine();
    MockBusinessMinePlatform fakePlatform = MockBusinessMinePlatform();
    BusinessMinePlatform.instance = fakePlatform;

    expect(await businessMinePlugin.getPlatformVersion(), '42');
  });
}
