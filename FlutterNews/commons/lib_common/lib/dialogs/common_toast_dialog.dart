import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/logger.dart';
import '../utils/global_context.dart';

/// 轻弹窗参数接口
abstract class IToastDialogParams {
  late String message;
  Duration? duration;
  TextStyle? textStyle;
  Color? backgroundColor;
  BorderRadius? borderRadius;
}

/// 轻弹窗参数实现类
class ToastDialogParams implements IToastDialogParams {
  @override
  String message;
  @override
  Duration? duration;
  @override
  TextStyle? textStyle;
  @override
  Color? backgroundColor;
  @override
  BorderRadius? borderRadius;

  ToastDialogParams({
    required this.message,
    this.duration = const Duration(seconds: 1),
    this.textStyle,
    this.backgroundColor,
    this.borderRadius,
  });
}

/// 轻弹窗组件
class CommonToastView extends StatelessWidget {
  final ToastDialogParams params;

  const CommonToastView({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    // 设置默认样式
    const defaultTextStyle = TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    );

    const defaultBackgroundColor = Colors.white;

    const defaultBorderRadius = BorderRadius.all(Radius.circular(20.0));

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: params.backgroundColor ?? defaultBackgroundColor,
        borderRadius: params.borderRadius ?? defaultBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        params.message,
        style: params.textStyle ?? defaultTextStyle,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class CommonToastDialog {
  static Timer? _timer;
  static const String TAG = '[CommonToastDialog]';
  static OverlayEntry? _overlayEntry;
  static void show(IToastDialogParams params) {
    Logger.info(TAG, 'Showing toast with message: ${params.message}');

    try {
      final navigatorState = GlobalContext.globalKey.currentState;
      if (navigatorState == null) {
        Logger.error(TAG, 'Cannot show toast: Navigator state is null');
        return;
      }
      BuildContext? context = navigatorState.context;
      bool isContextValid = false;
      try {
        isContextValid = context.mounted;
      } catch (_) {
        try {
          context.findAncestorStateOfType<NavigatorState>();
          isContextValid = true;
        } catch (_) {
          isContextValid = false;
        }
      }

      if (!isContextValid) {
        Logger.error(TAG, 'Cannot show toast: BuildContext is no longer valid');
        return;
      }
      final toastParams = params is ToastDialogParams
          ? params
          : ToastDialogParams(message: params.message);
      _timer?.cancel();
      hide();
      _overlayEntry = OverlayEntry(
        builder: (BuildContext overlayContext) {
          Widget alignWidget = Align(
            alignment: Alignment.bottomCenter,
            child: CommonToastView(params: toastParams),
          );
          alignWidget = Padding(
              padding: const EdgeInsets.only(bottom: 88), child: alignWidget);
          return alignWidget;
        },
      );
      navigatorState.overlay?.insert(_overlayEntry!);
      _timer = Timer(
        toastParams.duration ?? const Duration(seconds: 1),
        () {
          try {
            hide();
          } catch (e) {
            // 忽略隐藏异常，确保定时器被清理
          } finally {
            _timer = null;
          }
        },
      );
    } catch (e) {
      _timer?.cancel();
      _timer = null;
      hide();
    }
  }

  /// 立即隐藏轻弹窗
  static void hide() {
    try {
      _timer?.cancel();
      _timer = null;

      if (_overlayEntry != null) {
        try {
          _overlayEntry?.remove();
        } catch (e) {
          // Logger.error(TAG, 'Error removing overlay: $e');
        } finally {
          _overlayEntry = null;
        }
      }
    } catch (e) {
      // Logger.error(TAG, 'Error hiding toast: $e');
      _timer?.cancel();
      _timer = null;
      _overlayEntry = null;
    }
  }
}
