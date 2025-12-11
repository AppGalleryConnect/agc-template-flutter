import 'package:flutter/services.dart';

class NativeNavigationUtils {
  static const String TAG = '[NativeNavigationUtils]';

  static const MethodChannel _channel =
      MethodChannel('com.news.flutter/navigation');

  static Future<bool> pushToNativePage({
    required String pageName,
    Map<String, dynamic>? params,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('pushNativePage', {
        'pageName': pageName,
        'params': params ?? {},
      });

      return result ?? false;
    } catch (e) {
      return false;
    }
  }

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
}
