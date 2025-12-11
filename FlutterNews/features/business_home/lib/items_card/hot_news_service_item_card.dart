
import 'package:flutter/material.dart';
import 'package:lib_news_api/params/response/layout_response.dart';
import 'package:lib_news_api/params/response/news_response.dart';

import '../components/hot_news_service_card.dart';

/// 热门新闻HotNewsServiceItemCard
class HotNewsServiceItemCard extends StatefulWidget {
  final RequestListData news;
  final Function(NewsResponse newsInfo) onTap;
  // 控制是否显示标签栏
  final bool showTabBar;
  final double fontSizeRatio;

  const HotNewsServiceItemCard(
      this.news, {
        super.key,
        required this.onTap,
        this.showTabBar = true, // 默认显示标签栏
        this.fontSizeRatio = 1,
      });

  @override
  State<HotNewsServiceItemCard> createState() => _HotNewsServiceItemCardState();
}

class _HotNewsServiceItemCardState extends State<HotNewsServiceItemCard> {
  // 选中的标签索引（仅用于标签切换，与条目序号分离）
  int _selectedTabIndex = 0;
  // late List<NewsResponse> _currentData;
  @override
  void initState() {
    super.initState();
    // 初始化：假设widget.news.articles是按标签分的列表（如[标签0数据, 标签1数据, 标签2数据]）
    // _currentData = widget.news.articles;
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child:  _buildNewsListView(
          newsModel: widget.news, // 传入模型
          itemBuilder: (context, index) => _buildCardContent(
            widget.news.articles[index],
            index // 动态传递当前索引
          ),
      ),
    );
  }
  Widget _buildNewsListView({
    required RequestListData newsModel, // 第一个参数：模型
    required Widget Function(BuildContext, int) itemBuilder, // 第二个参数：带索引的构建回调
  }) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: newsModel.articles.length, // 使用传入模型的长度
      itemBuilder: (context, index) {
        final item = newsModel.articles[index]; // 从传入的模型取数据
        return GestureDetector(
          onTap: () => widget.onTap.call(item),
          child: itemBuilder(context, index), // 通过回调传递索引
        );
      },
    );
  }
  Widget _buildCardContent(NewsResponse item, int index) {
    // 这里通过index == 0控制只显示一次标签栏，同时兼容showTabBar开关
    if (widget.showTabBar && index == 0) {
      return Column(
        children: [
          // 标签栏（仅第一条显示）
          HotNewsServiceCard(
            cardData: item,
            navInfo: widget.news.navInfo,
            cardIndex: index, // 传递原始索引（0）
            selectedTabIndex: _selectedTabIndex,
            onTabTap: (selectedIndex) {
              setState(() => _selectedTabIndex = selectedIndex);
              _buildNewsListView(
                newsModel: widget.news, // 传入模型
                itemBuilder: (context, selectedIndex) => _buildCardContent(
                    widget.news.articles[selectedIndex],
                    selectedIndex // 动态传递当前索引
                ),
              );
            },
          ),
          // 第一条内容（避免标签栏占用内容位置）
          _buildNewsItem(item, index),
        ],
      );
    }

    // 2. 不显示标签栏，或非第一条条目（直接显示内容）
    return _buildNewsItem(item, index);
  }
// 提取通用的新闻条目构建方法（保持原有样式逻辑）
  Widget _buildNewsItem(NewsResponse item, int index) {
    // 计算实际显示的序号（showTabBar为true时，跳过标签栏所在的第一条）
    final displayIndex = widget.showTabBar ? index : index;
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${displayIndex + 1}.',
            style: TextStyle(
              color: displayIndex <= 2 ? Colors.red : Colors.black, // 原颜色逻辑不变
              fontSize: 13.0 * widget.fontSizeRatio,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.0 * widget.fontSizeRatio,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
  /// 可选：根据标签索引刷新数据
  void _refreshDataByTab(int tabIndex) {
    // 根据标签切换请求对应数据的逻辑
  }
}