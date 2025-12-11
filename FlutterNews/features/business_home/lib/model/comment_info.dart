import 'package:lib_news_api/params/response/author_response.dart';
import 'package:lib_news_api/params/response/comment_response.dart';

class CommentInfo {
  String commentId = '';
  String newsId = '';
  CommentInfo? parentComment;
  AuthorResponse? author;
  String commentBody = '';
  int commentLikeNum = 0;
  int createTime = 0;
  bool isLiked = false;
  int likeCount = 0;
  List<CommentInfo> replyComments = [];

  CommentInfo({
    this.commentId = '',
    this.newsId = '',
    this.parentComment,
    this.author,
    this.commentBody = '',
    this.commentLikeNum = 0,
    this.createTime = 0,
    this.isLiked = false,
    this.likeCount = 0,
    List<CommentInfo>? replyComments,
  }) {
    this.replyComments = replyComments ?? [];
  }

  Map<String, dynamic> toJson() {
    return {
      "commentId": commentId,
      "newsId": newsId,
      "commentBody": commentBody,
      "commentLikeNum": commentLikeNum,
      "createTime": createTime,
      "isLiked": isLiked,
      "likeCount": likeCount,
      "author": author?.toJson(),
      "replyComments": replyComments.map((e) => e.toJson()).toList(),
      "parentComment": parentComment?.toJson(),
    };
  }

  static CommentInfo fromJson(Map<String, dynamic> json) {
    return CommentInfo(
      commentId: json['commentId'],
      newsId: json['newsId'],
      commentBody: json['commentBody'],
      commentLikeNum: json['commentLikeNum'],
      createTime: json['createTime'],
      isLiked: json['isLiked'],
      likeCount: json['likeCount'],
      author: AuthorResponse.fromJson(json['author']),
      replyComments: json['replyComments'] != null
          ? json['replyComments']
              .map<CommentInfo>((e) => CommentInfo.fromJson(e))
              .toList()
          : [],
      parentComment: json['parentComment'] != null
          ? CommentInfo.fromJson(json['parentComment'])
          : null,
    );
  }

  static CommentInfo fromCommentResponse(CommentResponse comment) {
    return CommentInfo(
      commentId: comment.commentId,
      newsId: comment.newsId,
      commentBody: comment.commentBody,
      commentLikeNum: comment.commentLikeNum,
      createTime: comment.createTime,
      isLiked: comment.isLiked,
      likeCount: 0,
      author: comment.author,
      replyComments: comment.replyComments
          .map<CommentInfo>((e) => CommentInfo.fromCommentResponse(e))
          .toList(),
      parentComment: comment.parentComment != null
          ? CommentInfo.fromCommentResponse(comment.parentComment!)
          : null,
    );
  }
}
