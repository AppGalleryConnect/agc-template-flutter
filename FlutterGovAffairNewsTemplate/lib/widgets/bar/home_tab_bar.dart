import 'package:flutter/material.dart';
import '../custom_tab_indicator.dart';

class HomeTabBar extends StatelessWidget {
  final TabController tabController;

  const HomeTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: TabBar(
        controller: tabController,
        indicator:
            const CustomTabIndicator(width: 30, color: Colors.red, height: 3),
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87),
        unselectedLabelStyle:
            const TextStyle(color: Colors.black87, fontSize: 16.0),
        tabs: const [
          Tab(text: '推荐'),
          Tab(text: '专栏'),
          Tab(text: '政务号'),
          Tab(text: '专题'),
        ],
      ),
    );
  }
}
