// 新闻类型枚举
enum NewsType {
  article, // 文章
  video,   // 视频
  post;    // 动态

  static NewsType fromInt(int value) {
    switch (value) {
      case 1:
        return NewsType.video;
      case 2:
        return NewsType.post;
      default:
        return NewsType.article;
    }
  }
}

// 作者信息模型
class AuthorInfo {
  final String authorId;
  final String authorNickName;
  final String authorIcon;
  final String authorDesc;
  final String authorIp;
  final int watchersCount;
  final int followersCount;
  final int likeNum;

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

  AuthorInfo.copy(AuthorInfo? other)
      : authorId = other?.authorId ?? '',
        authorNickName = other?.authorNickName ?? '',
        authorIcon = other?.authorIcon ?? '',
        authorDesc = other?.authorDesc ?? '',
        authorIp = other?.authorIp ?? '',
        watchersCount = other?.watchersCount ?? 0,
        followersCount = other?.followersCount ?? 0,
        likeNum = other?.likeNum ?? 0;
}

class CommentModel {
  final String commentId;
  final String newsId;
  final AuthorInfo author;
  final String commentBody;
  final AuthorInfo? replyAuthor; // 可选：被回复的作者
  final int commentLikeNum;
  final int createTime; 
  final bool isLiked; // 是否被当前用户点赞
  final List<CommentModel> replyComments; // 子评论列表

  CommentModel({
    required this.commentId,
    required this.newsId,
    required this.author,
    required this.commentBody,
    this.replyAuthor,
    this.commentLikeNum = 0,
    required this.createTime,
    this.isLiked = false,
    this.replyComments = const [],
  });
}

class PostMedia {
  final String url; 
  final String? id;
  final String thumbnailUrl; 
  final int? type; 
  final String? essayId;

  PostMedia({
    this.url = '',
    this.id,
    this.thumbnailUrl = '',
    this.type,
    this.essayId,
  });
}

class FeedCardInfo {
  final String id;
  final NewsType type;
  final String title;
  final AuthorInfo author;
  final int createTime; // 时间戳
  final List<CommentModel> comments;
  final int commentCount; // 评论总数
  final int markCount; // 收藏数
  final int likeCount; // 点赞数
  final int shareCount; // 分享数
  final bool isLiked; // 是否点赞
  final bool isMarked; // 是否收藏
  final String? richContent; // 文章内容
  final String? videoUrl; // 视频地址
  final String? coverUrl; // 封面图
  final int? videoDuration; // 视频时长（秒）
  final String? postBody; // 动态文本内容
  final List<PostMedia> postMedias; // 动态的图片/视频列表
  final int? totalCount; // 总数据量（可能用于分页）
  final bool isWatch; // 是否关注

  FeedCardInfo({
    this.id = '',
    this.type = NewsType.article,
    this.title = '',
    AuthorInfo? author,
    this.createTime = 0,
    this.comments = const [],
    this.commentCount = 0,
    this.markCount = 0,
    this.likeCount = 0,
    this.shareCount = 0,
    this.isLiked = false,
    this.isMarked = false,
    this.richContent,
    this.videoUrl,
    this.coverUrl,
    this.videoDuration,
    this.postBody,
    this.postMedias = const [],
    this.totalCount,
    this.isWatch = false,
  }) : author = author ?? AuthorInfo();

  FeedCardInfo.copy(FeedCardInfo? other)
      : id = other?.id ?? '',
        type = other?.type ?? NewsType.article,
        title = other?.title ?? '',
        author = AuthorInfo.copy(other?.author),
        createTime = other?.createTime ?? 0,
        comments = other?.comments ?? [],
        commentCount = other?.commentCount ?? 0,
        markCount = other?.markCount ?? 0,
        likeCount = other?.likeCount ?? 0,
        shareCount = other?.shareCount ?? 0,
        isLiked = other?.isLiked ?? false,
        isMarked = other?.isMarked ?? false,
        richContent = other?.richContent,
        videoUrl = other?.videoUrl,
        coverUrl = other?.coverUrl,
        videoDuration = other?.videoDuration,
        postBody = other?.postBody,
        postMedias = other?.postMedias ?? [],
        totalCount = other?.totalCount,
        isWatch = other?.isWatch ?? false;
}