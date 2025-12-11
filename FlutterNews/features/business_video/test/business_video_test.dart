import 'package:flutter_test/flutter_test.dart';
import 'package:business_video/business_video.dart';
import 'package:business_video/business_video_platform_interface.dart';
import 'package:business_video/business_video_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBusinessVideoPlatform
    with MockPlatformInterfaceMixin
    implements BusinessVideoPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BusinessVideoPlatform initialPlatform = BusinessVideoPlatform.instance;

  test('$MethodChannelBusinessVideo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBusinessVideo>());
  });

  test('getPlatformVersion', () async {
    BusinessVideo businessVideoPlugin = BusinessVideo();
    MockBusinessVideoPlatform fakePlatform = MockBusinessVideoPlatform();
    BusinessVideoPlatform.instance = fakePlatform;

    expect(await businessVideoPlugin.getPlatformVersion(), '42');
  });
}
