import 'package:flutter/material.dart';

class Constants {
  // 间距常量
  static const double SPACE_2 = 2.0;
  static const double SPACE_2_5 = 2.5;
  static const double SPACE_4 = 4.0;
  static const double SPACE_8 = 8.0;
  static const double SPACE_12 = 12.0;
  static const double SPACE_14 = 14.0;
  static const double SPACE_16 = 16.0;
  static const double SPACE_20 = 20.0;
  static const double SPACE_22 = 22.0;
  static const double SPACE_28 = 28.0;
  static const double SPACE_32 = 32.0;
  static const double SPACE_35 = 35.0;
  static const double SPACE_40 = 40.0;
  static const double SPACE_42 = 42.0;
  static const double SPACE_48 = 48.0;
  static const double SPACE_72 = 72.0;
  static const double SPACE_200 = 200.0;

  // 字体大小常量
  static const double FONT_10 = 10.0;
  static const double FONT_12 = 12.0;
  static const double FONT_14 = 14.0;
  static const double FONT_16 = 16.0;
  static const double FONT_20 = 20.0;

  // 颜色常量
  static const Color COLOR_PRIMARY = Color.fromARGB(255, 92, 121, 216);
  static const Color COLOR_BACKGROUND = Colors.white;
  static const Color COLOR_TEXT_PRIMARY = Colors.black;
  static const Color COLOR_TEXT_SECONDARY = Colors.grey;
  static const Color COLOR_SHADOW = Color(0xE5E5E5E5);
  static const Color DARK_BACKGROUND_COLOR = Color(0xFF2E2E2E);
  static const Color BACKGROUND_COLOR = Color(0xFFF5F5F5);
  static const Color COMP_BACKGROUND_COLOR = Color(0xFF3A3A3A);
  static const Color WHITE_COLOR = Color(0xFFFFFFFF);
  static const Color TEXT_DARK_COLOR = Color(0x99FFFFFF);
  static const Color TEXT_COLOR = Color(0x99000000);
  static const Color SLIDER_TEXT_COLOR = Color(0xFF999999);
  static const Color ACTIVE_TRACK_COLOR = Color(0xFF5C79D9);
  static const Color ACTIVE_TRACK_SELECT_COLOR = Color(0xFFE5E5E5);
  static const Color INACTIVE_TRACK_COLOR = Color(0xFFE5E5E5);
  static const Color FONT_BUTTON_DARK_COLOR = Color(0xFF2C2C2C);
  static const Color FONT_BUTTON_COLOR = Color(0xFFE6E8E9);
  static const Color FONT_PRESSED_BUTTON_DARK_COLOR = Color(0xFF3A3A3A);
  static const Color FONT_PRESSED_BUTTON_COLOR = Color(0xFFD1D3D4);
  static const Color FONT_BOTTOM_DARK_COLOR = Color(0x33000000);
  static const Color FONT_BOTTOM_COLOR = Color(0xFFE5E5E5);

  // 文本内容常量
  static const String NEWS_TITLE = '住建部称住宅层高标准将提至不低于3米，层高低的房子不值钱了？';
  static const String NEWS_SOURCE = '央视新闻  2小时前';
  static const String AUTHOR_NAME = '新闻客户端';
  static const String PUBLISH_TIME = '2025-05-04 12:30';
  static const String NEWS_CONTENT =
      '"竞高品质住宅建设方案"是北京今年首批集中供地提出的竞拍规则之一。30个开拍地块中，有8个因触及"竞地价+竞公共租赁住房面积"或"竞地价+竞政府持有商品住宅产权份额"等上限后转入"竞高标准商品住宅建设方案"环节，最终，通过评选组评分确定了8宗商品住宅用地竞得人。';

  // 按钮文本常量
  static const String FOLLOW_BUTTON_TEXT = '关注';
  static const String CONFIRM_BUTTON_TEXT = '确定';

  // 图片路径常量
  static const String sampleListImage = 'packages/business_setting/assets/sample_list.png';
  static const String sampleUserIconImage = 'packages/business_setting/assets/sample_user_icon.png';
  static const String sampleDetailImage = 'packages/business_setting/assets/sample_detail.png';
}

// 按钮项数据模型
class ButtonItem {
  final String id;
  final String label;

  const ButtonItem({required this.id, required this.label});
}


// 字体大小枚举
enum FontSizeEnum {
  small(0.85),
  normal(1.0),
  large(1.15),
  xl(1.45);

  final double value;
  const FontSizeEnum(this.value);
}

// 字体大小项数据模型
class FontSizeItem {
  final int id;
  final FontSizeEnum value;
  final String label;

  const FontSizeItem({
    required this.id,
    required this.value,
    required this.label,
  });
}

