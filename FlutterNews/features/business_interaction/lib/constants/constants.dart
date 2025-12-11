import 'dart:ui';

/// 常量类，用于定义应用中使用的各种固定数值
class Constants {
  /// 包名 - 用于资源引用
  static const String packageName = 'business_interaction';

  static const double SPACE_0 = 0.0;
  static const double SPACE_0_5 = 0.5;
  static const double SPACE_1 = 1.0;
  static const double SPACE_1_5 = 1.5;
  static const double SPACE_2 = 2.0;
  static const double SPACE_3 = 3.0;
  static const double SPACE_4 = 4.0;
  static const double SPACE_5 = 5.0;
  static const double SPACE_6 = 6.0;
  static const double SPACE_8 = 8.0;
  static const double SPACE_9 = 9.0;
  static const double SPACE_10 = 10.0;
  static const double SPACE_12 = 12.0;
  static const double SPACE_14 = 14.0;
  static const double SPACE_15 = 15.0;
  static const double SPACE_16 = 16.0;
  static const double SPACE_18 = 18.0;
  static const double SPACE_20 = 20.0;
  static const double SPACE_22 = 22.0;
  static const double SPACE_24 = 24.0;
  static const double SPACE_25 = 25.0;
  static const double SPACE_30 = 30.0;
  static const double SPACE_32 = 32.0;
  static const double SPACE_36 = 36.0;
  static const double SPACE_40 = 40.0;
  static const double SPACE_41 = 41.0;
  static const double SPACE_44 = 44.0;
  static const double SPACE_45 = 45.0;
  static const double SPACE_48 = 48.0;
  static const double SPACE_50 = 50.0;
  static const double SPACE_55 = 55.0;
  static const double SPACE_56 = 56.0;
  static const double SPACE_59 = 59.0;
  static const double SPACE_60 = 60.0;
  static const double SPACE_70 = 70.0;
  static const double SPACE_72 = 72.0;
  static const double SPACE_77 = 77.0;
  static const double SPACE_80 = 80.0;
  static const double SPACE_92 = 92.0;
  static const double SPACE_100 = 100.0;
  static const double SPACE_150 = 150.0;
  static const double SPACE_200 = 200.0;
  static const double SPACE_224 = 224.0;
  static const double SPACE_260 = 260.0;
  static const double SPACE_290 = 290.0;
  static const double SPACE_335 = 335.0;
  static const double SPACE_400 = 400.0;
  static const double SPACE_480 = 480.0;
  static const double SPACE_500 = 500.0;
  static const double SPACE_670 = 670.0;
  
  static const double FONT_10 = 10.0;
  static const double FONT_12 = 12.0;
  static const double FONT_13 = 13.0;
  static const double FONT_14 = 14.0;
  static const double FONT_16 = 16.0;
  static const double FONT_18 = 18.0;
  static const double FONT_20 = 20.0;

  static const Color appThemeColor = Color(0xFF5C79D9);

  static const String noWatchImage = 'assets/no_watch.png';
  static const String noLoginImage = 'packages/business_home/assets/no_login.png';
}

/// 标签页项目类，定义标签页的基本结构
class TabItem {
  /// 标签页的唯一标识符
  final int id;

  /// 标签页显示的文本标签
  final String label;

  const TabItem({
    required this.id,
    required this.label,
  });
}

/// 标签页枚举类型，定义不同的标签页类型
enum TabEnum {
  /// 关注标签页，值为0
  watch(0),

  /// 推荐标签页，值为1
  recommend(1),

  /// 附近标签页，值为2
  nearby(2);

  const TabEnum(this.value);
  final int value;
}

/// 标签页列表常量，包含所有可用的标签页配置
const List<TabItem> TAB_LIST = [
  TabItem(
    id: 0, 
    label: '关注',
  ),
  TabItem(
    id: 1,
    label: '推荐',
  ),
  TabItem(
    id: 2, 
    label: '附近',
  ),
];
