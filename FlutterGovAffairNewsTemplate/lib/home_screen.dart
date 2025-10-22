import 'package:flutter/material.dart';
import 'constants.dart';
import 'pages/home_page.dart';
import 'pages/assistant_page.dart';
import 'pages/question_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // 默认选中页
  final List<Widget> _pages = [
    const HomePage(),
    const AssistantPage(),
    const AskGovQuestionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: AppConstants.navItems.map((item) {
          return BottomNavigationBarItem(
            icon: _getIcon(item),
            label: item,
          );
        }).toList(),
      ),
    );
  }

  // 获取导航栏图标
  Icon _getIcon(String item) {
    switch (item) {
      case '首页':
        return const Icon(Icons.home);
      case '帮办':
        return const Icon(Icons.add_task);
      case '问政':
        return const Icon(Icons.quickreply);
      default:
        return const Icon(Icons.circle);
    }
  }
}
