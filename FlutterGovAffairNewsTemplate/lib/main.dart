import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'constants.dart';
import 'pages/others/search_page.dart';
import 'pages/others/select_department_page.dart';
import 'pages/others/recommended_accounts_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
      // 全局路由
      routes: {
        AppConstants.searchRoute: (context) => const SearchPage(),
        AppConstants.selectDepartmentRoute: (context) =>
            const SelectDepartmentPage(),
        AppConstants.recommendedAccountsRoute: (context) =>
            const RecommendedAccountsPage(),
      },
      // 404页面处理
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('页面未找到')),
            body: const Center(child: Text('您访问的页面不存在')),
          ),
        );
      },
    );
  }
}
