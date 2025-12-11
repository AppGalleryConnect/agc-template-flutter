import 'dart:math';
import '../params/request/common_request.dart';
import '../utils/safe_random_numer.dart';
import '../constants/constants.dart';
import '../database/comment_type.dart';
import '../params/response/aggregate_response.dart';
import '../params/response/comment_response.dart';
import 'base_news_service.dart';
import '../database/author_type.dart';
import '../params/response/author_response.dart';
import '../params/response/news_response.dart';
import 'author_service.dart';
import 'comment_service.dart';
import '../params/base/base_model.dart';

/// 收藏点赞更新类型枚举
enum MarkLikeUpdateType { Like, Mark, All }

/// 收藏点赞观察者接口
abstract class MarkLikeObserver {
  void onMarkLikeUpdated(MarkLikeUpdateType type);
}

/// 我的管理类
class MineService extends AuthorService {
  static MineService? _instance;
  MineService._internal();
  final List<MarkLikeObserver> _observers = [];
  factory MineService() {
    _instance ??= MineService._internal();
    return _instance!;
  }

  /// 添加观察者
  void addObserver(MarkLikeObserver observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }

  /// 移除观察者
  void removeObserver(MarkLikeObserver observer) {
    _observers.remove(observer);
  }

  /// 通知所有观察者
  void notifyObservers(MarkLikeUpdateType type) {
    for (final observer in _observers) {
      observer.onMarkLikeUpdated(type);
    }
  }

  /// 点赞
  void addLike(String newsId) {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    if (!mineUserInfo.myLikes.contains(newsId)) {
      mineUserInfo.myLikes.insert(0, newsId);
      final news = BaseNewsServiceApi.queryRawNews(newsId);
      if (news != null) {
        news.isLiked = true;
        news.likeCount = news.likeCount + 1;
      }
    }
    notifyObservers(MarkLikeUpdateType.Like);
  }

  /// 取消点赞
  void cancelLike(String newsId) {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    final index = mineUserInfo.myLikes.indexOf(newsId);
    if (index != -1) {
      mineUserInfo.myLikes.removeAt(index);
    }
    final news = BaseNewsServiceApi.queryRawNews(newsId);
    if (news != null) {
      news.isLiked = false;
      news.likeCount = max(0, news.likeCount - 1);
    }
    notifyObservers(MarkLikeUpdateType.Like);
  }

  /// 查询我的点赞
  List<NewsResponse> queryMyLikes() {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    return mineUserInfo.myLikes
        .map((id) => BaseNewsServiceApi.queryNews(id))
        .where((v) => v != null)
        .cast<NewsResponse>()
        .toList();
  }

  /// 重写父类方法以获取当前用户的作者信息
  @override
  AuthorResponse? queryAuthorInfo([String? userId, String? loginChannel]) {
    if (loginChannel != null) {
      return signIn(loginChannel);
    }
    final authorInfo = super.queryAuthorInfo(userId);
    return authorInfo;
  }

  /// 查询新增的粉丝
  List<AuthorResponse> queryNewFans() {
    final currentUser = queryAuthorRaw();
    final userId = currentUser?.authorId ?? '001';
    final followers =
        queryFollowers(userId).whereType<AuthorResponse>().toList();
    return followers.sublist(0, min(5, followers.length));
  }

  /// 添加关注
  void addWatch(String authorId) {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    mineUserInfo.watchers.insert(0, authorId);
  }

  /// 取消关注
  void cancelWatch(String authorId) {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    final index = mineUserInfo.watchers.indexWhere((id) => id == authorId);
    if (index != -1) {
      mineUserInfo.watchers.removeAt(index);
    }
  }

  /// 收藏
  void addMark(String newsId) {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    if (!mineUserInfo.myMarks.contains(newsId)) {
      mineUserInfo.myMarks.insert(0, newsId);
      final news = BaseNewsServiceApi.queryRawNews(newsId);
      if (news != null) {
        news.isMarked = true;
        news.markCount = news.markCount + 1;
      }
    }
    notifyObservers(MarkLikeUpdateType.Mark);
  }

  /// 取消收藏
  void cancelMark(String newsId) {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    final index = mineUserInfo.myMarks.indexWhere((id) => id == newsId);
    if (index != -1) {
      mineUserInfo.myMarks.removeAt(index);
    }
    final news = BaseNewsServiceApi.queryRawNews(newsId);
    if (news != null) {
      news.isMarked = false;
      news.markCount = max(0, news.markCount - 1);
    }
    notifyObservers(MarkLikeUpdateType.Mark);
  }

