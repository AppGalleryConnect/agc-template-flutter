import 'package:business_video/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/utils/global_context.dart';
import 'package:lib_news_api/constants/constants.dart';
import 'package:lib_news_api/observedmodels/news_model.dart';
import 'package:module_newsfeed/components/news_detail_page.dart';
// import 'package:business_video/models/video_model.dart';
// import 'package:module_newsfeed/components/news_detail_page.dart';

/// 内容导航工具类
/// 封装统一的新闻详情和视频跳转逻辑，支持从不同模块跳转到内容详情
class ContentNavigationUtils {
  /// 跳转到内容详情页
  /// 根据内容类型自动判断是跳转到文章详情还是视频详情
  static void navigateToContentDetail(NewsModel newsInfo) {
    try {
      // 根据内容类型判断跳转到不同页面
      if (newsInfo.type == NewsEnum.video) {
        // 视频类型，跳转到视频详情页
        _navigateToVideoDetail(newsInfo);
      } else {
        // 文章或动态类型，跳转到文章详情页
        _navigateToArticleDetail(newsInfo);
      }
    } catch (e) {
      // 降级方案：使用ID进行跳转
      _navigateWithFallback(newsInfo);
    }
  }

  /// 跳转到视频详情页
  static void _navigateToVideoDetail(NewsModel newsInfo) {
    // 创建VideoNewsData对象，以匹配VideoDetailPage的参数要求
    final VideoNewsData videoData = VideoNewsData(
      id: newsInfo.id,
      title: newsInfo.title,
      type: newsInfo.type,
      videoUrl: newsInfo.videoUrl ?? '',
      coverUrl: newsInfo.coverUrl ?? '',
      createTime: newsInfo.createTime,
      author: newsInfo.author,
      likeCount: newsInfo.likeCount,
      commentCount: newsInfo.commentCount,
      shareCount: newsInfo.shareCount,
      markCount: newsInfo.markCount,
      isLiked: newsInfo.isLiked,
      isMarked: newsInfo.isMarked,
      videoDuration: newsInfo.videoDuration ?? 0,
      postImgList: newsInfo.postImgList,
    );

    // 使用RouterUtils进行导航
    RouterUtils.of.pushPathByName(
      RouterMap.VIDEO_PLAY_PAGE,
      param: videoData,
    );
  }

  /// 将NewsModel转换为FeedCardInfo

  /// 跳转到文章详情页
  static void _navigateToArticleDetail(NewsModel newsInfo) {
    // 直接构建NewsDetailPage并传递news参数
    Navigator.push(
      GlobalContext.context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(news: newsInfo),
      ),
    );
  }

  /// 降级导航方案，当完整信息不可用时使用
  static void _navigateWithFallback(NewsModel newsInfo) {
    // 只使用ID进行跳转，让目标页面自行获取数据
    if (newsInfo.type == NewsEnum.video) {
      RouterUtils.of.pushPathByName(
        RouterMap.VIDEO_PLAY_PAGE,
        param: newsInfo.id,
      );
    } else {
      // 降级方案也使用直接构建页面的方式
      Navigator.push(
        GlobalContext.context,
        MaterialPageRoute(
          builder: (context) => NewsDetailPage(news: newsInfo),
        ),
      );
    }
  }

  /// 从评论跳转到内容详情页
  /// 用于处理"我的评论"模块中的跳转
  static void navigateFromCommentToDetail(NewsModel newsInfo) {
    navigateToContentDetail(newsInfo);
  }

  /// 从消息跳转到内容详情页
  /// 用于处理"消息-评论与回复"模块中的跳转
  static void navigateFromMessageToDetail(NewsModel newsInfo) {
    navigateToContentDetail(newsInfo);
  }

  /// 通用的内容详情跳转方法
  /// 支持从不同来源（如评论、消息、点赞等）跳转到内容详情
  static void navigateToDetailFromAnySource(NewsModel newsInfo,
      {String? source}) {
    // 可以根据source参数添加不同的追踪或特殊处理
    navigateToContentDetail(newsInfo);
  }
}
