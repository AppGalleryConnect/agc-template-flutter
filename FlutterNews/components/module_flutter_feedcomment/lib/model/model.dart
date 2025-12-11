class AuthorInfo {
  String authorId;
  String authorNickName;
  String authorIcon;
  String authorDesc;
  String authorIp;
  int watchersCount;
  int followersCount;
  int likeNum;

  AuthorInfo({
    this.authorId = '',
    this.authorNickName = '',
    this.authorIcon = '',
    this.authorDesc = '',
    this.authorIp = '',
    this.watchersCount = 0,
    this.followersCount = 0,
    this.likeNum = 0,
  });

  factory AuthorInfo.fromUserInfo(dynamic userInfo) {
    return AuthorInfo(
      authorId: userInfo?.authorId ?? '',
      authorNickName: userInfo?.authorNickName ?? '',
      authorIcon: userInfo?.authorIcon ?? '',
      authorDesc: userInfo?.authorDesc ?? '',
      authorIp: userInfo?.authorIp ?? '',
      watchersCount: userInfo?.watchersCount ?? 0,
      followersCount: userInfo?.followersCount ?? 0,
      likeNum: userInfo?.likeNum ?? 0,
    );
  }
}

class CommentInfo {
  String commentId;
  String newsId;
  CommentInfo? parentComment;
  AuthorInfo author;
  String commentBody;
  int commentLikeNum;
  int createTime;
  bool isLiked;
  int likeCount;
  List<CommentInfo> replyComments;

  CommentInfo({
    this.commentId = '',
    this.newsId = '',
    this.parentComment,
    AuthorInfo? author,
    this.commentBody = '',
    this.commentLikeNum = 0,
    this.createTime = 0,
    this.isLiked = false,
    this.likeCount = 0,
    List<CommentInfo>? replyComments,
  })  : author = author ?? AuthorInfo(),
        replyComments = replyComments ?? [];
}


