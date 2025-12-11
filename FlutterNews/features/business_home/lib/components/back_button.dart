import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lib_common/constants/common_constants.dart';
import '../commons/constants.dart';

/// 返回按钮组件
class AppBackButton extends StatelessWidget {
  /// 点击按钮时的回调函数
  final VoidCallback? onPressed;

  /// 按钮的背景颜色
  final Color? backgroundColor;

  /// 图标颜色
  final Color? iconColor;

  /// 图标大小
  final double iconSize;

  /// 按钮的尺寸
  final double size;

  /// 按钮的内边距
  final EdgeInsets padding;
  const AppBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.iconSize = 22,
    this.size = 40,
    this.padding = Constants.backButtonPadding,
  });

  @override
  Widget build(BuildContext context) {
    void defaultOnPressed() {
      Navigator.of(context).pop();
    }

    return Container(
      margin: padding,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Constants.backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          CommonConstants.iconBackPath,
          width: Constants.backButtonWidth,
          height: Constants.backButtonHeight,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.primary,
            BlendMode.srcIn,
          ),
          fit: BoxFit.contain,
        ),
        onPressed: onPressed ?? defaultOnPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
