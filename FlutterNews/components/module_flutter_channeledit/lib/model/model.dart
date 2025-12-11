// 1. 类型定义转换
class TabInfo {
  String id;
  String text;
  bool selected;
  int order;
  bool? disabled;
  Visibility? visibility;

  TabInfo({
    required this.id,
    required this.text,
    required this.selected,
    required this.order,
    this.disabled = false,
    this.visibility = Visibility.visible,
  });
}

enum Visibility { visible, hidden, none }
