import '../constants/constants.dart';
import '../params/base/base_model.dart';

/// 简单新闻信息
class SimpleNews {
  // 新闻id
  String newsId;
  // 新闻类型
  NewsEnum newsType;

  SimpleNews({
    required this.newsId,
    required this.newsType,
  });

  factory SimpleNews.fromJson(Map<String, dynamic> json) {
    return SimpleNews(
      newsId: json['newsId'],
      newsType: NewsEnum.values[json['newsType']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newsId': newsId,
      'newsType': newsType.index,
    };
  }
}

/// 新闻基础字段（文章、视频、动态）
class BaseNews {
  // 新闻id
  String id;
  // 新闻类型
  NewsEnum type;
  // 标题
  String title;
  // 作者
  String authorId;
  // 创建时间
  int createTime;
  // 评论总数
  int commentCount;
  // 收藏数量
  int markCount;
  // 点赞数量
  int likeCount;
  // 分享数量
  int shareCount;
  // 是否被点赞
  bool isLiked;
  // 是否被收藏
  bool isMarked;
  // 文章-富文本
  String? richContent;
  // 文章-相关推荐
  List<SimpleNews>? recommends;
  // 视频-视频url
  String? videoUrl;
  // 视频-封面图
  String? coverUrl;
  // 视频-视频类型
  VideoEnum? videoType;
  // 视频时长(单位: 毫秒)
  int? videoDuration;
  // 动态-正文
  String? postBody;
  // 动态-图片链接
  List<PostImgList>? postImgList;
  // 新闻来源
  String? articleFrom;
  // 动态布局参数
  NavInfo navInfo;
  // 额外信息
  List<IButtonItem>? extraInfo;
  int? totalCount;
  String? publishTime;
  String? playCount;

  BaseNews({
    required this.id,
    required this.type,
    required this.title,
    required this.authorId,
    required this.createTime,
    required this.commentCount,
    required this.markCount,
    required this.likeCount,
    required this.shareCount,
    required this.isLiked,
    required this.isMarked,
    this.richContent,
    this.recommends,
    this.videoUrl,
    this.coverUrl,
    this.videoType,
    this.videoDuration,
    this.postBody,
    this.postImgList,
    this.articleFrom,
    required this.navInfo,
    this.extraInfo,
    this.totalCount,
    this.publishTime,
    this.playCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'title': title,
      'authorId': authorId,
      'createTime': createTime,
      'commentCount': commentCount,
      'markCount': markCount,
      'likeCount': likeCount,
      'shareCount': shareCount,
      'isLiked': isLiked,
      'isMarked': isMarked,
      'richContent': richContent,
      'recommends': recommends
          ?.map((e) => {
                'newsId': e.newsId,
                'newsType': e.newsType.index,
              })
          .toList(),
      'videoUrl': videoUrl,
      'coverUrl': coverUrl,
      'videoType': videoType?.toString(),
      'videoDuration': videoDuration,
      'postBody': postBody,
      'postImgList': postImgList?.map((e) => e.toJson()).toList(),
      'articleFrom': articleFrom,
      'navInfo': navInfo.toJson(),
      'extraInfo': extraInfo?.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'publishTime': publishTime,
      'playCount': playCount,
    };
  }
}
