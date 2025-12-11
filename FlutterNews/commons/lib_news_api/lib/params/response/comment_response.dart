import 'author_response.dart';

/// 评论-云侧接口响应模型
class CommentResponse {
  /// 评论id
  String commentId;

  /// 父评论ID
  String? parentCommentId;

  /// 父评论详情
  CommentResponse? parentComment;

  /// 从属新闻id
  String newsId;

  /// 评论的作者
  AuthorResponse? author;

  /// 评论的内容
  String commentBody;

  /// 评论被点赞数量
  int commentLikeNum;

  /// 评论时间
  int createTime;

  /// 是否被我点赞
  bool isLiked;

  /// 被回复的评论列表
  List<CommentResponse> replyComments;

  /// 创建一个CommentResponse实例
  CommentResponse({
    required this.commentId,
    this.parentCommentId,
    this.parentComment,
    this.author,
    required this.newsId,
    required this.commentBody,
    required this.commentLikeNum,
    required this.createTime,
    required this.isLiked,
    required this.replyComments,
  });

  /// 从JSON数据创建CommentResponse实例
  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      commentId: json['commentId'] as String,
      parentCommentId: json['parentCommentId'] as String?,
      parentComment: json['parentComment'] != null
          ? CommentResponse.fromJson(
              json['parentComment'] as Map<String, dynamic>)
          : null,
      newsId: json['newsId'] as String,
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
  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'parentCommentId': parentCommentId,
      'parentComment': parentComment?.toJson(),
      'newsId': newsId,
      'author': author?.toJson(),
      'commentBody': commentBody,
      'commentLikeNum': commentLikeNum,
      'createTime': createTime,
      'isLiked': isLiked,
      'replyComments': replyComments.map((e) => e.toJson()).toList(),
    };
  }

  CommentResponse copyWith({
    String? commentId,
    String? parentCommentId,
    CommentResponse? parentComment,
    String? newsId,
    AuthorResponse? author,
    String? commentBody,
    int? commentLikeNum,
    int? createTime,
    bool? isLiked,
    List<CommentResponse>? replyComments,
  }) {
    return CommentResponse(
      commentId: commentId ?? this.commentId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      parentComment: parentComment ?? this.parentComment,
      newsId: newsId ?? this.newsId,
      author: author ?? this.author,
      commentBody: commentBody ?? this.commentBody,
      commentLikeNum: commentLikeNum ?? this.commentLikeNum,
      createTime: createTime ?? this.createTime,
      isLiked: isLiked ?? this.isLiked,
      replyComments: replyComments ?? this.replyComments,
    );
  }
}
