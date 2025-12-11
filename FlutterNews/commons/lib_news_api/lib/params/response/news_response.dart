import 'dart:convert';

import 'package:business_video/models/video_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../database/news_type.dart';
import '../base/base_model.dart';
import 'author_response.dart';
import 'comment_response.dart';

/// 新闻内容-云侧接口响应模型
class NewsResponse {
  /// 内容id
  String id;

  /// 新闻类型
  NewsEnum type;

  /// 标题
  String title;

  /// 作者
  AuthorResponse? author;

  /// 创建时间
  int createTime;

  // 相对时间
  String? relativeTime;

  /// 评论列表
  List<CommentResponse> comments;

  /// 评论数
  int commentCount;

  /// 收藏数量
  int markCount;

  /// 点赞数量
  int likeCount;

  /// 分享数量
  int shareCount;

  /// 是否被点赞
  bool isLiked;

  /// 是否被收藏
  bool isMarked;

  /// 富文本
  String? richContent;

  /// 相关推荐
  List? recommends;

  /// 视频url
  String? videoUrl;

  /// 封面图
  String? coverUrl;

  /// 视频类型
  VideoEnum? videoType;

  /// 视频时长(单位: 毫秒)
  int? videoDuration;

  /// 正文
  String? postBody;

  /// 图片链接
  List<PostImgList>? postImgList;

  /// 动态布局参数
  NavInfo? navInfo;

  /// 额外信息
  Map<String, dynamic>? extraInfo;

  /// 来源
  String? articleFrom;

  /// 播放次数
  String? playCount;

  /// 总数
  int? totalCount;

  /// 关联文章id
  String? relationId;

  /// 构造函数
  NewsResponse({
    required this.id,
    required this.type,
    required this.title,
    required this.createTime,
    required this.comments,
    required this.commentCount,
    required this.markCount,
    required this.likeCount,
    required this.shareCount,
    required this.isLiked,
    required this.isMarked,
    this.author,
    this.relativeTime,
    this.richContent,
    this.recommends,
    this.videoUrl,
    this.coverUrl,
    this.videoType,
    this.videoDuration,
    this.postBody,
    this.postImgList,
    this.navInfo,
    this.extraInfo,
    this.articleFrom,
    this.playCount,
    this.totalCount,
    this.relationId,
  });

