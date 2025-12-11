import 'package:business_home/components/widget_extent.dart';
import 'package:business_home/items_card/vertical_bigImageItem_card.dart';
import 'package:flutter/material.dart';
import 'package:lib_news_api/constants/constants.dart';
import 'package:lib_news_api/params/response/layout_response.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:module_newsfeed/components/news_detail_page.dart';
import '../components/leftText_rightImage_card.dart';
import '../components/topText_bottomImage_card.dart';
import '../components/topText_bottomVideo_card.dart';
import '../components/topText_bottom_bigImage_card.dart';
import '../items_card/hot_news_service_item_card.dart';
import 'feed_detail.dart';

/// 通用列表项
class CustomItemCard extends StatefulWidget {
  final RequestListData news;
  final BuildContext context;
  final Function(NewsResponse newsInfo) onTap;
  final Function(String newsId)? onWatchClick;
  final String? searchKeyword;
  final double fontSizeRatio;
  const CustomItemCard(
    this.context,
    this.news, {
    super.key,
    required this.onTap,
    this.onWatchClick,
    this.searchKeyword,
    this.fontSizeRatio = 1.0,
  });

  @override
  State<CustomItemCard> createState() => _CustomItemCardState();
}

class _CustomItemCardState extends State<CustomItemCard> {
  late NewsCardType _showType;
  late List<NewsResponse> _articles;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant CustomItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.news != widget.news) {
      _initData();
    }
  }

  /// 初始化数据
  void _initData() {
    _showType =
        widget.news.navInfo.parsedSetting?.showType ?? NewsCardType.unknown;
    _articles = widget.news.articles;
  }

  @override
  Widget build(BuildContext context) {
    final showType =
        widget.news.navInfo.parsedSetting?.showType ?? NewsCardType.unknown;
    if (widget.news.articles.isEmpty || showType == NewsCardType.unknown) {
      return Container();
    }
    if (_showType == NewsCardType.hotNewsServiceCard) {
      return HotNewsServiceItemCard(
        showTabBar: false,
        widget.news,
        onTap: widget.onTap,
        fontSizeRatio: widget.fontSizeRatio,
      );
    } else if (_showType == NewsCardType.verticalBigImageCard) {
      return VerticalBigImageItemCard(
        widget.news,
        onTap: widget.onTap,
        fontSizeRatio: widget.fontSizeRatio,
      );
    } else if (_showType == NewsCardType.hotListServiceSwitchCard) {
      return HotNewsServiceItemCard(
        widget.news,
        onTap: widget.onTap,
        fontSizeRatio: widget.fontSizeRatio,
      );
    }

    return _articles.length > 1
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _articles.length,
            itemBuilder: (context, index) {
              final item = _articles[index];
              return _buildCellItemCard(item);
            },
          )
        : _buildCellItemCard(_articles.first);
  }

  Widget _buildCellItemCard(NewsResponse cardData) {
    late Widget item;
    switch (_showType) {
      case NewsCardType.topTextBottomImageCard:
        item = TopTextBottomImageCard(
          cardData,
          onAvthorTap: (userId) => _pushToPeopleCenter(userId),
          onImageClick: (index) {
            _handleImageClick(cardData, index);
          },
          onWatchClick: () => _handleWatchClick(cardData.id),
          fontSizeRatio: widget.fontSizeRatio,
        );
        break;
      case NewsCardType.leftTextRightImageCard:
        item = LeftTextRightImageCard(
          cardData,
          onAuthorTap: (userId) => _pushToPeopleCenter(userId),
          fontSizeRatio: widget.fontSizeRatio,
        );
        break;
      case NewsCardType.topTextBottomBigImageCard:
        item = TopTextBottomBigImageCard(
          cardData,
          onAuthorTap: (userId) => _pushToPeopleCenter(userId),
          fontSizeRatio: widget.fontSizeRatio,
        );
        break;
      case NewsCardType.topTextBottomVideoCard:
        item = TopTextBottomVideoCard(
          cardData,
          onWatchClick: () => _handleWatchClick(cardData.id),
          onAvthorTap: (userId) => _pushToPeopleCenter(userId),
          fontSizeRatio: widget.fontSizeRatio,
        );
        break;
      case NewsCardType.feedDetailsCard:
        item = FeedDetail(
          curFeedCardInfo: cardData,
        );
        break;
      default:
        item = Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.red,
        );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: item,
    ).clickable(
      () => widget.onTap(cardData),
    );
  }

  /// 广告交互监听设置
  void _setupAdInteractionListener() {}

  /// 跳转到个人中心
  void _pushToPeopleCenter(String userId) {}

  /// 处理图片点击事件
  void _handleImageClick(NewsResponse cardData, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(
          news: cardData,
          fontSizeRatio: widget.fontSizeRatio,
        ),
      ),
    );
  }

  /// 处理关注点击事件
  void _handleWatchClick(String? newsId) {
    if (newsId != null) {
      widget.onWatchClick?.call(newsId);
    }
  }
}
