import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/constants.dart';


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
      fontSize: Constants.FONT_14,
      color: Colors.black,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    );

    const defaultBackgroundColor = Colors.white;

    const defaultBorderRadius = BorderRadius.all(Radius.circular(Constants.SPACE_20));

    // 增强阴影和对比度以提高可见性
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.SPACE_16,
        vertical: Constants.SPACE_12,
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



/// 轻弹窗工具类
class CommonToastDialog {
   static void show(IToastDialogParams params, BuildContext context) {
      final toastParams = params is ToastDialogParams
          ? params
          : ToastDialogParams(message: params.message);
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.1),
        useRootNavigator: true,
        builder: (BuildContext dialogContext) {
          Widget alignWidget = Align(
            alignment: Alignment.bottomCenter,
            child: CommonToastView(params: toastParams),
          );
          alignWidget = Padding(
              padding: const EdgeInsets.only(bottom: Constants.SPACE_88), child: alignWidget);

          Future.delayed(const Duration(seconds: 1), () => Navigator.pop(dialogContext));
          return alignWidget;
        },
      );
   }
}