  /// 查询我的收藏
  List<NewsResponse> queryMyMarks() {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    return mineUserInfo.myMarks
        .map((id) => BaseNewsServiceApi.queryNews(id))
        .where((v) => v != null)
        .cast<NewsResponse>()
        .toList();
  }

  /// 发表评论
  Future<CommentResponse> publishComment(PublishCommentRequest params) async {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    final newItem = BaseComment(
      commentId: 'comment_${SafeRandomGenerate.generate()}',
      parentCommentId: params.parentCommentId,
      newsId: params.newsId,
      authorId: mineUserInfo.authorId,
      commentBody: params.content,
      commentLikeNum: 0,
      createTime: DateTime.now().millisecondsSinceEpoch,
      isLiked: false,
      replyComments: [],
    );
    mineUserInfo.myComments.insert(0, newItem.commentId);
    CommentServiceApi.addComment(newItem);
    return CommentServiceApi.queryComment(newItem.commentId) as CommentResponse;
  }

  /// 查询我的评论
  List<AggregateNewsComment> queryMineCommentList() {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    final comments =
        CommentServiceApi.queryCommentByAuthorId(mineUserInfo.authorId)
            .where((v) => v.parentCommentId == null || v.parentCommentId == '')
            .map((v) {
      final newsDetail = BaseNewsServiceApi.queryNews(v.newsId);
      final item = AggregateNewsComment(
        commentId: v.commentId,
        parentCommentId: v.parentCommentId,
        parentComment: v.parentComment,
        newsId: v.newsId,
        newsDetailInfo: newsDetail ??
            NewsResponse(
              id: '',
              type: NewsEnum.article,
              title: '',
              author: null,
              createTime: 0,
              relativeTime: '',
              comments: [],
              commentCount: 0,
              markCount: 0,
              likeCount: 0,
              shareCount: 0,
              isLiked: false,
              isMarked: false,
              richContent: '',
              navInfo: NavInfo(),
              recommends: [],
              postBody: null,
              postImgList: [],
              coverUrl: null,
              videoDuration: null,
              videoType: null,
              extraInfo: null,
              articleFrom: null,
              playCount: null,
              totalCount: null,
              relationId: null,
            ),
        author: v.author,
        commentBody: v.commentBody,
        commentLikeNum: v.commentLikeNum,
        createTime: v.createTime,
        isLiked: v.isLiked,
        replyComments: v.replyComments,
      );
      return item;
    }).toList()
          ..sort((a, b) => b.createTime.compareTo(a.createTime));
    return comments;
  }

  /// 删除评论
  void deleteComment(String newsId, String commentId) {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    final index = mineUserInfo.myComments.indexWhere((v) => v == commentId);
    if (index != -1) {
      mineUserInfo.myComments.removeAt(index);
    }
    CommentServiceApi.deleteComment(commentId);
  }

  /// 添加到阅读历史
  void addToHistory(String newsId) {
    deleteFromHistory(newsId);
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    mineUserInfo.myHistory.insert(0, newsId);
  }

  /// 从阅读历史中删除
  void deleteFromHistory(String newsId) {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    final index = mineUserInfo.myHistory.indexWhere((id) => id == newsId);
    if (index != -1) {
      mineUserInfo.myHistory.removeAt(index);
    }
  }

  /// 查询我的阅读记录
  List<NewsResponse> queryMyHistory() {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    return mineUserInfo.myHistory
        .map((id) => BaseNewsServiceApi.queryNews(id))
        .where((v) => v != null)
        .cast<NewsResponse>()
        .toList();
  }

  /// 修改个人信息
  void modifyPersonalInfo(ModifyPersonalInfoRequest params) {
    final mineUserInfo = queryAuthorRaw() as MyAuthor;
    if (params.authorIcon != null) {
      mineUserInfo.authorIcon = params.authorIcon!;
    }
    if (params.authorNickName != null) {
      mineUserInfo.authorNickName = params.authorNickName!;
    }
    if (params.authorPhone != null) {
      mineUserInfo.authorPhone = params.authorPhone!;
    }
    if (params.authorDesc != null) {
      mineUserInfo.authorDesc = params.authorDesc!;
    }
  }
}

final MineServiceApi = MineService();
