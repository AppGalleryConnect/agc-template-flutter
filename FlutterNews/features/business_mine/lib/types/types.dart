import 'package:flutter/material.dart';

/// MineGridItem接口定义
abstract class MineGridItem {
  String get icon;
  String get label;
  String get routerName;
}

enum MineMsgMenuType {
  Comment(1),
  IM(2),
  Fan(3),
  System(4);

  final int value;
  const MineMsgMenuType(this.value);
}

abstract class IMineMsgMenuItem {
  MineMsgMenuType get type;
  String get menuIcon;
  String get menuTitle;
  String get routerName;
}

class MineMsgMenuItem implements IMineMsgMenuItem {
  @override
  final MineMsgMenuType type;
  @override
  final String menuIcon;
  @override
  final String menuTitle;
  @override
  final String routerName;
  // 将final改为普通属性
  VoidCallback? routerOnPop;
  // 将以下属性从final改为普通属性
  String latestNews;
  int allUnreadCount;
  int receiveTime;

  MineMsgMenuItem({
    required this.type,
    required this.menuIcon,
    required this.menuTitle,
    required this.routerName,
    this.routerOnPop,
    this.latestNews = '',
    this.allUnreadCount = 0,
    this.receiveTime = 0,
  });

  factory MineMsgMenuItem.fromIMineMsgMenuItem(IMineMsgMenuItem item) {
    return MineMsgMenuItem(
      type: item.type,
      menuIcon: item.menuIcon,
      menuTitle: item.menuTitle,
      routerName: item.routerName,
    );
  }

  // 添加 fromJson 工厂方法
  factory MineMsgMenuItem.fromJson(Map<String, dynamic> json) {
    // 将整数值转换为 MineMsgMenuType 枚举
    MineMsgMenuType type = MineMsgMenuType.System; // 默认值
    if (json['type'] != null) {
      switch (json['type'] as int) {
        case 1:
          type = MineMsgMenuType.Comment;
          break;
        case 2:
          type = MineMsgMenuType.IM;
          break;
        case 3:
          type = MineMsgMenuType.Fan;
          break;
        case 4:
          type = MineMsgMenuType.System;
          break;
      }
    }

    return MineMsgMenuItem(
      type: type,
      menuIcon: json['menuIcon'] as String? ?? '',
      menuTitle: json['menuTitle'] as String? ?? '',
      routerName: json['routerName'] as String? ?? '',
      latestNews: json['latestNews'] as String? ?? '',
      allUnreadCount: json['allUnreadCount'] as int? ?? 0,
      receiveTime: json['receiveTime'] as int? ?? 0,
    );
  }
}
