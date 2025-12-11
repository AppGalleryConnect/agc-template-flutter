import 'package:flutter/material.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';
import 'package:lib_news_api/observedmodels/news_model.dart';
import 'package:lib_news_api/observedmodels/comment_model.dart';
import 'package:lib_news_api/params/response/aggregate_response.dart';
import 'package:lib_news_api/params/response/author_response.dart';
import 'package:lib_news_api/params/response/comment_response.dart';
import 'package:lib_news_api/params/response/message_response.dart';
import 'package:flutter/foundation.dart';

mixin JsonSerializableMixin {
  Map<String, dynamic> toJson();
}

class AggregateNewsCommentModel with ChangeNotifier {
  /// 评论ID
  String commentId;

  /// 父评论ID
  String? parentCommentId;

  /// 父评论信息
  CommentResponse? parentComment;

  /// 新闻ID
  String newsId;

  /// 新闻详情信息
  NewsModel newsDetailInfo;

  /// 评论作者信息
  AuthorResponse? author;

  /// 评论内容
  String commentBody;

  /// 评论点赞数
  int commentLikeNum;

  /// 创建时间
  int createTime;

  /// 是否已点赞
  bool isLiked;

  /// 回复评论列表
  List<CommentResponse> replyComments;

  AggregateNewsCommentModel(AggregateNewsComment v)
      : commentId = v.commentId,
        parentCommentId = v.parentCommentId,
        parentComment = v.parentComment,
        newsId = v.newsId,
        newsDetailInfo = NewsModel.fromNewsResponse(v.newsDetailInfo),
        author = v.author,
        commentBody = v.commentBody,
        commentLikeNum = v.commentLikeNum,
        createTime = v.createTime,
        isLiked = v.isLiked,
        replyComments = v.replyComments;

  void updateInfo(AggregateNewsComment v) {
    commentId = v.commentId;
    parentCommentId = v.parentCommentId;
    parentComment = v.parentComment;
    newsId = v.newsId;
    newsDetailInfo = NewsModel.fromNewsResponse(v.newsDetailInfo);
    author = v.author;
    commentBody = v.commentBody;
    commentLikeNum = v.commentLikeNum;
    createTime = v.createTime;
    isLiked = v.isLiked;
    replyComments = v.replyComments;
    notifyListeners();
  }

  /// 切换点赞状态并更新点赞数
  void toggleLike() {
    isLiked = !isLiked;
    commentLikeNum += isLiked ? 1 : -1;
    notifyListeners();
  }
}

/// 评论详情模型类
class CommentDetailModel
    with ChangeNotifier, JsonSerializableMixin
    implements CommentDetailResponse {
  /// 根评论信息
  AggregateNewsCommentModel _root;

  /// 当前评论信息
  CommentModel? _current;

  @override
  CommentResponse? get current {
    if (_current == null) return null;
    return CommentResponse(
      commentId: _current!.commentId,
      parentCommentId: _current!.parentCommentId,
      newsId: _current!.newsId,
      author: _current!.author != null
          ? AuthorResponse(
              authorId: _current!.author!.authorId,
              authorNickName: _current!.author!.authorNickName,
              authorIcon: _current!.author!.authorIcon,
              authorDesc: '',
              authorIp: '',
              watchersCount: 0,
              followersCount: 0,
              likeNum: 0,
            )
          : null,
      commentBody: _current!.commentBody,
      commentLikeNum: _current!.commentLikeNum,
      createTime: _current!.createTime,
      isLiked: _current!.isLiked,
      replyComments: [],
    );
  }

  @override
  set current(CommentResponse? value) {
    _current = value != null ? CommentModel(value) : null;
    notifyListeners();
  }

  /// 评论列表
  List<CommentModel> _list;

  /// 构造函数，根据CommentDetailResponse对象初始化
  CommentDetailModel(CommentDetailResponse v)
      : _root = AggregateNewsCommentModel(v.root),
        _current = v.current != null ? CommentModel(v.current!) : null,
        _list = v.list.map((comment) => CommentModel(comment)).toList();

  factory CommentDetailModel.fromJson(Map<String, dynamic> json) {
    final response = CommentDetailResponse.fromJson(json);
    return CommentDetailModel(response);
  }
  @override
  AggregateNewsComment get root {
    return AggregateNewsComment(
      commentId: _root.commentId,
      parentCommentId: _root.parentCommentId,
      parentComment: _root.parentComment,
      newsId: _root.newsId,
      newsDetailInfo: _root.newsDetailInfo,
      author: _root.author,
      commentBody: _root.commentBody,
      commentLikeNum: _root.commentLikeNum,
      createTime: _root.createTime,
      isLiked: _root.isLiked,
      replyComments: _root.replyComments,
    );
  }

  /// 设置根评论信息（符合CommentDetailResponse接口）
  @override
  set root(AggregateNewsComment value) {
    _root = AggregateNewsCommentModel(value);
    notifyListeners();
  }

  @override
  List<CommentResponse> get list {
    return _list
        .map((model) => CommentResponse(
              commentId: model.commentId,
              parentCommentId: model.parentCommentId,
              newsId: model.newsId,
              author: model.author != null
                  ? AuthorResponse(
                      authorId: model.author!.authorId,
                      authorNickName: model.author!.authorNickName,
                      authorIcon: model.author!.authorIcon,
                      authorDesc: '',
                      authorIp: '',
                      watchersCount: 0,
                      followersCount: 0,
                      likeNum: 0,
                    )
                  : null,
              commentBody: model.commentBody,
              commentLikeNum: model.commentLikeNum,
              createTime: model.createTime,
              isLiked: model.isLiked,
              replyComments: [],
            ))
        .toList();
  }

  @override
  set list(List<CommentResponse> value) {
    _list = value.map((comment) => CommentModel(comment)).toList();
    notifyListeners();
  }

  /// 获取内部使用的CommentModel列表
  List<CommentModel> get internalList => _list;

  /// 转换为JSON格式
  @override
  Map<String, dynamic> toJson() {
    return {
      'root': root.toJson(),
      'current': current?.toJson(),
      'list': list.map((e) => e.toJson()).toList(),
    };
  }
}

