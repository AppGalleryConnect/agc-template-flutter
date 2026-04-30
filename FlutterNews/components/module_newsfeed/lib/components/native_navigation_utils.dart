import 'package:flutter/services.dart';

class NativeNavigationUtils {
  static const String TAG = '[NativeNavigationUtils]';

  static const MethodChannel _channel =
      MethodChannel('com.news.flutter/navigation');

  static Future<String> pushToScan() async {
    try {
      final result = await _channel.invokeMethod<String>('scan', {});

      return result ?? '扫码失败';
    } catch (e) {
      return '扫码失败';
    }
  }

  static Future<String> getLocation() async {
    try {
      final result = await _channel.invokeMethod<Map>('location', {});
      String city = result?['city']?.toString() ?? '定位失败';
      return city;
    } catch (e) {
      return '定位失败';
    }
  }

  // 开启碰一碰分享监听
  static Future<String> listenToKnockShare(
      {Map<String, dynamic>? params}) async {
    try {
      final result = await _channel.invokeMethod<String>('onKnockShare', {
        'params': params,
      });
      return result ?? '失败';
    } catch (e) {
      return '失败';
    }
  }

  static Future<String> listenToOffKnockShare(
      {Map<String, dynamic>? params}) async {
    try {
      final result = await _channel.invokeMethod<String>('offKnockShare');
      return result ?? '失败';
    } catch (e) {
      return '失败';
    }
  }


  // 隔空抓取
  static Future<String> listenToGestureShare(
      {Map<String, dynamic>? params}) async {
    try {
      final result = await _channel.invokeMethod<String>('onGestureShare', {
        'params': params,
      });
      return result ?? '失败';
    } catch (e) {
      return '失败';
    }
  }

  static Future<String> listenToOffGestureShare(
      {Map<String, dynamic>? params}) async {
    try {
      final result = await _channel.invokeMethod<String>('offGestureShare');
      return result ?? '失败';
    } catch (e) {
      return '失败';
    }
  }
  static Future<String> pushToShare({Map<String, dynamic>? params}) async {
    try {
      final result = await _channel.invokeMethod<String>('share', {
        'params': params,
      });
      return result ?? '失败';
    } catch (e) {
      return '失败';
    }
  }

  static Future<String> pushToShareWX({Map<String, dynamic>? params}) async {
    try {
      final result = await _channel.invokeMethod<String>('wxShare', {
        'params': params,
      });
      return result ?? '失败';
    } catch (e) {
      return '失败';
    }
  }

  static Future<String> AInews({required Map<String, String> params}) async {
    try {
      final result = await _channel.invokeMethod<String>('AInews', params);
      return result ?? '失败';
    } catch (e) {
      return '失败';
    }
  }

  static Future<String> getCache() async {
    try {
      final result = await _channel.invokeMethod<String>('getCache');
      return result ?? '失败';
    } catch (e) {
      return '失败';
    }
  }
}
