import 'mockdata/mock_message.dart';
import 'author_service.dart';
import '../database/message_type.dart';
import '../params/response/message_response.dart';
import '../params/response/aggregate_response.dart';
import '../params/response/comment_response.dart';
import '../params/response/news_response.dart';
import '../params/request/common_request.dart';
import '../constants/constants.dart';
import 'base_news_service.dart';
import 'mockdata/mock_comment.dart';
import 'comment_service.dart';
import '../params/base/base_model.dart';

/// 消息更新类型枚举
enum MessageUpdateType {
  Comment,
  IM,
  Fan,
  System,
  All,
}

/// 消息服务观察者接口
abstract class MessageObserver {
  void onMessageUpdated(MessageUpdateType type);
}

/// 消息服务类
class MessageService {
  // 单例模式实现
  static MessageService? _instance;
  MessageService._internal();
  final List<MessageObserver> _observers = [];

  /// 添加观察者
  void addObserver(MessageObserver observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }

  /// 移除观察者
  void removeObserver(MessageObserver observer) {
    _observers.remove(observer);
  }

  /// 通知所有观察者
  void notifyObservers(MessageUpdateType type) {
    for (var observer in _observers) {
      observer.onMessageUpdated(type);
    }
  }

  factory MessageService() {
    _instance ??= MessageService._internal();
    return _instance!;
  }

  /// 查询评论与回复概要信息
  Future<BriefMsgInfo> queryBriefCommentReply() async {
    return MockMessage.briefCommentReplyInfo;
  }

  /// 查询私信简概要信息
  Future<BriefIMInfo> queryBriefIM() async {
    final authorId = MockMessage.allBriefIMList
        .firstWhere(
          (v) => v.chatList.isNotEmpty,
          orElse: () => BriefIMInfo(
            chatAuthorId: '',
            allUnreadCount: 0,
            receiveTime: 0,
            latestNews: '',
            chatList: [],
          ),
        )
        .chatAuthorId;
    final authorInfo = authorServiceApi.queryAuthorInfo(authorId);
    return BriefIMInfo(
      chatAuthorId: authorId,
      allUnreadCount: MockMessage.briefIMInfo.allUnreadCount,
      receiveTime: MockMessage.briefIMInfo.receiveTime,
      latestNews: '${authorInfo?.authorNickName ?? ''}  私信了你',
      chatList: [],
    );
  }

  /// 查询新增粉丝概要信息
  Future<BriefMsgInfo> queryBriefNewFans() async {
    return MockMessage.briefNewFansInfo;
  }

  /// 查询系统消息概要信息
  Future<BriefMsgInfo> queryBriefSystemInfo() async {
    return MockMessage.briefSystemInfo;
  }

  /// 查询评论与回复列表
  Future<List<AggregateNewsComment>> queryCommentReplyList() async {
    final mineInfo = authorServiceApi.queryAuthorInfo()!;
    final myNewsList = BaseNewsServiceApi.queryAllNews(mineInfo.authorId);
    final myNewsCommentList = MockComment.list
        .where((v) => myNewsList.map((item) => item.id).contains(v.newsId))
        .where((v) => v.parentCommentId == null)
        .toList();
    final myCommentList = MockComment.list
        .where((v) => v.authorId == mineInfo.authorId)
        .where((v) => v.parentCommentId == null)
        .where((v) => v.replyComments.isNotEmpty)
        .toList();
    final myReplyList = MockComment.list
        .where((v) => v.authorId == mineInfo.authorId)
        .where((v) => v.parentCommentId != null)
        .where((v) => MockComment.list
            .map((item) => item.parentCommentId)
            .contains(v.commentId))
        .toList();
    final finalList = <AggregateNewsComment>[];
    final allComments = [
      ...myNewsCommentList,
      ...myCommentList,
      ...myReplyList
    ];
    for (final comment in allComments) {
      final item = CommentServiceApi.queryComment(comment.commentId);
      if (item != null) {
        final newsDetail = BaseNewsServiceApi.queryNews(item.newsId);
        final aggComment = AggregateNewsComment(
          commentId: item.commentId,
          parentCommentId: item.parentCommentId,
          parentComment: item.parentComment,
          newsId: item.newsId,
          newsDetailInfo: newsDetail ??
              NewsResponse(
                id: item.newsId,
                type: NewsEnum.article,
                title: '未知标题',
                createTime: DateTime.now().millisecondsSinceEpoch,
                comments: [],
                commentCount: 0,
                markCount: 0,
                likeCount: 0,
                shareCount: 0,
                isLiked: false,
                isMarked: false,
                author: null,
                relativeTime: '',
                navInfo: NavInfo(),
              ),
          author: item.author,
          commentBody: item.commentBody,
          commentLikeNum: item.commentLikeNum,
          createTime: item.createTime,
          isLiked: item.isLiked,
          replyComments: item.replyComments,
        );
        finalList.add(aggComment);
      }
    }
    return finalList;
  }

