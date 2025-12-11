import 'package:flutter/material.dart';

/// 应用程序常量类
class AppConstants {
  static const List<String> tabTitles = ['首页', '视频', '互动', '我的'];

  static const List<String> tabIconPaths = [
    'assets/ic_tab_home.svg',
    'assets/ic_tab_video.svg',
    'assets/ic_tab_interaction.svg',
    'assets/ic_tab_mine.svg'
  ];

  static const double tabIconSize = 24.0;

  static const double SPACE_0 = 0.0;
  static const double SPACE_1_31 = 1.31;
  static const double SPACE_1_6 = 1.6;
  static const double SPACE_20 = 20.0;
  static const double SPACE_116 = 116.0;
  static const double SPACE_258 = 258.0;

  static const double FONT_12 = 12.0;
  static const double FONT_16 = 16.0;
  static const double FONT_20 = 20.0;

  static const Color tabSelectedColor = Color.fromARGB(255, 109, 135, 221);
  static const Color textColor = Color.fromARGB(255, 92, 121, 217);
  static const Color tabUnselectedColor = Colors.grey;
  static const Color scaffoldBackgroundColor = Color(0xFF1F1F1F);
  static const Color systemNavigationBarDarkColor = Color(0xFF000000);
  static const Color systemNavigationBarColor = Color(0xFFFFFFFF);
  static const Color unselectedItemColor = Color(0x99000000);
  static const Color unselectedItemDarkColor = Color(0x99FFFFFF);
  static const Color unselectedItemVideoColor = Color(0xCCCCCCCC);

  static const String icStartBackgroundImage = 'assets/ic_start_background.png';
  static const String startIconImage = 'assets/startIcon.png';  
}
