import '../database/comment_type.dart';
import '../params/response/comment_response.dart';
import 'author_service.dart';
import 'mockdata/mock_comment.dart';
import 'mockdata/mock_post.dart';
import 'mockdata/mock_article.dart';
import 'mockdata/mock_video.dart';

/// 评论服务类
class CommentService {
  CommentService._();
  static final CommentService _instance = CommentService._();
  factory CommentService() => _instance;

  /// 查询数据库中的单条评论
  BaseComment? queryRawComment(String commentId) {
    try {
      return MockComment.list.firstWhere(
        (v) => v.commentId == commentId,
      );
    } catch (e) {
      return null;
    }
  }

  /// 查询数据库中的评论列表
  List<BaseComment> queryRawCommentList(String newsId) {
    return MockComment.list
        .where((v) => v.newsId == newsId && (v.parentCommentId == null || v.parentCommentId == ''))
        .toList();
  }

  /// 数据库字段转换成接口字段
  CommentResponse handleCommentRaw(
    BaseComment item,
    bool ignoreParent,
    bool ignoreReply,
  ) {
    final authorInfo = authorServiceApi.queryAuthorInfo(item.authorId);
    final CommentResponse commentResponse = CommentResponse(
      commentId: item.commentId,
      newsId: item.newsId,
      author: authorInfo,
      commentBody: item.commentBody,
      commentLikeNum: item.commentLikeNum,
      createTime: item.createTime,
      isLiked: item.isLiked,
      parentCommentId: item.parentCommentId,
      replyComments: [],
    );
    if (item.parentCommentId != null && !ignoreParent) {
      final parentComment = queryRawComment(item.parentCommentId!);
      if (parentComment != null) {
        commentResponse.parentComment =
            handleCommentRaw(parentComment, true, true);
      }
    }
    if (item.replyComments.isNotEmpty && !ignoreReply) {
      commentResponse.replyComments = item.replyComments
          .map((id) {
            final comment = queryRawComment(id);
            if (comment != null) {
              return handleCommentRaw(comment, false, true);
            }
            return null;
          })
          .where((comment) => comment != null)
          .map((comment) => comment!)
          .toList();
    }
    return commentResponse;
  }

  /// 查询单个评论
  CommentResponse? queryComment(String commentId) {
    final item = queryRawComment(commentId);
    if (item != null) {
      return handleCommentRaw(item, false, false);
    }
    return null;
  }

  /// 查询评论列表
  List<CommentResponse>? queryCommentList(String newsId) {
    final items = queryRawCommentList(newsId);
    if (items.isNotEmpty) {
      return items
          .map((comment) => handleCommentRaw(comment, false, false))
          .toList();
    }
    return null;
  }

  /// 查询评论的总数
  int queryTotalCommentCount(String newsId) {
    return queryRawCommentList(newsId).length;
  }

  /// 通过作者id过滤评论
  List<CommentResponse> queryCommentByAuthorId(String authorId) {
    return MockComment.list
        .where((v) => v.authorId == authorId)
        .map((v) => handleCommentRaw(v, false, false))
        .toList();
  }

  /// 查询根评论
  String queryRootComment(String commentId) {
    try {
      final item = MockComment.list.firstWhere((v) => v.commentId == commentId);
      if (item.parentCommentId != null) {
        return queryRootComment(item.parentCommentId!);
      }
      return item.commentId;
    } catch (e) {
      return '';
    }
  }

  /// 添加评论
  void addComment(BaseComment newItem) {
    if (newItem.parentCommentId != null) {
      try {
        final parent = MockComment.list.firstWhere(
          (item) => item.commentId == newItem.parentCommentId,
          orElse: () => throw Exception('Parent comment not found'),
        );
        parent.replyComments.insert(0, newItem.commentId);
        final rootId = queryRootComment(newItem.parentCommentId!);
        if (rootId != parent.commentId) {
          try {
            final root = MockComment.list.firstWhere(
              (item) => item.commentId == rootId,
              orElse: () => throw Exception('Root comment not found'),
            );
            root.replyComments.insert(0, newItem.commentId);
          } catch (e) {
            // 忽略未找到的根评论
          }
        }
      } catch (e) {
        // 忽略未找到的父评论
      }
    }
    MockComment.list.insert(0, newItem);
  }

  /// 删除评论
  void deleteComment(String commentId) {
    final index = MockComment.list.indexWhere((v) => v.commentId == commentId);
    if (index != -1) {
      MockComment.list.removeAt(index);
    }
  }

  /// 评论点赞
  void likeComment(String commentId) {
    try {
      final item = MockComment.list.firstWhere((v) => v.commentId == commentId);
      if (!item.isLiked) {
        item.isLiked = true;
        item.commentLikeNum += 1;
      }
    } catch (e) {
      // 忽略未找到的评论
    }
  }

  /// 评论点赞接口
  void addCommentLike(String commentId) {
    try {
      final item = MockComment.list.firstWhere((v) => v.commentId == commentId);
      if (!item.isLiked) {
        item.isLiked = true;
        item.commentLikeNum += 1;
      }
    } catch (e) {
      // 忽略未找到的评论
    }
  }

  /// 评论取消点赞
  void cancelCommentLike(String commentId) {
    try {
      final item = MockComment.list.firstWhere((v) => v.commentId == commentId);
      if (item.isLiked) {
        item.isLiked = false;
        item.commentLikeNum -= 1;
      }
    } catch (e) {
      // 忽略未找到的评论
    }
  }

  /// 文章动态点赞接口
  void addPosterLike(String newsId) {
    final allNews = [...MockPost.list, ...MockArticle.list, ...MockVideo.list];
    try {
      final item = allNews.firstWhere((v) => (v as dynamic).id == newsId);
      if (!(item as dynamic).isLiked) {
        (item as dynamic).isLiked = true;
        (item as dynamic).likeCount += 1;
      }
    } catch (e) {
      // 忽略未找到的新闻
    }
  }

  /// 文章动态取消点赞接口
  void cancelPosterLike(String newsId) {
    final allNews = [...MockPost.list, ...MockArticle.list, ...MockVideo.list];
    try {
      final item = allNews.firstWhere((v) => (v as dynamic).id == newsId);
      if ((item as dynamic).isLiked) {
        (item as dynamic).isLiked = false;
        (item as dynamic).likeCount -= 1;
      }
    } catch (e) {
      // 忽略未找到的新闻
    }
  }

  /// 取消点赞评论
  void cancelLikeComment(String commentId) {
    try {
      final item = MockComment.list.firstWhere((v) => v.commentId == commentId);
      if (item.isLiked) {
        item.isLiked = false;
        item.commentLikeNum -= 1;
      }
    } catch (e) {
      // 忽略未找到的评论
    }
  }
}

// 全局单例实例
final CommentServiceApi = CommentService();
