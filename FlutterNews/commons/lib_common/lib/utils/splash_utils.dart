import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../constants/router_map.dart';
import 'Logger.dart';
import 'global_context.dart';

/// 原生路由跳转工具类
class SplashUtils {
  static BuildContext? _globalContext;

  static const MethodChannel _splashChannel =
      MethodChannel('com.news.flutter/routerToSplash');
  static const MethodChannel _routerChannel =
      MethodChannel('com.news.flutter/pushToIndex');

  static Future<void> initRouterLis(context) async {
    _globalContext = context;
    _routerChannel.setMethodCallHandler(flutterMethod);
  }

  static Future<void> flutterMethod(
    MethodCall methodCall,
  ) async {
    switch (methodCall.method) {
      case 'pushToIndex':
        GlobalContext.globalKey.currentState!
            .pushReplacementNamed(RouterMap.INDEX_PAGE);
        break;
      default:
    }
  }

  // 跳转到广告页
  static Future<void> goToSplash() async {
    try {
      await _splashChannel.invokeMethod('goToSplash');
    } catch (e) {
      Logger.info('push to splash page failed');
    }
  }
}
