import '../params/response/news_response.dart';

import '../database/news_type.dart';
import 'base_news_service.dart';
import 'mockdata/mock_video.dart';
import 'mockdata/mock_post.dart';
import '../constants/constants.dart';

/// 视频服务类
///
/// 使用组合模式，内部通过BaseNewsServiceApi访问基础服务
class VideoService {
  /// 单例模式实例
  static VideoService? _instance;

  /// 私有构造函数，防止外部直接实例化
  VideoService._();

  /// 工厂构造函数，返回单例实例
  factory VideoService() {
    _instance ??= VideoService._();
    return _instance!;
  }

  /// 查询视频关注流
  ///
  /// 参数:
  /// - [followedUserIds]: 已关注用户ID列表
  ///
  /// 返回值:
  /// - 混合后的关注用户视频列表
  List<NewsResponse> queryVideoFollowList(List<String> followedUserIds) {
    final List<NewsResponse> videos = [];

    for (final userId in followedUserIds) {
      final followedUserVideos = MockVideo.list
          .where((v) => v.authorId == userId)
          .map((video) => BaseNewsService().queryNews(video.id))
          .where((v) => v != null)
          .cast<NewsResponse>()
          .toList();

      videos.addAll(followedUserVideos);
    }

    // 随机打乱数组
    return _shuffleArray(List<NewsResponse>.from(videos));
  }

  /// 查询视频流
  ///
  /// 参数:
  /// - [userId]: 用户ID（可选，为空时查询所有视频）
  /// - [type]: 视频类型
  ///
  /// 返回值:
  /// - 筛选并混合后的视频列表
  List<NewsResponse> queryVideoList(
      {String userId = '', required NewsEnum type}) {
    List<BaseNews> list = MockVideo.list;

    if (userId.isNotEmpty) {
      if (type == NewsEnum.video) {
        list = list.where((v) => v.authorId == userId).toList();
      } else if (type == NewsEnum.post) {
        final newsVideoList = MockPost.list.where((item) {
          final isVideo = item.postImgList?.any((postImgItem) {
                return postImgItem.surfaceUrl.isNotEmpty &&
                    postImgItem.picVideoUrl.isNotEmpty;
              }) ??
              false;
          return isVideo;
        }).toList();
        list = newsVideoList.where((v) => v.authorId == userId).toList();
      }
    }

    final videos = list
        .map((video) => BaseNewsService().queryNews(video.id))
        .where((v) => v != null)
        .cast<NewsResponse>()
        .toList();
    return _shuffleArray(List<NewsResponse>.from(videos));
  }

  /// 根据id查询视频详细信息
  NewsResponse? queryVideoById(String id) {
    return BaseNewsService().queryNews(id);
  }

  /// 随机打乱数组的辅助方法
  List<T> _shuffleArray<T>(List<T> array) {
    final random = _SimpleRandom();
    for (var i = array.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
    return array;
  }
}

/// 简单的随机数生成器
class _SimpleRandom {
  int nextInt(int max) {
    return DateTime.now().millisecondsSinceEpoch % max;
  }
}

/// 全局单例实例，供外部调用
final VideoServiceApi = VideoService();
