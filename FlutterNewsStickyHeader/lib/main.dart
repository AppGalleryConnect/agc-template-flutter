import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'news/news_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Colors.white, // 主色（按钮等）
          onPrimary: Colors.white, // 主色上的文字
          surface: Colors.white, // 卡片、弹窗背景
          onSurface: Colors.black, // 卡片文字
        ),
        scaffoldBackgroundColor: Colors.white, // 页面背景
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // 标题/图标颜色
          elevation: 0, // 去掉阴影
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark, // 深色图标
          ),
        ),
      ),
      home: const NewsListScreen(),
    );
  }
}
