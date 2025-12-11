/// 设置项标签枚举，用于唯一标识
enum SettingItemTag {
  notification,
  darkMode,
}

/// 字体大小枚举
enum FontSizeEnum {
  small(0.85),
  normal(1.0),
  large(1.15),
  xl(1.45);

  const FontSizeEnum(this.value);
  final double value;
}

/// 字体大小项
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

/// 按钮项
class ButtonItem {
  final String id;
  final String label;

  const ButtonItem({
    required this.id,
    required this.label,
  });
}

/// 选择选项接口
class ISelectOption {
  final int id;
  final String label;

  ISelectOption({
    required this.id,
    required this.label,
  });
}

/// 设置项接口
class ISettingItem {
  final String? icon;
  final String label;
  final String? subLabel;
  final String? routerName;
  final Map<String, dynamic>? routerParams;
  final bool? typeSwitch;
  final bool? typeSelect;
  final bool? switchV;
  final int? selectV;
  final List<ISelectOption>? selectOptions;
  final String? selectTitle;
  final String? extraLabel;
  final Function(dynamic)? onClick;
  final Function(dynamic)? onSelect;

  ISettingItem({
    this.icon,
    required this.label,
    this.subLabel,
    this.routerName,
    this.routerParams,
    this.typeSwitch,
    this.typeSelect,
    this.switchV,
    this.selectV,
    this.selectOptions,
    this.selectTitle,
    this.extraLabel,
    this.onClick,
    this.onSelect,
  });
}

/// 设置ListItem类型
class SettingItem {
  String? icon;
  String label;
  String? subLabel;
  String? routerName;
  Map<String, dynamic>? routerParams;
  bool? typeSwitch;
  bool? typeSelect;
  bool? switchV;
  int? selectV;
  List<ISelectOption>? selectOptions;
  String? selectTitle;
  String? extraLabel;
  SettingItemTag? tag;
  Function(dynamic)? onClick;
  Function(dynamic)? onSelect;

  SettingItem({
    this.icon,
    required this.label,
    this.subLabel,
    this.routerName,
    this.routerParams,
    this.typeSwitch,
    this.typeSelect,
    this.switchV,
    this.selectV,
    this.selectOptions,
    this.selectTitle,
    this.extraLabel,
    this.tag,
    this.onClick,
    this.onSelect,
  });

  /// 从ISettingItem创建
  factory SettingItem.fromInterface(ISettingItem item) {
    return SettingItem(
      icon: item.icon,
      label: item.label,
      subLabel: item.subLabel,
      routerName: item.routerName,
      routerParams: item.routerParams,
      typeSwitch: item.typeSwitch,
      typeSelect: item.typeSelect,
      switchV: item.switchV,
      selectV: item.selectV,
      selectOptions: item.selectOptions,
      selectTitle: item.selectTitle,
      extraLabel: item.extraLabel,
      onClick: item.onClick,
      onSelect: item.onSelect,
    );
  }
}