  /// 查询单个评论消息的全部详情
  Future<CommentDetailResponse> querySingleCommentList(String commentId) async {
    CommentResponse? current;
    final rootId = CommentServiceApi.queryRootComment(commentId);
    final rootComment = CommentServiceApi.queryComment(rootId);
    final newsDetailInfo =
        BaseNewsServiceApi.queryNews(rootComment?.newsId ?? '');
    final root = AggregateNewsComment(
      commentId: rootComment?.commentId ?? '',
      parentCommentId: rootComment?.parentCommentId,
      newsId: rootComment?.newsId ?? '',
      newsDetailInfo: newsDetailInfo ??
          NewsResponse(
              id: '',
              type: NewsEnum.article,
              title: '',
              createTime: 0,
              comments: [],
              commentCount: 0,
              markCount: 0,
              likeCount: 0,
              shareCount: 0,
              isLiked: false,
              isMarked: false,
              author: null,
              relativeTime: null,
              navInfo: null),
      author: rootComment?.author,
      commentBody: rootComment?.commentBody ?? '',
      commentLikeNum: rootComment?.commentLikeNum ?? 0,
      createTime: rootComment?.createTime ?? 0,
      isLiked: rootComment?.isLiked ?? false,
      replyComments: rootComment?.replyComments ?? [],
      parentComment: rootComment?.parentComment,
    );

    if (rootId != commentId) {
      current = CommentServiceApi.queryComment(commentId);
    }
    final list = (root.replyComments)
        .where(
            (v) => ![root.commentId, current?.commentId].contains(v.commentId))
        .toList();
    return CommentDetailResponse(
      root: root,
      current: current,
      list: list,
    );
  }

  /// 查询所有私信列表
  Future<List<BriefIMInfo>> queryAllIMList() async {
    return MockMessage.allBriefIMList;
  }

  /// 设置所有私信已读
  Future<void> setIMAllRead() async {
    for (var v in MockMessage.allBriefIMList) {
      v.allUnreadCount = 0;
    }
    MockMessage.briefIMInfo.allUnreadCount = 0;
    notifyObservers(MessageUpdateType.IM);
  }

  /// 进入单人聊天页面-消息已读
  void setSingleChatRead(String authorId) {
    final item = MockMessage.allBriefIMList.firstWhere(
      (v) => v.chatAuthorId == authorId,
      orElse: () => BriefIMInfo(
        chatAuthorId: '',
        allUnreadCount: 0,
        receiveTime: 0,
        latestNews: '',
        chatList: [],
      ),
    );
    if (item.chatAuthorId.isNotEmpty) {
      item.allUnreadCount = 0;
      MockMessage.briefIMInfo.allUnreadCount = MockMessage.allBriefIMList
          .fold(0, (acc, cur) => acc + cur.allUnreadCount);
      notifyObservers(MessageUpdateType.IM);
    }
  }

  /// 查询和单个用户的全部聊天记录
  Future<List<ChatInfoDetail>> queryChatRecordByAuthorId(
      String authorId) async {
    List<ChatInfoDetail> list = [];
    try {
      final item = MockMessage.allBriefIMList.firstWhere(
        (v) => v.chatAuthorId == authorId,
        orElse: () => throw Exception('Not found'),
      );
      if (item.chatList.isEmpty) {
        item.chatList.addAll([
          ChatInfoDetail(
            type: ChatEnum.text,
            content: '你好！很高兴认识你！',
            isMyself: false,
            createTime: DateTime.now().millisecondsSinceEpoch - 3600000,
          ),
          ChatInfoDetail(
            type: ChatEnum.text,
            content: '你好！我也很高兴认识你！',
            isMyself: true,
            createTime: DateTime.now().millisecondsSinceEpoch - 3000000,
          ),
          ChatInfoDetail(
            type: ChatEnum.text,
            content: '感谢你的消息！',
            isMyself: false,
            createTime: DateTime.now().millisecondsSinceEpoch - 2400000,
          ),
        ]);
      }
      list = item.chatList;
    } catch (_) {
      final defaultChats = [
        ChatInfoDetail(
          type: ChatEnum.text,
          content: '你好！这是一个新的聊天！',
          isMyself: false,
          createTime: DateTime.now().millisecondsSinceEpoch,
        ),
        ChatInfoDetail(
          type: ChatEnum.text,
          content: '感谢你的消息！',
          isMyself: false,
          createTime: DateTime.now().millisecondsSinceEpoch + 1000,
        ),
      ];
      final newItem = BriefIMInfo(
        chatAuthorId: authorId,
        allUnreadCount: 0,
        receiveTime: DateTime.now().millisecondsSinceEpoch,
        latestNews: '感谢你的消息！',
        chatList: defaultChats,
      );
      MockMessage.allBriefIMList.insert(0, newItem);
      list = defaultChats;
    }
    return list;
  }

