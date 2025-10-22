import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_constants.dart';
import 'widgets/news_item.dart';
import 'widgets/topic_intro.dart';
import 'widgets/section_indicator.dart';
import 'widgets/section_title.dart';
import 'widgets/more_button.dart';
import 'models/news_model.dart';
import 'services/news_service.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  NewsListScreenState createState() => NewsListScreenState();
}

class NewsListScreenState extends State<NewsListScreen> {
  final ScrollController _scrollController = ScrollController();
  String _activeSection = '热门新闻';
  bool _isStickyVisible = false;
  List<NewsSection> _sections = [];
  Map<String, int> _loadedCounts = {}; // 记录每个分区已加载的新闻数量
  final GlobalKey _stickyHeaderKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_handleScroll);
  }

  void _loadInitialData() {
    final newsService = NewsService();
    _sections = newsService.fetchNewsSections();
    // 初始化已加载数量
    _loadedCounts = {
      for (var section in _sections) section.title: section.items.length
    };
  }

  Future<List<NewsItem>> _fetchMoreNews(String sectionTitle, int limit) async {
    final newsService = NewsService();
    return newsService.fetchMoreNews(sectionTitle, limit);
  }

  void _handleScroll() {
    final scrollOffset = _scrollController.offset;
    bool shouldStick = false;
    String? newActiveSection;

    // 1. 检查是否应该显示吸附头
    if (scrollOffset > AppConstants.kTopicIntroHeight) {
      shouldStick = true;
    }

    // 2. 计算当前活动分区
    double accumulatedHeight = AppConstants.kTopicIntroHeight;

    for (var section in _sections) {
      // 分区标题高度 + 所有新闻项高度 + (“查看更多”组件高度)
      final sectionHeight = AppConstants.kSectionTitleHeight +
          section.items.length * AppConstants.kNewsItemHeight +
          (section.showMore ? AppConstants.kMoreButtonHeight : 0);

      // 当滚动位置进入分区范围
      if (scrollOffset >= accumulatedHeight &&
          scrollOffset < accumulatedHeight + sectionHeight) {
        newActiveSection = section.title;
        break;
      }

      accumulatedHeight += sectionHeight;
    }

    // 更新吸附状态
    if (shouldStick != _isStickyVisible || newActiveSection != _activeSection) {
      setState(() {
        _isStickyVisible = shouldStick;
        if (newActiveSection != null) {
          _activeSection = newActiveSection;
        }
      });
    }
  }

  void _loadSectionData(String sectionTitle) {
    // 找到对应的分区
    final targetSection =
        _sections.firstWhere((section) => section.title == sectionTitle);

    // 计算目标分区的起始偏移量
    double offset = AppConstants.kTopicIntroHeight; // 专题介绍高度
    for (var section in _sections) {
      if (section.title == targetSection.title) {
        break;
      }
      // 累加前面分区的高度 = 分区标题高度 + 新闻项总高度 + (“查看更多”横条高度)
      offset += AppConstants.kSectionTitleHeight +
          section.items.length * AppConstants.kNewsItemHeight +
          (section.showMore ? AppConstants.kMoreButtonHeight : 0);
    }

    // 平滑滚动到目标位置
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('专题名称'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => SystemNavigator.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            children: [
              // 1. 专题介绍板块
              const TopicIntroWidget(),

              // 2. 分区头组件 - 始终存在（位于专题介绍和分区新闻之间）
              Container(
                key: _stickyHeaderKey,
                height: AppConstants.kStickyHeaderHeight,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionIndicator(),
              ),

              // 3. 分区内容
              ..._buildSectionList(),
            ],
          ),

          // 4. 吸附版本的分区头 - 当滚动时显示在顶部
          if (_isStickyVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: AppConstants.kStickyHeaderHeight,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  // 构建分区指示器
  Widget _buildSectionIndicator() {
    return Row(
      children: [
        Expanded(
          child: SectionIndicator(
            activeSection: _activeSection,
            onSectionChanged: _loadSectionData,
          ),
        ),
      ],
    );
  }

  // 构建分区列表
  List<Widget> _buildSectionList() {
    List<Widget> widgets = [];

    for (var section in _sections) {
      // 分区标题
      widgets.add(
        SectionTitle(
          title: section.title,
        ),
      );

      // 分区新闻项
      for (var item in section.items) {
        widgets.add(NewsItemWidget(news: item));
      }

      // “查看更多”横条
      if (section.showMore) {
        widgets.add(
          MoreButton(
            sectionTitle: section.title,
            onPressed: () async {
              final moreItems = await _fetchMoreNews(
                  section.title, AppConstants.kShowMoreLimit);
              setState(() {
                var sectionIndex =
                    _sections.indexWhere((s) => s.title == section.title);
                if (sectionIndex != -1) {
                  _sections[sectionIndex] = NewsSection(
                    section.title,
                    [..._sections[sectionIndex].items, ...moreItems],
                    showMore: false, // 点击后隐藏“查看更多”横条
                    limit: section.limit,
                  );
                }
                _loadedCounts[section.title] =
                    _loadedCounts[section.title]! + moreItems.length;
              });
            },
          ),
        );
      }
    }

    return widgets;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
