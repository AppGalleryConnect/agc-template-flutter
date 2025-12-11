import '../../constants/constants.dart';
import '../../database/message_type.dart';
import '../../params/response/message_response.dart';

/// 模拟消息数据类
class MockMessage {
  /// 评论回复简要信息
  static BriefMsgInfo briefCommentReplyInfo = BriefMsgInfo(
    allUnreadCount: 10,
    receiveTime: DateTime.now().millisecondsSinceEpoch,
    latestNews: '2号选手  评论了你的动态',
  );

  /// 即时消息简要信息
  static BriefMsgInfo briefIMInfo = BriefMsgInfo(
    allUnreadCount: 3,
    receiveTime: DateTime.now().millisecondsSinceEpoch,
    latestNews: '娱记大杂烩  私信了你',
  );

  /// 新粉丝简要信息
  static BriefMsgInfo briefNewFansInfo = BriefMsgInfo(
    allUnreadCount: 3,
    receiveTime: DateTime.now().millisecondsSinceEpoch,
    latestNews: '1号选手  关注了你',
  );

  /// 系统消息简要信息
  static BriefMsgInfo briefSystemInfo = BriefMsgInfo(
    allUnreadCount: 2,
    receiveTime: DateTime.now().millisecondsSinceEpoch,
    latestNews:
        '亲爱的用户您好~2025.07.26 24:00:00-02:00进行安全升级，部分私信功能将无法使用，给您带来不便万分抱歉！感谢您的理解和支持！',
  );

  /// 评论回复ID列表
  static List<String> allCommentReplyList = [];

  /// 聊天列表1
  static List<ChatInfoDetail> chatList1 = [
    const ChatInfoDetail(
      type: ChatEnum.time,
      content: '14:14',
      createTime: 0,
    ),
    const ChatInfoDetail(
      type: ChatEnum.text,
      content: '好的设计是美的，大佬YYDS',
      createTime: 0,
    ),
    const ChatInfoDetail(
      type: ChatEnum.time,
      content: '07-10 14:14',
      createTime: 0,
    ),
    const ChatInfoDetail(
      type: ChatEnum.image,
      content:
          'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_2.jpg',
      createTime: 0,
    ),
    const ChatInfoDetail(
      type: ChatEnum.text,
      content: '落日的晚霞，落日余晖可以再提亮一些，就是一张很美的壁纸！',
      isMyself: true,
      createTime: 0,
    ),
  ];

  /// 聊天列表2
  static List<ChatInfoDetail> chatList2 = [
    const ChatInfoDetail(
      type: ChatEnum.time,
      content: '15:15',
      createTime: 0,
    ),
    const ChatInfoDetail(
      type: ChatEnum.text,
      content: '好的设计是美的，大佬YYDS',
      createTime: 0,
    ),
    const ChatInfoDetail(
      type: ChatEnum.time,
      content: '07-15 15:15',
      createTime: 0,
    ),
    const ChatInfoDetail(
      type: ChatEnum.image,
      content:
          'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_3.jpg',
      createTime: 0,
    ),
    const ChatInfoDetail(
      type: ChatEnum.text,
      content: '谢谢了你的点赞',
      isMyself: true,
      createTime: 0,
    ),
  ];

  /// 即时消息列表
  static List<BriefIMInfo> allBriefIMList = [
    BriefIMInfo(
      chatAuthorId: 'author_1',
      allUnreadCount: 1,
      receiveTime: DateTime.now().millisecondsSinceEpoch,
      latestNews: '谢谢了你的点赞',
      chatList: MockMessage.chatList1,
    ),
    BriefIMInfo(
      chatAuthorId: 'author_2',
      allUnreadCount: 2,
      receiveTime: DateTime.now().millisecondsSinceEpoch,
      latestNews: '好的设计是美的，大佬YYDS',
      chatList: MockMessage.chatList2,
    ),
  ];

  /// 系统消息列表
  static List<SystemDetailInfo> allSystemInfoList = [
    SystemDetailInfo(
      id: '1',
      content:
          '亲爱的用户您好~2025.07.26 24:00:00-02:00进行安全升级，部分私信功能将无法使用，给您带来不便万分抱歉！感谢您的理解和支持！',
      createTime: DateTime.parse('2025-07-24').millisecondsSinceEpoch,
    ),
    SystemDetailInfo(
      id: '2',
      content:
          '亲爱的用户您好~2025.06.26 24:00:00-02:00进行安全升级，部分私信功能将无法使用，给您带来不便万分抱歉！感谢您的理解和支持！',
      createTime: DateTime.parse('2025-06-17').millisecondsSinceEpoch,
    ),
  ];
}
