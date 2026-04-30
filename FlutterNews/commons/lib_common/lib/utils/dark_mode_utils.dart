import 'package:flutter/services.dart';


/// 主题工具类
class DarkModeUtils {
  static const MethodChannel _darkModeChannel =
      MethodChannel('com.news.flutter/darkModeChange');

  // 设置主题
  static Future<void> setDarkMode(mode) async {
    await _darkModeChannel.invokeMethod('darkModeChange', mode);
  }

  // 查询系统主题
  static Future<bool> querySystemMode() async {
    try {
      final result =
          await _darkModeChannel.invokeMethod<bool>('querySystemMode');
      return result ?? false;
    } on PlatformException catch (e) {
      return false;
    }
  }
}