  /// 发送私信
  Future<void> sendMessage(
      String chatWithAuthorId, SendMessageRequest data) async {
    _sendLocalMessage(chatWithAuthorId, data);
  }

  /// 本地模拟发送消息
  void _sendLocalMessage(String chatWithAuthorId, SendMessageRequest data) {
    final info = ChatInfoDetail(
      type: data.type,
      content: data.content,
      isMyself: true,
      createTime: data.createTime,
    );
    try {
      final item = MockMessage.allBriefIMList.firstWhere(
        (v) => v.chatAuthorId == chatWithAuthorId,
        orElse: () => throw Exception('Not found'),
      );
      item.chatList.add(info);
      item.receiveTime = data.createTime;
      item.latestNews = data.content;
      final reply = ChatInfoDetail(
        type: ChatEnum.text,
        content: '感谢你的消息！',
        isMyself: false,
        createTime: DateTime.now().millisecondsSinceEpoch,
      );
      item.chatList.add(reply);
      item.allUnreadCount++;
      MockMessage.briefIMInfo.allUnreadCount = MockMessage.allBriefIMList
          .fold(0, (acc, cur) => acc + cur.allUnreadCount);
      notifyObservers(MessageUpdateType.IM);
    } catch (_) {
      // 用户不存在，不做处理
    }
  }

  /// 查询所有系统消息
  Future<List<SystemDetailInfo>> queryAllSystemInfoList() async {
    return MockMessage.allSystemInfoList;
  }

  /// 评论回复已读
  Future<void> setReplyRead() async {
    MockMessage.briefCommentReplyInfo.allUnreadCount = 0;
    notifyObservers(MessageUpdateType.Comment);
  }

  /// 新增粉丝已读
  Future<void> setNewFansRead() async {
    MockMessage.briefNewFansInfo.allUnreadCount = 0;
    notifyObservers(MessageUpdateType.Fan);
  }

  /// 系统消息已读
  Future<void> setSystemRead() async {
    MockMessage.briefSystemInfo.allUnreadCount = 0;
    notifyObservers(MessageUpdateType.System);
  }

  /// 一键已读
  Future<void> setAllRead() async {
    await setReplyRead();
    await setIMAllRead();
    await setNewFansRead();
    await setSystemRead();
    notifyObservers(MessageUpdateType.All);
  }

  /// 删除私信
  Future<void> deleteIM(String authorId) async {
    MockMessage.allBriefIMList.removeWhere((v) => v.chatAuthorId == authorId);
    MockMessage.briefIMInfo.allUnreadCount = MockMessage.allBriefIMList
        .fold(0, (acc, cur) => acc + cur.allUnreadCount);
    notifyObservers(MessageUpdateType.IM);
  }

  /// 删除所有私信
  Future<void> deleteAll() async {
    MockMessage.allBriefIMList.clear();
    MockMessage.briefIMInfo.allUnreadCount = MockMessage.allBriefIMList
        .fold(0, (acc, cur) => acc + cur.allUnreadCount);
    notifyObservers(MessageUpdateType.IM);
  }

  /// 删除系统消息
  Future<void> deleteSystemIM(String id) async {
    MockMessage.allSystemInfoList.removeWhere((v) => v.id == id);
  }

  /// 删除所有系统消息
  Future<void> deleteAllSystem() async {
    MockMessage.allSystemInfoList.clear();
  }
}

/// 全局单例实例，供外部调用
final messageServiceApi = MessageService();
