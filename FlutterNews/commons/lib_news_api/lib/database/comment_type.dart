import '../params/response/author_response.dart';
import '../params/response/comment_response.dart';

/// 评论数据库字段模型
class BaseComment {
  /// 评论唯一标识符
  String commentId;

  /// 父评论ID
  String? parentCommentId;

  /// 从属新闻ID
  String newsId;

  /// 评论的作者ID
  String authorId;

  /// 评论的内容
  String commentBody;

  /// 评论被点赞数量
  int commentLikeNum;

  /// 评论时间戳（毫秒）
  int createTime;

  /// 是否被当前用户点赞
  bool isLiked;

  /// 被回复的评论ID列表
  List<String> replyComments;

  /// 构造函数
  BaseComment({
    required this.commentId,
    required this.newsId,
    required this.authorId,
    required this.commentBody,
    required this.commentLikeNum,
    required this.createTime,
    required this.isLiked,
    required this.replyComments,
    this.parentCommentId,
  });
  BaseComment copyWith({
    String? commentId,
    String? authorId,
    String? newsId,
    String? commentBody,
    bool? isLiked,
    int? commentLikeNum,
    int? createTime,
    List<String>? replyComments,
    String? parentCommentId,
  }) {
    return BaseComment(
      commentId: commentId ?? this.commentId,
      newsId: authorId ?? this.newsId,
      authorId: authorId ?? this.authorId,
      commentBody: commentBody ?? this.commentBody,
      isLiked: isLiked ?? this.isLiked,
      commentLikeNum: commentLikeNum ?? this.commentLikeNum,
      createTime: createTime ?? this.createTime,
      replyComments: replyComments ?? this.replyComments,
      parentCommentId: parentCommentId ?? this.parentCommentId,
    );
  }

  factory BaseComment.fromJson(Map<String, dynamic> json) {
    return BaseComment(
      commentId: json['commentId'],
      parentCommentId: json['parentCommentId'],
      newsId: json['newsId'],
      authorId: json['authorId'],
      commentBody: json['commentBody'],
      commentLikeNum: json['commentLikeNum'],
      createTime: json['createTime'],
      isLiked: json['isLiked'],
      replyComments: json['replyComments'] != null
          ? json['replyComments'].cast<String>()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'parentCommentId': parentCommentId,
      'newsId': newsId,
      'authorId': authorId,
      'commentBody': commentBody,
      'commentLikeNum': commentLikeNum,
      'createTime': createTime,
      'isLiked': isLiked,
      'replyComments': replyComments,
    };
  }

  CommentResponse toCommentResponse({
    AuthorResponse? author,
    CommentResponse? parentComment,
  }) {
    return CommentResponse(
      commentId: commentId,
      parentCommentId: parentCommentId,
      parentComment: parentComment,
      newsId: newsId,
      author: author,
      commentBody: commentBody,
      commentLikeNum: commentLikeNum,
      createTime: createTime,
      isLiked: isLiked,
      replyComments: replyComments
          .map((replyCommentId) => CommentResponse(
                commentId: replyCommentId,
                newsId: newsId,
                commentBody: '',
                commentLikeNum: 0,
                createTime: 0,
                isLiked: false,
                replyComments: [],
                author: author,
              ))
          .toList(),
    );
  }

  AuthorResponse toAuthorResponse({
    required String authorNickName,
    required String authorIcon,
    String authorDesc = '',
    String authorIp = '',
    int watchersCount = 0,
    int followersCount = 0,
    int likeNum = 0,
    List<String>? watchers,
    List<String>? followers,
    String? authorPhone,
  }) {
    return AuthorResponse(
      authorId: authorId,
      authorNickName: authorNickName,
      authorIcon: authorIcon,
      authorDesc: authorDesc,
      authorIp: authorIp,
      watchersCount: watchersCount,
      followersCount: followersCount,
      likeNum: likeNum,
      watchers: watchers,
      followers: followers,
      authorPhone: authorPhone,
    );
  }
}
