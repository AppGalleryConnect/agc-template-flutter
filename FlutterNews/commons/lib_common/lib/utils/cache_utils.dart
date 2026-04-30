import 'package:flutter/services.dart';

/// 缓存工具类
class NativeCacheUtils {
  static const MethodChannel _cacheChannel =
      MethodChannel('com.news.flutter/cacheChannel');

  // 获取缓存数据
  static Future<String> getNativeCache() async {
    try {
      final dynamic cacheTotal = await _cacheChannel.invokeMethod('getCache');
      return cacheTotal;
    } catch (e) {
      return '0.0M';
    }
  }

  // 清理缓存
  static Future clearNativeCache() async {
    try {
      await _cacheChannel.invokeMethod('clearCache');
    } catch (e) {
      rethrow;
    }
  }
}
