import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:module_setfontsize/module_setfontsize.dart';
import '../constants/constants.dart';

/// 设置页面文本样式
class SettingTextStyles {
  SettingTextStyles._();

  static TextStyle listItemTitle(bool isDark) => TextStyle(
        fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
        fontWeight: FontWeight.w500,
        color: ThemeColors.getFontPrimary(isDark),
      );

  static TextStyle rightText(bool isDark) => TextStyle(
        fontSize: Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
        fontWeight: FontWeight.w400,
        color: ThemeColors.getFontSecondary(isDark),
      );

  static TextStyle button(bool isDark) => TextStyle(
        fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
        fontWeight: FontWeight.w500,
        color: ThemeColors.getFontPrimary(isDark),
      );

  static TextStyle title(bool isDark) => TextStyle(
        fontSize: Constants.FONT_20 * FontScaleUtils.fontSizeRatio,
        fontWeight: FontWeight.w700,
        color: ThemeColors.getFontPrimary(isDark),
      );

  static TextStyle subtitle(bool isDark) => TextStyle(
        fontSize: Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
        fontWeight: FontWeight.w400,
        color: ThemeColors.getFontSecondary(isDark),
      );

  static TextStyle description(bool isDark) => TextStyle(
        fontSize: Constants.FONT_12 * FontScaleUtils.fontSizeRatio,
        fontWeight: FontWeight.w400,
        color: ThemeColors.getFontSecondary(isDark),
      );

  static TextStyle groupTitle(bool isDark) => TextStyle(
        fontSize: Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
        fontWeight: FontWeight.w500,
        color: ThemeColors.getFontSecondary(isDark),
      );
}
