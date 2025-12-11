import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';

/// 自定义徽章组件
class CustomBadge extends StatelessWidget {
  /// 徽章显示的文本
  final String text;

  /// 徽章背景颜色
  final Color? backgroundColor;

  /// 徽章文本颜色
  final Color? textColor;

  /// 徽章字体大小
  final double? fontSize;

  /// 徽章最小宽度
  final double minWidth;

  /// 徽章高度
  final double height;

  /// 徽章水平内边距
  final double horizontalPadding;

  /// 徽章文本样式
  final TextStyle? textStyle;

  /// 徽章圆角
  final double borderRadius;

  /// 徽章内文本对齐方式
  final TextAlign textAlign;

  const CustomBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.minWidth = 24.0,
    this.height = 18.0,
    this.horizontalPadding = 4.0,
    this.textStyle,
    this.borderRadius = 9.0,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    // 如果文本为空，不显示徽章
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    // 构建默认文本样式
    final defaultTextStyle = TextStyle(
      fontSize: fontSize ?? CommonConstants.SPACE_M,
      color: textColor ?? Colors.white,
      fontWeight: FontWeight.w500,
    );

    // 合并自定义文本样式和默认文本样式
    final finalTextStyle =
        textStyle?.merge(defaultTextStyle) ?? defaultTextStyle;

    return Container(
      constraints: BoxConstraints(
        minWidth: minWidth,
        minHeight: height,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFE63737), // 默认红色背景
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: finalTextStyle,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

/// 角标位置枚举
enum BadgePosition {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}

/// 带徽章的组件包装器
class BadgeWrapper extends StatelessWidget {
  /// 子组件
  final Widget child;

  /// 徽章组件
  final Widget badge;

  /// 徽章位置
  final BadgePosition position;

  /// 徽章相对于子组件的偏移量
  final Offset offset;

  const BadgeWrapper({
    super.key,
    required this.child,
    required this.badge,
    this.position = BadgePosition.topRight,
    this.offset = const Offset(0, 0),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: position == BadgePosition.topRight ||
                  position == BadgePosition.topLeft
              ? -offset.dy
              : null,
          bottom: position == BadgePosition.bottomRight ||
                  position == BadgePosition.bottomLeft
              ? -offset.dy
              : null,
          left: position == BadgePosition.topLeft ||
                  position == BadgePosition.bottomLeft
              ? -offset.dx
              : null,
          right: position == BadgePosition.topRight ||
                  position == BadgePosition.bottomRight
              ? -offset.dx
              : null,
          child: badge,
        ),
      ],
    );
  }
}

/// 简化的数字徽章
class NumberBadge extends StatelessWidget {
  /// 显示的数字
  final int count;

  /// 最大显示数字
  final int maxCount;

  /// 背景颜色
  final Color? backgroundColor;

  /// 文本颜色
  final Color? textColor;

  /// 数字为0时是否显示
  final bool showZero;

  /// 徽章最小宽度
  final double minWidth;

  /// 徽章高度
  final double height;

  /// 徽章水平内边距
  final double horizontalPadding;

  const NumberBadge({
    super.key,
    required this.count,
    this.maxCount = 99,
    this.backgroundColor,
    this.textColor,
    this.showZero = false,
    this.minWidth = 20.0,
    this.height = 16.0,
    this.horizontalPadding = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0 && !showZero) {
      return const SizedBox.shrink();
    }
    String displayText = count.toString();
    if (count > maxCount) {
      displayText = '$maxCount+';
    }
    return CustomBadge(
      text: displayText,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: CommonConstants.SPACE_S,
      minWidth: minWidth,
      height: height,
      horizontalPadding: horizontalPadding,
    );
  }
}
