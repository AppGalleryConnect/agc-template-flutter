import '../constants/constants.dart';

/// 简要即时消息信息类
class BriefIMInfo {
  /// 聊天作者ID
  final String chatAuthorId;

  /// 所有未读消息数量
  int allUnreadCount; // 已改为非final

  /// 接收时间戳
  int receiveTime; // 从final改为普通属性

  /// 最新消息内容
  String latestNews; // 从final改为普通属性

  /// 聊天详情列表
  final List<ChatInfoDetail> chatList;

  /// BriefIMInfo构造函数
  BriefIMInfo({
    required this.chatAuthorId,
    required this.allUnreadCount,
    required this.receiveTime,
    required this.latestNews,
    required this.chatList,
  });
}

/// 聊天信息详情类
class ChatInfoDetail {
  /// 消息类型
  final ChatEnum type;

  /// 消息内容
  final String content;

  /// 是否为自己发送的消息（可选）
  final bool? isMyself;

  /// 消息创建时间戳（可选）
  final int? createTime;

  /// ChatInfoDetail构造函数
  const ChatInfoDetail({
    required this.type,
    required this.content,
    this.isMyself,
    this.createTime,
  });
}
