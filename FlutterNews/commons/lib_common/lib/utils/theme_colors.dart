import 'package:flutter/material.dart';

/// 主题颜色管理类
class ThemeColors {
  ThemeColors._();

  /// 根据深色模式返回相应的颜色
  static Color getBackgroundColor(bool isDark) {
    return isDark ? const Color(0xFF1F1F1F) : Colors.white;
  }

  static Color getBackgroundSecondary(bool isDark) {
    return isDark ? const Color(0xFF000000) : const Color(0xFFF1F3F5);
  }

  static Color getBackgroundTertiary(bool isDark) {
    return isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE5E5E5);
  }

  static Color getCompBackgroundSecondary(bool isDark) {
    return isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF1F3F5);
  }

  static Color getFontPrimary(bool isDark) {
    return isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  }

  static Color getFontSecondary(bool isDark) {
    return isDark ? const Color(0x99FFFFFF) : const Color(0x99000000);
  }

  static Color getFontTertiary(bool isDark) {
    return isDark ? const Color(0x66FFFFFF) : const Color(0x66000000);
  }

  static Color getDivider(bool isDark) {
    return isDark ? const Color(0x33FFFFFF) : const Color(0x33000000);
  }

  static Color getCardBackground(bool isDark) {
    return getBackgroundColor(isDark);
  }

  static Color getArrowIcon(bool isDark) {
    return isDark ? const Color(0x99FFFFFF) : const Color(0x99000000);
  }

  static Color getGradientStart(bool isDark) {
    return isDark ? const Color(0xFF1A1A1A) : const Color(0xFFDFE8FB);
  }

  static Color getGradientEnd(bool isDark) {
    return isDark ? const Color(0xFF1F1F1F) : const Color(0xFFF1F3F5);
  }

  /// 互动模块专用颜色
  static LinearGradient getInteractionGradient(bool isDark) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? [
              const Color(0xFF1A1A1A),
              const Color(0xFF1F1F1F),
            ]
          : [
              const Color(0xFFDFE8FB),
              const Color(0xFFF1F3F5),
            ],
      stops: const [0.05, 0.12],
    );
  }

  /// 主题色（不随深色模式变化）
  static const Color appTheme = Color(0xFF5C79D9);
  static const Color appThemeSecondary = Color(0xFF317AF7);
}
