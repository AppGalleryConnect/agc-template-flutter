import 'package:flutter/services.dart';

/// Flutter 双屏检测工具类
class FlutterDualScreen {
  static const String TAG = '[FlutterDualScreen]';

  // MethodChannel 实例
  static const MethodChannel _channel =
      MethodChannel('com.news.flutter/navigation');

  /// 检查设备是否支持双屏
  static Future<bool> get isDualScreenDevice async {
    try {
      print('$TAG 检查设备是否支持双屏');
      final result = await _channel.invokeMethod<bool>('isDualScreenDevice');
      print('$TAG 双屏检测结果: $result');
      return result ?? false;
    } catch (e) {
      print('$TAG 双屏检测失败: $e');
      return false;
    }
  }

  /// 获取屏幕信息
  static Future<Map<String, dynamic>> getDisplayFeatures() async {
    try {
      print('$TAG 获取屏幕信息');
      final result = await _channel.invokeMethod<Map>('getDisplayFeatures');
      print('$TAG 屏幕信息获取成功');
      return result != null ? Map<String, dynamic>.from(result) : {};
    } catch (e) {
      print('$TAG 获取屏幕信息失败: $e');
      return {};
    }
  }
}
