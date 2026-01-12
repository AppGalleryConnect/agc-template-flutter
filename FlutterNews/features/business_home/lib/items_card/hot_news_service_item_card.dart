import 'package:flutter/material.dart';
import 'package:lib_news_api/params/response/layout_response.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import '../commons/constants.dart';
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
  int _selectedTabIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 229, 231, 234),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(
        left: Constants.spacingM,
        right: Constants.spacingM,
      ),
      padding: const EdgeInsets.all(8),
      child: _buildNewsListView(
        newsModel: widget.news,
        itemBuilder: (context, index) => _buildCardContent(
          widget.news.articles[index],
          index,
        ),
      ),
    );
  }

  Widget _buildNewsListView({
    required RequestListData newsModel,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: newsModel.articles.length,
      itemBuilder: (context, index) {
        final item = newsModel.articles[index];
        return GestureDetector(
          onTap: () => widget.onTap.call(item),
          child: itemBuilder(context, index),
        );
      },
    );
  }

  Widget _buildCardContent(NewsResponse item, int index) {
    if (widget.showTabBar && index == 0) {
      return Column(
        children: [
          HotNewsServiceCard(
            cardData: item,
            navInfo: widget.news.navInfo,
            cardIndex: index,
            selectedTabIndex: _selectedTabIndex,
            onTabTap: (selectedIndex) {
              setState(() => _selectedTabIndex = selectedIndex);
              _buildNewsListView(
                newsModel: widget.news,
                itemBuilder: (context, selectedIndex) => _buildCardContent(
                    widget.news.articles[selectedIndex], selectedIndex),
              );
            },
          ),
          _buildNewsItem(item, index),
        ],
      );
    }

    return _buildNewsItem(item, index);
  }

  Widget _buildNewsItem(NewsResponse item, int index) {
    final displayIndex = widget.showTabBar ? index : index;
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${displayIndex + 1}.',
            style: TextStyle(
              color: displayIndex <= 2 ? Colors.red : Colors.black,
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
}
