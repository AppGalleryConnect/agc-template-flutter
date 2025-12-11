import 'package:flutter/services.dart';

const String _TAG = '[AppGalleryUtils]';

/// 应用市场工具类
class AppGalleryUtils {
  static const MethodChannel _channel = MethodChannel(
    'com.news.flutter/app_gallery',
  );

  /// 检查应用是否有更新版本
  static Future<bool> checkAppUpdate() async {
    try {
      final bool? hasUpdate = await _channel.invokeMethod(
        'checkAppUpdate',
      );
      return hasUpdate ?? false;
    } on PlatformException {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 显示应用更新对话框
  static Future<void> showUpdateDialog() async {
    await _channel.invokeMethod(
      'showUpdateDialog',
    );
  }
}
