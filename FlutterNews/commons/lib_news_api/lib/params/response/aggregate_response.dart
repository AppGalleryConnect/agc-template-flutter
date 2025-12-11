import 'author_response.dart';
import 'comment_response.dart';
import 'news_response.dart';

/// 编排新闻和评论
class AggregateNewsComment implements CommentResponse {
  /// 评论id
  @override
  String commentId;

  /// 所回复的评论id
  @override
  String? parentCommentId;

  /// 所回复的评论
  @override
  CommentResponse? parentComment;

  /// 从属新闻id
  @override
  String newsId;

  /// 新闻详细
  NewsResponse newsDetailInfo;

  /// 评论的作者
  @override
  AuthorResponse? author;

  /// 评论的内容
  @override
  String commentBody;

  /// 评论被点赞数量
  @override
  int commentLikeNum;

  /// 评论时间
  @override
  int createTime;

  /// 是否被我点赞
  @override
  bool isLiked;

  /// 被回复的评论列表
  @override
  List<CommentResponse> replyComments;

  /// 创建一个AggregateNewsComment实例
  AggregateNewsComment({
    required this.commentId,
    this.parentCommentId,
    this.parentComment,
    required this.newsId,
    required this.newsDetailInfo,
    required this.author,
    required this.commentBody,
    required this.commentLikeNum,
    required this.createTime,
    required this.isLiked,
    required this.replyComments,
  });

  /// 从JSON数据创建AggregateNewsComment实例
  factory AggregateNewsComment.fromJson(Map<String, dynamic> json) {
    return AggregateNewsComment(
      commentId: json['commentId'] as String,
      parentCommentId: json['parentCommentId'] as String?,
      parentComment: json['parentComment'] != null
          ? CommentResponse.fromJson(
              json['parentComment'] as Map<String, dynamic>)
          : null,
      newsId: json['newsId'] as String,
      newsDetailInfo:
          NewsResponse.fromJson(json['newsDetailInfo'] as Map<String, dynamic>),
      author: AuthorResponse.fromJson(json['author'] as Map<String, dynamic>),
      commentBody: json['commentBody'] as String,
      commentLikeNum: json['commentLikeNum'] as int,
      createTime: json['createTime'] as int,
      isLiked: json['isLiked'] as bool,
      replyComments: (json['replyComments'] as List<dynamic>)
          .map((e) => CommentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 转换为JSON格式
  @override
  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'parentCommentId': parentCommentId,
      'parentComment': parentComment?.toJson(),
      'newsId': newsId,
      'newsDetailInfo': newsDetailInfo.toJson(),
      'author': author?.toJson(),
      'commentBody': commentBody,
      'commentLikeNum': commentLikeNum,
      'createTime': createTime,
      'isLiked': isLiked,
      'replyComments': replyComments.map((e) => e.toJson()).toList(),
    };
  }

  @override
  CommentResponse copyWith(
      {String? commentId,
      String? parentCommentId,
      CommentResponse? parentComment,
      String? newsId,
      AuthorResponse? author,
      String? commentBody,
      int? commentLikeNum,
      int? createTime,
      bool? isLiked,
      List<CommentResponse>? replyComments}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}

/// 消息-查看当前评论全部列表
class CommentDetailResponse {
  /// 根评论
  AggregateNewsComment root;

  /// 当前评论
  CommentResponse? current;

  /// 评论列表
  List<CommentResponse> list;

  /// 创建一个CommentDetailResponse实例
  CommentDetailResponse({
    required this.root,
    this.current,
    required this.list,
  });

  /// 从JSON数据创建CommentDetailResponse实例
  factory CommentDetailResponse.fromJson(Map<String, dynamic> json) {
    return CommentDetailResponse(
      root: AggregateNewsComment.fromJson(json['root'] as Map<String, dynamic>),
      current: json['current'] != null
          ? CommentResponse.fromJson(json['current'] as Map<String, dynamic>)
          : null,
      list: (json['list'] as List<dynamic>)
          .map((e) => CommentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'root': root.toJson(),
      'current': current?.toJson(),
      'list': list.map((e) => e.toJson()).toList(),
    };
  }
}
