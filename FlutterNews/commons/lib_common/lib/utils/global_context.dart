import 'package:flutter/material.dart';

/// 全局上下文工具类
class GlobalContext {
  GlobalContext._();
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get globalKey => _navigatorKey;
  static BuildContext get context => _navigatorKey.currentContext!;
}
