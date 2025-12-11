import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 弹窗配置项类
class PopViewOptions {
  final Color maskColor;
  final bool barrierDismissible;
  final Duration transitionDuration;
  const PopViewOptions({
    this.maskColor = Colors.black54,
    this.barrierDismissible = true,
    this.transitionDuration = const Duration(milliseconds: 200),
  });
}

/// 全局弹窗工具类
class PopViewUtils {
  static BuildContext? _currentDialogContext;
  static void showPopView({
    required WidgetBuilder builder,
    required PopViewOptions options,
  }) {
    // 1. 检查全局导航上下文是否初始化
    final globalContext = navigatorKey.currentContext;
    if (globalContext == null) {
      return;
    }
    if (_currentDialogContext != null) {
      closePopView();
    }

    // 3. 显示模态弹窗
    showGeneralDialog(
      context: globalContext,
      barrierColor: options.maskColor,
      barrierDismissible: options.barrierDismissible,
      barrierLabel: 'PopViewBarrier',
      transitionDuration: options.transitionDuration,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        _currentDialogContext = dialogContext;
        return builder(dialogContext);
      },
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ).then((_) {
      _currentDialogContext = null;
    });
  }

  /// 关闭当前显示的弹窗
  static void closePopView() {
    if (_currentDialogContext != null) {
      if (Navigator.canPop(_currentDialogContext!)) {
        Navigator.of(_currentDialogContext!).pop();
      }
      _currentDialogContext = null;
    }
  }
}

toast(String string) {
  Fluttertoast.showToast(
      msg: string,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      fontSize: 16.0);
}

/// 全局导航键
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
