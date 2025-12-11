// 常量定义
import 'package:flutter/material.dart';

class Constants {
  static const int MAX_IMG_COUNT = 5;
  static const String PHONE_REG = r'^1[3-9]\d{9}$';

  static const double SPACE_0 = 0.0;
  static const double SPACE_1 = 1.0;
  static const double SPACE_2 = 2.0;
  static const double SPACE_4 = 4.0;
  static const double SPACE_8 = 8.0;
  static const double SPACE_10 = 10.0;
  static const double SPACE_12 = 12.0;
  static const double SPACE_15 = 15.0;
  static const double SPACE_16 = 16.0;
  static const double SPACE_20 = 20.0;
  static const double SPACE_24 = 24.0;
  static const double SPACE_28 = 28.0;
  static const double SPACE_30 = 30.0;
  static const double SPACE_40 = 40.0;
  static const double SPACE_48 = 48.0;
  static const double SPACE_100 = 100.0;
  static const double SPACE_200 = 200.0;

  static const double FONT_12 = 12.0;
  static const double FONT_13 = 13.0;
  static const double FONT_14 = 14.0;
  static const double FONT_16 = 16.0;
  static const double FONT_18 = 18.0;
  static const double FONT_20 = 20.0;
  static const double FONT_24 = 24.0;

  static const Color BACKGROUND_COLOR = Color.fromARGB(255, 92, 121, 217);
  static const Color UPLOAD_COLOR = Color.fromARGB(255, 243, 243, 243);

  static const String emptyImage = 'packages/module_feedback/assets/empty.png';
}

// 路由映射
enum RouterMap {
  FEEDBACK_MANAGE_PAGE,
  FEEDBACK_SUBMIT_PAGE,
  FEEDBACK_RECORD_LIST_PAGE
}

// 设置项接口
class ISettingItem {
  final String label;
  final RouterMap? routerName;

  ISettingItem({
    required this.label,
    this.routerName,
  });
}

// 反馈功能菜单列表
final List<ISettingItem> LIST_INFO = [
  ISettingItem(
    label: '反馈问题',
    routerName: RouterMap.FEEDBACK_SUBMIT_PAGE,
  ),
  ISettingItem(
    label: '反馈记录',
    routerName: RouterMap.FEEDBACK_RECORD_LIST_PAGE,
  ),
];
