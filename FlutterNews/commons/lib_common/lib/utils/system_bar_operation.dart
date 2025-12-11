import 'package:flutter/services.dart';

/// 系统状态栏属性类（对应原 window.SystemBarProperties）
class SystemBarProperties {
  /// 状态栏背景色
  final Color? statusBarColor;

  /// 状态栏文字颜色是否为深色（true=深色，false=浅色）
  final bool? statusBarDarkContent;

  /// 导航栏背景色（底部导航栏）
  final Color? navigationBarColor;

  /// 导航栏文字颜色是否为深色
  final bool? navigationBarDarkContent;

  const SystemBarProperties({
    this.statusBarColor,
    this.statusBarDarkContent,
    this.navigationBarColor,
    this.navigationBarDarkContent,
  });
}

/// 系统状态栏操作工具类（对应原 SystemBarOperation）
class SystemBarOperation {
  /// 设置顶部状态栏和底部导航栏属性
  static void setWindowSystemBarProp(SystemBarProperties properties) {
    if (properties.statusBarColor != null) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: properties.statusBarColor,
          statusBarIconBrightness: properties.statusBarDarkContent ?? false
              ? Brightness.dark
              : Brightness.light,
          statusBarBrightness: properties.statusBarDarkContent ?? false
              ? Brightness.light
              : Brightness.dark,
          systemNavigationBarColor: properties.navigationBarColor,
          systemNavigationBarIconBrightness:
              properties.navigationBarDarkContent ?? false
                  ? Brightness.dark
                  : Brightness.light,
        ),
      );
    }
  }
}
