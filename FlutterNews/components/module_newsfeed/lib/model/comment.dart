// // 评论数据模型
class Comment {
  final String commentId;
  final String newsId;
  final String authorId;
  final String commentBody;
  final String commentLikeNum;
  final String createTime;
  final String userName;
  final String avatarUrl;
  final String content;
  final  bool isLiked;

  final List<replyComments> replies; 

  Comment({
    required this.commentId,
    required this.newsId,
    required this.authorId,
    required this.commentBody,
    required this.commentLikeNum,
    required this.createTime,
    required this.userName,
    required this.avatarUrl,
    required this.content,
    this.isLiked = false,
    this.replies =  const [],
  });
}

// 回复数据模型
class replyComments {
  final String userId;
  final String userName;
  final String content;
  final String time;

  replyComments({
    required this.userId,
    required this.userName,
    required this.content,
    required this.time,
  });
}