  /// 从JSON数据创建NewsResponse实例
  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      id: json['id'] as String,
      type: _parseNewsEnum(json['type']),
      title: json['title'] as String,
      author: json['author'] != null
          ? AuthorResponse.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      createTime: json['createTime'] as int? ?? 0,
      relativeTime: json['relativeTime'] as String?,
      comments: _parseComments(json['comments']),
      commentCount: json['commentCount'] as int? ?? 0,
      markCount: json['markCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      shareCount: json['shareCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isMarked: json['isMarked'] as bool? ?? false,
      richContent: json['richContent'] as String?,
      recommends: _parseRecommends(json['recommends']),
      videoUrl: json['videoUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      videoType: _parseVideoEnum(json['videoType'] as String?),
      videoDuration: json['videoDuration'] as int?,
      postBody: json['postBody'] as String?,
      postImgList: _parsePostImgList(json['postImgList']),
      navInfo: _parseNavInfo(json['navInfo']),
      extraInfo: json['extraInfo'] as Map<String, dynamic>?,
      articleFrom: json['articleFrom'] as String?,
      playCount: json['playCount'] as String?,
      totalCount: json['totalCount'] as int?,
      relationId: json['relationId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'author': author?.toJson(),
      'createTime': createTime,
      'relativeTime': relativeTime,
      'comments': comments.map((e) => e.toJson()).toList(),
      'commentCount': commentCount,
      'markCount': markCount,
      'likeCount': likeCount,
      'shareCount': shareCount,
      'isLiked': isLiked,
      'isMarked': isMarked,
      if (richContent != null) 'richContent': richContent,
      if (recommends != null)
        'recommends': recommends?.map((e) => e.toJson()).toList(),
      if (videoUrl != null) 'videoUrl': videoUrl,
      if (coverUrl != null) 'coverUrl': coverUrl,
      if (videoType != null) 'videoType': videoType?.name,
      if (videoDuration != null) 'videoDuration': videoDuration,
      if (postBody != null) 'postBody': postBody,
      if (postImgList != null) 'postImgList': _postImgListToJson(postImgList),
      if (navInfo != null) 'navInfo': _navInfoToJson(navInfo),
      if (extraInfo != null) 'extraInfo': extraInfo,
      if (articleFrom != null) 'articleFrom': articleFrom,
      if (playCount != null) 'playCount': playCount,
      if (totalCount != null) 'totalCount': totalCount,
      if (relationId != null) 'relationId': relationId,
    };
  }

  // 辅助方法：解析NewsEnum
  static NewsEnum _parseNewsEnum(value) {
    if (value == null) return NewsEnum.article;
    if (value is String) {
      if (value.contains('.')) {
        value = value.split('.').last;
      }

      try {
        return NewsEnum.values.byName(value);
      } catch (e) {
        try {
          return NewsEnum.values.byName(value.toLowerCase());
        } catch (e) {
          return NewsEnum.article;
        }
      }
    }
    if (value is NewsEnum) {
      return value;
    }
    return NewsEnum.article;
  }

  static VideoEnum? _parseVideoEnum(String? value) {
    if (value == null) return null;
    if (value.contains('.')) {
      value = value.split('.').last;
    }

    try {
      return VideoEnum.values.byName(value);
    } catch (e) {
      try {
        return VideoEnum.values.byName(value.toLowerCase());
      } catch (e) {
        return null;
      }
    }
  }

  static List<CommentResponse> _parseComments(dynamic data) {
    if (data == null || data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map((e) => CommentResponse.fromJson(e))
        .toList();
  }

  static List? _parseRecommends(dynamic data) {
    if (data == null || data is! List) return null;
    return data.whereType<Map<String, dynamic>>().map((e) {
      if (e.containsKey("newsId") || e.containsKey("newsType")) {
        return SimpleNews.fromJson(e);
      }
      return NewsResponse.fromJson(e);
    }).toList();
  }

  static List<PostImgList>? _parsePostImgList(dynamic data) {
    if (data == null || data is! List) return null;
    return data.map((e) {
      final map = e as Map<String, dynamic>;
      return PostImgList(
        picVideoUrl: map['picVideoUrl'] as String? ?? '',
        surfaceUrl: map['surfaceUrl'] as String? ?? '',
        id: map['id'] as String?,
        type: map['type'] as int?,
        essayId: map['essayId'] as String?,
      );
    }).toList();
  }

  static NavInfo? _parseNavInfo(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      return NavInfo(setting: data['setting'] as String? ?? '');
    }
    return NavInfo();
  }

  static List<Map<String, dynamic>> _postImgListToJson(
      List<PostImgList>? list) {
    if (list == null) return [];
    return list.map((img) {
      return {
        'picVideoUrl': img.picVideoUrl,
        'surfaceUrl': img.surfaceUrl,
        'id': img.id,
        'type': img.type,
        'essayId': img.essayId,
      };
    }).toList();
  }

  static Map<String, dynamic> _navInfoToJson(NavInfo? navInfo) {
    return {
      'setting': navInfo?.setting ?? '',
    };
  }

  Future<void> saveUser(NewsResponse user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = user.toJson().toString();
    await prefs.setString(user.id, jsonString);
  }

  Future<NewsResponse?> getUser(NewsResponse user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(user.id);
    if (jsonString != null) {
      final jsonMap = Map<String, dynamic>.from(jsonDecode(jsonString));
      return NewsResponse.fromJson(jsonMap);
    }
    return null;
  }

  Future<void> deleteUser(NewsResponse user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(user.id);
  }

  VideoNewsData toVideoNewsData() {
    String videoUrlStr = '';
    String coverUrlStr = '';

    if ((videoUrl == null || videoUrl!.isEmpty) &&
        postImgList?.isNotEmpty == true) {
      final firstImg = postImgList!.first;
      videoUrlStr = firstImg.picVideoUrl;
      coverUrlStr = firstImg.surfaceUrl;
    } else {
      videoUrlStr = videoUrl ?? '';
      coverUrlStr = coverUrl ?? '';
    }

    return VideoNewsData(
      id: id,
      type: type,
      title: title,
      author: author,
      comments: comments,
      markCount: markCount,
      likeCount: likeCount,
      shareCount: shareCount,
      isLiked: isLiked,
      isMarked: isMarked,
      commentCount: commentCount,
      videoUrl: videoUrlStr,
      coverUrl: coverUrlStr,
      videoDuration: videoDuration ?? 0,
      createTime: createTime,
      postImgList: postImgList,
      currentDuration: 0,
    );
  }
}
