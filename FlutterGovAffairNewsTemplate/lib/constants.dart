import 'package:flutter/material.dart';

// todo 常量文件，可自定义
class AppConstants {
  static const String appTitle = "新闻头条";

  static const List<String> navItems = ['首页', '帮办', '问政'];

  static const List<String> helpTodoTabs = ['全部线索'];

  // 路由常量
  static const String searchRoute = '/search';
  static const String selectDepartmentRoute = '/select_department';
  static const String recommendedAccountsRoute = '/recommended_accounts';

  // 颜色常量
  static const Color backgroundColor = Color(0xFFEEEEEE); //grey200

  // 文字样式常量
  static const TextStyle defaultTextStyle =
      TextStyle(color: Colors.black87, fontSize: 16);

  static const TextStyle headlineTextStyle =
      TextStyle(color: Colors.black87, fontSize: 18);

  static const TextStyle accountTextStyle =
      TextStyle(color: Colors.grey, fontSize: 16);

  static const TextStyle commentTextStyle =
      TextStyle(color: Colors.black87, fontSize: 15);
}
