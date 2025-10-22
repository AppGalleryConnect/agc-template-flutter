import 'package:flutter/material.dart';
import '../widgets/bar/home_app_bar.dart';
import '../widgets/bar/home_tab_bar.dart';
import '../widgets/list/news_list.dart';
import '../widgets/recommended_section.dart';
import '../data/mock_data.dart';
import '../constants.dart';

// 首页
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, initialIndex: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: const HomeAppBar(),
      body: Column(
        children: [
          HomeTabBar(tabController: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPlaceholderTab("推荐页面"),
                _buildPlaceholderTab("专栏页面"),
                _buildOfficialAccountTab(),
                _buildPlaceholderTab("专题页面"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialAccountTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 上半部分：新闻列表
          NewsList(
            posts: MockData.postItems.sublist(0, 3),
            onFollowChanged: (accountId, isFollowed) {
              // 可以在这里处理关注状态变化
              // 例如更新数据库或发送网络请求
            },
          ),
          // 下半部分：推荐关注
          RecommendedSection(
            onMorePressed: () {
              Navigator.pushNamed(
                  context, AppConstants.recommendedAccountsRoute);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String text) {
    return Center(
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}
