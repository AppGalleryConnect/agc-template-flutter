import 'dart:convert';
import 'package:lib_news_api/constants/constants.dart';

/// 根布局模型
class LayoutRoot {
  final String type;
  final NewsCardType? showType;
  final List<ChildrenItem>? children;

  LayoutRoot({
    required this.type,
    this.showType,
    this.children,
  });

  factory LayoutRoot.fromJson(Map<String, dynamic> json) {
    List<ChildrenItem>? children;
    if (json['children'] != null) {
      children = (json['children'] as List<dynamic>)
          .map((childJson) => ChildrenItem.fromJson(childJson))
          .toList();
    }
    final Set<NewsCardType> showTypeSet = <NewsCardType>{}; // 用 Set 自动去重
    if (json['showType'] != null &&
        json['showType'] is String &&
        json['showType'].isNotEmpty) {
      // 使用大小写不敏感的方式将字符串转换为NewsCardType枚举
      final NewsCardType cardType = NewsCardType.values.firstWhere(
          (e) => e.name.toLowerCase() == json['showType'].toLowerCase(),
          orElse: () => NewsCardType.unknown);
      showTypeSet.add(cardType);
    }
    _collectShowTypes(children, showTypeSet);
    return LayoutRoot(
      type: json['type'] ?? '',
      showType: showTypeSet.isNotEmpty ? showTypeSet.toList().first : null,
      children: children,
    );
  }

  static void _collectShowTypes(
      List<ChildrenItem>? children, Set<NewsCardType> resultSet) {
    if (children == null || children.isEmpty) return;
    for (final child in children) {
      if (child.showType != null && child.showType is NewsCardType) {
        resultSet.add(child.showType!);
      }
      _collectShowTypes(child.children, resultSet);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'showType': showType,
      'children': children?.map((child) => child.toJson()).toList(),
    };
  }

  factory LayoutRoot.fromJsonString(String jsonString) {
    try {
      final jsonMap = json.decode(jsonString);
      return LayoutRoot.fromJson(jsonMap);
    } catch (e) {
      throw FormatException('解析 LayoutRoot 失败：$e，原始字符串：$jsonString');
    }
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}

/// 子布局项模型
class ChildrenItem {
  final String type;
  final NewsCardType? showType;
  final String? name;
  final List<ChildrenItem>? children;
  final LayoutStyle? style;

  ChildrenItem({
    required this.type,
    this.showType,
    this.name,
    this.children,
    this.style,
  });

  factory ChildrenItem.fromJson(Map<String, dynamic> json) {
    return ChildrenItem(
      type: json['type'] ?? '',
      showType: json['showType'] != null
          ? NewsCardType.values.firstWhere(
              (e) => e.name.toLowerCase() == json['showType'].toLowerCase(),
              orElse: () => NewsCardType.unknown)
          : null,
      name: json['name'],
      children: json['children'] != null
          ? (json['children'] as List<dynamic>)
              .map((childJson) => ChildrenItem.fromJson(childJson))
              .toList()
          : null,
      style: json['style'] != null ? LayoutStyle.fromJson(json['style']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'showType': showType?.name,
      'name': name,
      'children': children?.map((child) => child.toJson()).toList(),
      'style': style?.toJson(),
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}

/// 样式模型
class LayoutStyle {
  final dynamic backgroundColor;
  final dynamic borderRadius;
  final dynamic paddingTop;
  final dynamic paddingBottom;
  final dynamic paddingLeft;
  final dynamic paddingRight;
  final dynamic space;
  final dynamic marginTop;
  final dynamic marginBottom;
  final dynamic marginLeft;
  final dynamic marginRight;
  final dynamic width;
  final dynamic height;
  final dynamic color;
  final dynamic border;
  final dynamic alignment;
  final Map<String, dynamic>? extraStyles;

  const LayoutStyle({
    this.backgroundColor,
    this.borderRadius,
    this.paddingTop,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
    this.space,
    this.marginTop,
    this.marginBottom,
    this.marginLeft,
    this.marginRight,
    this.width,
    this.height,
    this.color,
    this.border,
    this.alignment,
    this.extraStyles,
  });

  factory LayoutStyle.fromJson(Map<String, dynamic> json) {
    return LayoutStyle(
      backgroundColor: json['backgroundColor'],
      borderRadius: json['border-radius'],
      paddingTop: json['padding-top'],
      paddingBottom: json['padding-bottom'],
      paddingLeft: json['padding-left'],
      paddingRight: json['padding-right'],
      space: json['space'],
      marginTop: json['margin-top'] ?? json['marginTop'],
      marginBottom: json['margin-bottom'] ?? json['marginBottom'],
      marginLeft: json['margin-left'] ?? json['marginLeft'],
      marginRight: json['margin-right'] ?? json['marginRight'],
      width: json['width'],
      height: json['height'],
      color: json['color'],
      border: json['border'],
      alignment: json['alignment'],
      extraStyles: json['extraStyles'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'border-radius': borderRadius,
      'padding-top': paddingTop,
      'padding-bottom': paddingBottom,
      'padding-left': paddingLeft,
      'padding-right': paddingRight,
      'space': space,
      'margin-top': marginTop,
      'margin-bottom': marginBottom,
      'margin-left': marginLeft,
      'margin-right': marginRight,
      'width': width,
      'height': height,
      'color': color,
      'border': border,
      'alignment': alignment,
      ...?extraStyles,
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
