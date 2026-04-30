import 'package:flutter/services.dart';


/// 全屏工具类
class OrientationUtils {
  static const MethodChannel _orientationChannel =
      MethodChannel('com.news.flutter/orientationChannel');

  // 设置全屏
  static Future<void> handleOrientation() async {
    await _orientationChannel.invokeMethod('handleOrientation');
  }

  // 退出全屏
  static Future<void> quitFullScreen() async {
    await _orientationChannel.invokeMethod('quitFullScreen');
  }
}
