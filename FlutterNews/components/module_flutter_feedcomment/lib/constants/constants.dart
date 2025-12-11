// 常量定义
import 'package:flutter/material.dart';

class Constants {
  static const double SPACE_0 = 0.0;
  static const double SPACE_1 = 1.0;
  static const double SPACE_1_5 = 1.5;
  static const double SPACE_5 = 5.0;
  static const double SPACE_6 = 6.0;
  static const double SPACE_8 = 8.0;
  static const double SPACE_9 = 9.0;
  static const double SPACE_10 = 10.0;
  static const double SPACE_12 = 12.0;
  static const double SPACE_14 = 14.0;
  static const double SPACE_16 = 16.0;
  static const double SPACE_18 = 18.0;
  static const double SPACE_20 = 20.0;
  static const double SPACE_21 = 21.0;
  static const double SPACE_22 = 22.0;
  static const double SPACE_24 = 24.0;
  static const double SPACE_36 = 36.0;
  static const double SPACE_40 = 40.0;
  static const double SPACE_88 = 88.0;

  static const double FONT_10 = 10.0;
  static const double FONT_12 = 12.0;
  static const double FONT_14 = 14.0;
  static const double FONT_16 = 16.0;
  static const double FONT_18 = 18.0;
  static const double FONT_20 = 20.0;

  static const Color commendTextColor1 = Color(0xFFBEC9F0);
  static const Color commendTextColor2 = Color(0xFF5C79D9);

  static const Color appTheme = Color(0xFF5C79D9);
  static Color getBackgroundColor(bool isDark) {
    return isDark ? const Color(0xFF1F1F1F) : Colors.white;
  }

  static Color getFontPrimary(bool isDark) {
    return isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  }

  static Color getFontSecondary(bool isDark) {
    return isDark ? const Color(0x99FFFFFF) : const Color(0x99000000);
  }

  static const String giveLikeDarkImage =
      'packages/module_flutter_feedcomment/assets/give_like_dark.svg';
  static const String giveLikeImage =
      'packages/module_flutter_feedcomment/assets/give_like.svg';
  static const String iconDefaultImage =
      'packages/module_flutter_feedcomment/assets/icon_default.webp';
  static const String giveLikeActiveImage =
      'packages/module_flutter_feedcomment/assets/give_like_active.svg';
  static const String commentLikeActiveDarkImage =
      'packages/module_flutter_feedcomment/assets/comment_like_active_dark.svg';
  static const String commentLikeActiveImage =
      'packages/module_flutter_feedcomment/assets/comment_like_active.svg';
  static const String messageActiveImage =
      'packages/module_flutter_feedcomment/assets/message_active.svg';
  static const String commentLikeImage =
      'packages/module_flutter_feedcomment/assets/comment_like.svg';
  static const String shareActiveImage =
      'packages/module_flutter_feedcomment/assets/share_active.svg';
  static const String publishImage =
      'packages/module_flutter_feedcomment/assets/publish.svg';
}