/// 简要IM信息模型类
class BriefIMModel
    with ChangeNotifier, JsonSerializableMixin
    implements BriefIMResponse {
  /// 聊天作者信息
  @override
  AuthorModel chatAuthor;

  /// 未读消息总数
  @override
  int allUnreadCount;

  /// 接收时间
  @override
  int receiveTime;

  /// 最新消息内容
  @override
  String latestNews;

  /// 聊天详情列表
  @override
  List<ChatInfoDetailModel> chatList;

  bool isSelect = false;
  bool isDelete = false;

  /// 构造函数，根据BriefIMResponse对象初始化
  BriefIMModel(BriefIMResponse v)
      : chatAuthor = AuthorModel(v.chatAuthor),
        allUnreadCount = v.allUnreadCount,
        receiveTime = v.receiveTime,
        latestNews = v.latestNews,
        chatList = [];

  /// 更新IM信息并通知监听器
  void updateInfo(BriefIMResponse v) {
    chatAuthor.updateInfo(v.chatAuthor);
    allUnreadCount = v.allUnreadCount;
    receiveTime = v.receiveTime;
    latestNews = v.latestNews;
    notifyListeners();
  }

  /// 添加聊天记录
  void addChatRecord(ChatInfoDetailModel record) {
    chatList.add(record);
    notifyListeners();
  }

  /// 转换为JSON格式
  @override
  Map<String, dynamic> toJson() {
    return {
      'chatAuthor': chatAuthor.toJson(),
      'allUnreadCount': allUnreadCount,
      'receiveTime': receiveTime,
      'latestNews': latestNews,
      'chatList': chatList.map((e) => e.toJson()).toList(),
    };
  }
}

/// 系统消息信息模型类
class SystemMessageInfo
    with ChangeNotifier, JsonSerializableMixin
    implements SystemDetailInfo {
  /// 消息id
  @override
  String id;

  /// 消息内容
  @override
  String content;

  /// 创建时间
  @override
  int createTime;

  bool isSelect = false;
  bool isDelete = false;

  /// 构造函数，根据SystemDetailInfo对象初始化
  SystemMessageInfo(SystemDetailInfo v)
      : id = v.id,
        content = v.content,
        createTime = v.createTime;

  /// 更新系统消息并通知监听器
  void updateInfo(SystemDetailInfo v) {
    content = v.content;
    createTime = v.createTime;
    notifyListeners();
  }

  /// 转换为JSON格式
  @override
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'createTime': createTime,
    };
  }
}

/// 聊天详情模型类
class ChatInfoDetailModel
    with ChangeNotifier, JsonSerializableMixin
    implements ChatInfoDetailResponse {
  @override
  String type;
  @override
  String content;

  /// 是否为自己发送的消息
  @override
  bool? isMyself;

  /// 创建时间
  @override
  int? createTime;

  /// 构造函数，根据ChatInfoDetailResponse对象初始化
  ChatInfoDetailModel(ChatInfoDetailResponse v)
      : type = v.type,
        content = v.content,
        isMyself = v.isMyself,
        createTime = v.createTime;

  /// 更新聊天详情并通知监听器
  void updateInfo(ChatInfoDetailResponse v) {
    type = v.type;
    content = v.content;
    isMyself = v.isMyself;
    createTime = v.createTime;
    notifyListeners();
  }

  /// 转换为JSON格式
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'isMyself': isMyself,
      'createTime': createTime,
    };
  }
}
