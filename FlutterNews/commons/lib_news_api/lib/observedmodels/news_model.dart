import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../params/response/comment_response.dart';
import '../params/response/news_response.dart';
import 'comment_model.dart';
import '../params/base/base_model.dart';

/// 新闻模型
class NewsModel extends NewsResponse with ChangeNotifier {
  List<CommentModel> commentModels = [];

  @override
  NewsModel(NewsResponse v)
      : super(
          id: v.id,
          type: v.type,
          title: v.title,
          createTime: v.createTime,
          comments: v.comments,
          commentCount: v.commentCount,
          markCount: v.markCount,
          likeCount: v.likeCount,
          shareCount: v.shareCount,
          isLiked: v.isLiked,
          isMarked: v.isMarked,
          author: v.author,
          relativeTime: v.relativeTime,
          richContent: v.richContent,
          recommends: v.recommends,
          videoUrl: v.videoUrl,
          coverUrl: v.coverUrl,
          videoType: v.videoType,
          videoDuration: v.videoDuration,
          postBody: v.postBody,
          postImgList: v.postImgList,
          navInfo: v.navInfo,
          extraInfo: v.extraInfo,
          articleFrom: v.articleFrom,
          playCount: v.playCount,
          totalCount: v.totalCount,
          relationId: v.relationId,
        ) {
    comments = v.comments.toList();
    extraInfo =
        v.extraInfo != null ? Map<String, dynamic>.from(v.extraInfo!) : null;

    commentModels = v.comments.map((comment) => CommentModel(comment)).toList();
  }

  factory NewsModel.fromNewsResponse(NewsResponse v) {
    return NewsModel(v);
  }

  /// 切换点赞状态并更新点赞数
  void toggleLike() {
    isLiked = !isLiked;
    likeCount += isLiked ? 1 : -1;
    notifyListeners();
  }

  /// 切换收藏状态并更新收藏数
  void toggleMark() {
    isMarked = !isMarked;
    markCount += isMarked ? 1 : -1;
    notifyListeners();
  }

  /// 增加分享数量
  void incrementShareCount() {
    shareCount += 1;
    notifyListeners();
  }

  /// 增加评论数量
  void incrementCommentCount() {
    commentCount += 1;
    notifyListeners();
  }

  /// 添加评论 - 修复版本
  void addComment(CommentResponse comment) {
    final newCommentModel = CommentModel(comment);
    commentModels.add(newCommentModel);
    comments.add(comment);
    commentCount += 1;
    notifyListeners();
  }

  /// 更新新闻标题
  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  /// 更新富文本内容
  void updateRichContent(String newContent) {
    richContent = newContent;
    notifyListeners();
  }

  /// 更新播放次数
  void updatePlayCount(String newPlayCount) {
    playCount = newPlayCount;
    notifyListeners();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'author': author?.toJson(),
      'createTime': createTime,
      'comments': comments.map((e) => e.toJson()).toList(),
      'commentCount': commentCount,
      'markCount': markCount,
      'likeCount': likeCount,
      'shareCount': shareCount,
      'isLiked': isLiked,
      'isMarked': isMarked,
      'richContent': richContent,
      'recommends': recommends?.map((e) => e.toJson()).toList(),
      'videoUrl': videoUrl,
      'coverUrl': coverUrl,
      'videoType': videoType?.name,
      'videoDuration': videoDuration,
      'postBody': postBody,
      'postImgList': _postImgListToJson(postImgList),
      if (navInfo != null) 'navInfo': _navInfoToJson(navInfo),
      if (extraInfo != null) 'extraInfo': extraInfo,
      if (articleFrom != null) 'articleFrom': articleFrom,
      if (playCount != null) 'playCount': playCount,
      if (totalCount != null) 'totalCount': totalCount,
      if (relationId != null) 'relationId': relationId,
    };
  }

  List<Map<String, dynamic>> _postImgListToJson(List<PostImgList>? list) {
    if (list == null) return [];
    return list.map((img) {
      final result = {
        'picVideoUrl': img.picVideoUrl,
        'surfaceUrl': img.surfaceUrl,
      };
      if (img.id != null) result['id'] = img.id!;
      if (img.type != null) result['type'] = img.type.toString();
      if (img.essayId != null) result['essayId'] = img.essayId!;
      return result;
    }).toList();
  }

  Map<String, dynamic> _navInfoToJson(NavInfo? navInfo) {
    if (navInfo == null) return {};
    return {'setting': navInfo.setting};
  }
}
