import 'package:business_video/models/video_model.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/services/video_service.dart';
import 'package:lib_news_api/services/author_service.dart';
import 'package:lib_news_api/constants/constants.dart';
import 'package:lib_news_api/services/base_news_service.dart';
import 'package:lib_news_api/params/response/layout_response.dart';
import 'package:lib_news_api/services/comment_service.dart';
import 'package:lib_news_api/params/response/comment_response.dart';

class VideoService {
  // 静态方法：创建视频列表
  static List<VideoNewsData> createVideoList(List<NewsResponse> list) {
    return list.map((item) => VideoNewsData.fromCommentResponse(item)).toList();
  }

  // 查询评论列表
  static List<CommentResponse> getComments(String id) {
    // 1. 查询评论列表（可能为null）
    List<CommentResponse>? commentList = CommentServiceApi.queryCommentList(id);
    // 2. 处理空情况 + 类型转换（假设CommentResponse可转换为BaseComment）
    if (commentList != null) {
      return commentList;
    } else {
      return [];
    }
  }

  // 查询关注的用户的视频列表
  static List<VideoNewsData> queryFollowedUserVideoList(String authorId) {
    // 1. 查询当前用户关注的用户ID列表
    final followedUserIds = authorServiceApi
        .queryWatchers(authorId) // 将queryWatchUsers改为queryWatchers
        .map((user) => user.authorId)
        .toList();

    // 2. 查询关注用户发布的视频
    final followedUserVideos =
        VideoServiceApi.queryVideoFollowList(followedUserIds);

    final List<VideoNewsData> videoList =
        VideoService.createVideoList(followedUserVideos);
    videoList.shuffle();
    return videoList;
  }

  // 查询视频流，如果有userId，查询对应用户的视频。需要区分是纯视频还是发的动态中的视频
  static List<VideoNewsData> queryVideoList() {
    final list =
        VideoServiceApi.queryVideoList(userId: '', type: NewsEnum.video);
    final List<VideoNewsData> videoList = VideoService.createVideoList(list);
    videoList.shuffle();
    return videoList;
  }

  static VideoNewsData? queryVideoDataById(String id) {
    // 1. 调用API获取原始数据
    final data = VideoServiceApi.queryVideoById(id);

    // 2. 类型转换（含空安全处理）
    return data != null ? VideoNewsData.fromCommentResponse(data) : null;
  }

  // 查询直播banner
  static List<VideoNewsData> queryLiveBannerList() {
    // 1. 异步获取视频列表
    final response =
        VideoServiceApi.queryVideoList(userId: '', type: NewsEnum.video);
    // 2. 转换视频数据格式
    final videoList = VideoService.createVideoList(response);
    // 3. 取前3个元素并随机排序
    final liveMockList = [...videoList.sublist(0, 3)];
    liveMockList.shuffle();
    return liveMockList;
  }

  // 查询精彩回放数据
  static List<VideoNewsData> queryLiveHighlightsList() {
    // 1. 异步获取视频列表
    final response =
        VideoServiceApi.queryVideoList(userId: '', type: NewsEnum.video);
    // 2. 转换视频数据格式
    final videoList = VideoService.createVideoList(response);
    // 3. 取前3个元素并随机排序
    final liveMockList = [...videoList.sublist(0, 8)];
    liveMockList.shuffle();
    return liveMockList;
  }

  static List<VideoNewsData> queryLiveIntroduceList(String userId) {
    List<RequestListData> list = BaseNewsService().queryAuthorPosts(userId);
    List<NewsResponse> videoList = [];
    for (var item in list) {
      videoList.add(item.articles[0]);
    }
    return VideoService.createVideoList(videoList);
  }
}
