import 'package:flutter/foundation.dart';
import '../params/response/comment_response.dart';
import 'author_model.dart';

/// 评论信息模型类
class CommentModel with ChangeNotifier {
  /// 评论唯一标识符
  String commentId;

  /// 父评论ID（可选）
  String? parentCommentId;

  /// 父评论对象（可选）
  CommentModel? parentComment;

  /// 从属新闻ID
  String newsId;

  /// 评论作者信息
  AuthorModel? author;

  /// 评论内容
  String commentBody;

  /// 评论被点赞数量
  int commentLikeNum;

  /// 评论创建时间戳
  int createTime;

  /// 是否已点赞
  bool isLiked;

  /// 回复评论列表
  List<CommentModel> replyComments;

  /// 将评论信息转换为JSON格式
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

  /// 构造函数，根据 CommentResponse 对象初始化 CommentModel
  CommentModel(CommentResponse v)
      : commentId = v.commentId,
        parentCommentId = v.parentCommentId,
        newsId = v.newsId,
        author = v.author != null ? AuthorModel(v.author!) : null,
        commentBody = v.commentBody,
        commentLikeNum = v.commentLikeNum,
        createTime = v.createTime,
        isLiked = v.isLiked,
        replyComments =
            v.replyComments.map((reply) => CommentModel(reply)).toList() {
    if (v.parentComment != null) {
      parentComment = CommentModel(v.parentComment!);
    }
  }

  /// 切换点赞状态并更新点赞数
  void toggleLike() {
    isLiked = !isLiked;
    commentLikeNum += isLiked ? 1 : -1;
    notifyListeners();
  }

  /// 更新评论内容
  void updateCommentBody(String newBody) {
    commentBody = newBody;
    notifyListeners();
  }

  /// 添加回复评论
  void addReplyComment(CommentResponse reply) {
    final newReply = CommentModel(reply);
    replyComments.add(newReply);
    notifyListeners();
  }

  /// 移除回复评论
  void removeReplyComment(String replyCommentId) {
    replyComments.removeWhere((reply) => reply.commentId == replyCommentId);
    notifyListeners();
  }

  /// 更新点赞数量
  void updateLikeNum(int newLikeNum) {
    commentLikeNum = newLikeNum;
    notifyListeners();
  }
}
