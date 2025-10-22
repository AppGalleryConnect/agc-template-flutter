import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/bar/custom_app_bar.dart';
import '../models/task_model.dart';
import '../data/mock_data.dart';
import '../widgets/cards/assistant_item_card.dart';

// 帮办
class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage>
    with SingleTickerProviderStateMixin {
  List<TaskModel> _todoItems = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppConstants.helpTodoTabs.length,
      vsync: this,
    );
    _todoItems = MockData.assistantItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: const CustomAppBar(title: "帮办"),
      body: Stack(
        children: [
          // 主要内容
          Column(
            children: [
              // 顶部图片
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 240, // 固定最大高度
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/information.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 滑动标签栏
              Container(
                alignment: Alignment.centerLeft,
                color: AppConstants.backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3.0, color: Colors.red),
                  ),
                  dividerColor: Colors.transparent,
                  labelPadding: const EdgeInsets.only(right: 20),
                  labelStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16.0,
                  ),
                  tabAlignment: TabAlignment.start,
                  tabs: AppConstants.helpTodoTabs
                      .map((tab) => Tab(text: tab))
                      .toList(),
                ),
              ),

              // 滚动列表
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: AppConstants.helpTodoTabs.map((tab) {
                    return ListView.builder(
                      itemCount: _todoItems.length,
                      itemBuilder: (context, index) {
                        return AssistantItemCard(
                          item: _todoItems[index],
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          // 浮动按钮（在帮办页面内部实现）
          Positioned(
            bottom: 70, // 位于底部导航栏上方
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                // 处理发布功能
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('发布新内容'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: Colors.white, size: 20),
                  SizedBox(height: 4), // 图标和文字之间的间距
                  Text(
                    '报料',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
