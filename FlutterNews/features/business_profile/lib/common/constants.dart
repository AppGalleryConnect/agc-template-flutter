import 'package:flutter/material.dart';

class Constants {
  static const double userIconWidth = 48;
  static const double mediumIconWidth = 48;
  static const double smallBtnWidth = 72;
  static const double smallBtnHeight = 28;
  static const double likeShowWidth = 156;
  static const double likeImageWidth = 100;
  static const double likeImageHeight = 100;
  static const double authorNameFontSize = 18;
  static const double textFontSize = 16;
  static const double dialogBorderRadius = 30;
  static const double buttonBorderRadius = 20;
  static const Color LIKE_BUTTON_COLOR = Color.fromARGB(255, 92, 121, 216);
  static const Color WATCH_BUTTON_PRIMARY_COLOR =
      Color.fromARGB(255, 92, 121, 217);
  static const Color WATCH_BUTTON_SECONDARY_COLOR =
      Color.fromARGB(255, 229, 231, 232);
  static const Color WATCH_BUTTON_TEXT_PRIMARY_COLOR = Colors.white;
  static const Color WATCH_BUTTON_TEXT_SECONDARY_COLOR =
      Color.fromARGB(221, 92, 121, 216);
  static const Color PAGE_BACKGROUND_COLOR = Color.fromARGB(255, 230, 235, 253);
  static const Color BACK_BUTTON_BACKGROUND_COLOR =
      Color.fromARGB(255, 219, 224, 241);
  static const Color BACK_BUTTON_PRESSED_COLOR = Color(0xFFE0E0E0);
  static const Color PRIMARY_TEXT_COLOR = Color(0xFF333333);
  static const Color SECONDARY_TEXT_COLOR = Color(0xFF999999);
  static const Color LINK_TEXT_COLOR = Color(0xFF5C79D9);
  static const Color VIDEO_PLAY_BUTTON_BACKGROUND_COLOR = Colors.black54;
  static const double WATCH_BUTTON_PADDING_HORIZONTAL = 16;
  static const double WATCH_BUTTON_PADDING_VERTICAL = 8;
  static const double WATCH_BUTTON_MIN_WIDTH = 85;
  static const double WATCH_BUTTON_MIN_HEIGHT = 30;
  static const double WATCH_BUTTON_BORDER_RADIUS = 20;
  static const double WATCH_BUTTON_FONT_SIZE = 14;
  static const double LOADING_INDICATOR_SIZE = 16;
  static const double LOADING_INDICATOR_STROKE_WIDTH = 2;
  static const int LOADING_DELAY_MILLISECONDS = 300;
  static const double APP_BAR_TITLE_VISIBLE_OFFSET = 50;
  static const double TAB_BAR_STICKY_OFFSET = 150;
  static const double LEFT_PADDING = 5;
  static const double MESSAGE_BUTTON_SIZE = 40;
  static const double MESSAGE_ICON_SIZE = 20;
  static const double CONTENT_BORDER_RADIUS = 30;
  static const double MIN_CONTENT_HEIGHT = 700;
  static const double TAB_BUTTON_PADDING_HORIZONTAL = 16;
  static const double TAB_BUTTON_PADDING_VERTICAL = 8;
  static const double SELECTED_FONT_SIZE = 18;
  static const double UNSELECTED_FONT_SIZE = 16;
  static const double TAB_INDICATOR_WIDTH = 20;
  static const double TAB_INDICATOR_HEIGHT = 3;
  static const double TAB_INDICATOR_BORDER_RADIUS = 1.5;
  static const double TAB_INDICATOR_MARGIN_TOP = 4;
  static const double EMPTY_CONTENT_PADDING = 40;
  static const double TAB_BAR_HEIGHT = 56.0;
  static const double TAB_BAR_SHADOW_BLUR_RADIUS = 4;
  static const double CONTENT_SHADOW_BLUR_RADIUS = 8;
  static const double IMAGE_BORDER_RADIUS_SMALL = 4;
  static const double IMAGE_BORDER_RADIUS_MEDIUM = 8;
  static const double VIDEO_PLAY_BUTTON_SIZE_LARGE = 48;
  static const double VIDEO_PLAY_BUTTON_SIZE_SMALL = 28;
  static const double VIDEO_PLAY_ICON_SIZE_LARGE = 32;
  static const double VIDEO_PLAY_ICON_SIZE_SMALL = 20;
  static const double IMAGE_GRID_SPACING = 4;
  static const int MAX_DISPLAY_IMAGES = 9;
  static const double GRID_CROSS_AXIS_COUNT_2 = 2;
  static const double GRID_CROSS_AXIS_COUNT_3 = 3;
  static const double IMAGE_GRID_CONTAINER_PADDING = 32;
  static const int MAX_TEXT_LINES = 3;
  static const double TEXT_HEIGHT_FACTOR = 1.5;
  static const double EXPAND_BUTTON_PADDING_TOP = 8;
  static const double EXPAND_BUTTON_FONT_SIZE = 14;
  static const double IMAGE_WIDTH_LARGE = 327;
  static const double IMAGE_WIDTH_MEDIUM = 280;
  static const double IMAGE_WIDTH_SMALL = 220;
  static const double IMAGE_HEIGHT_VERTICAL = 280;
  static const double IMAGE_HEIGHT_HORIZONTAL = 200;
  static const double IMAGE_HEIGHT_VIDEO = 330;
  static const double IMAGE_ASPECT_RATIO_SQUARE = 1.0;
  static const double IMAGE_ASPECT_RATIO_LANDSCAPE = 1.5;
  static const double IMAGE_ASPECT_RATIO_PORTRAIT = 0.6667;
  static const String LIKE_ICON_PATH =
      'packages/business_profile/assets/ic_like_show.png';
  static const String VIDEO_PLAY_ICON_PATH = 'assets/ic_public_video_play.svg';
  static const String BRUSH_ICON_PATH = 'assets/ic_public_brush.svg';
  static const double videoPlayIconSize = 20;
  static const double brushIconSize = 20;
  static const String PROFILE_HOME_PATH = '/profile_home';
  // 用户简介相关常量
  static const String DEFAULT_USER_ICON_PATH = 'packages/business_interaction/assets/ic_user_default.png';
  static const double INTRO_TEXT_FONT_SIZE = 12;
  static const String DEFAULT_AUTHOR_DESC = '这家伙很神秘，没有写个人简介。';
  static const double ERROR_ICON_SIZE = 20;
}

class TabItem {
  final int id;
  final String label;
  const TabItem({
    required this.id,
    required this.label,
  });
}

enum TabEnum {
  article,
  video,
  post,
}

const List<TabItem> tabList = [
  TabItem(id: 0, label: '文章'),
  TabItem(id: 1, label: '视频'),
  TabItem(id: 2, label: '动态'),
];
