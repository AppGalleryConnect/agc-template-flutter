import 'author_response.dart';

/// 简要消息信息类
class BriefMsgInfo {
  /// 所有未读消息数量
  int allUnreadCount;

  /// 接收时间
  int receiveTime;

  /// 最新消息内容
  String latestNews;

  BriefMsgInfo({
    required this.allUnreadCount,
    required this.receiveTime,
    required this.latestNews,
  });

  factory BriefMsgInfo.fromJson(Map<String, dynamic> json) {
    return BriefMsgInfo(
      allUnreadCount: json['allUnreadCount'] as int,
      receiveTime: json['receiveTime'] as int,
      latestNews: json['latestNews'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allUnreadCount': allUnreadCount,
      'receiveTime': receiveTime,
      'latestNews': latestNews,
    };
  }
}

/// 简要即时通讯响应类
class BriefIMResponse {
  /// 聊天作者信息
  final AuthorResponse chatAuthor;

  /// 所有未读消息数量
  final int allUnreadCount;

  /// 接收时间
  final int receiveTime;

  /// 最新消息内容
  final String latestNews;

  /// 聊天列表
  final List<ChatInfoDetailResponse> chatList;

  /// 创建一个BriefIMResponse实例
  const BriefIMResponse({
    required this.chatAuthor,
    required this.allUnreadCount,
    required this.receiveTime,
    required this.latestNews,
    required this.chatList,
  });

  /// 从JSON数据创建BriefIMResponse实例
  factory BriefIMResponse.fromJson(Map<String, dynamic> json) {
    return BriefIMResponse(
      chatAuthor:
          AuthorResponse.fromJson(json['chatAuthor'] as Map<String, dynamic>),
      allUnreadCount: json['allUnreadCount'] as int,
      receiveTime: json['receiveTime'] as int,
      latestNews: json['latestNews'] as String,
      chatList: (json['chatList'] as List<dynamic>)
          .map(
              (e) => ChatInfoDetailResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 转换为JSON格式
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

/// 聊天信息详情响应类
class ChatInfoDetailResponse {
  /// 消息类型
  final String type;

  /// 消息内容
  final String content;

  /// 是否是自己发送的消息（可选）
  final bool? isMyself;

  /// 创建时间（可选）
  final int? createTime;

  /// 创建一个ChatInfoDetailResponse实例
  const ChatInfoDetailResponse({
    required this.type,
    required this.content,
    this.isMyself,
    this.createTime,
  });

  /// 从JSON数据创建ChatInfoDetailResponse实例
  factory ChatInfoDetailResponse.fromJson(Map<String, dynamic> json) {
    return ChatInfoDetailResponse(
      type: json['type'] as String,
      content: json['content'] as String,
      isMyself: json['isMyself'] as bool?,
      createTime: json['createTime'] as int?,
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'isMyself': isMyself,
      'createTime': createTime,
    };
  }
}

/// 系统详情信息类
class SystemDetailInfo {
  /// 消息id
  final String id;

  /// 消息内容
  final String content;

  /// 创建时间
  final int createTime;

  /// 创建一个SystemDetailInfo实例
  const SystemDetailInfo({
    required this.id,
    required this.content,
    required this.createTime,
  });

  /// 从JSON数据创建SystemDetailInfo实例
  factory SystemDetailInfo.fromJson(Map<String, dynamic> json) {
    return SystemDetailInfo(
      id: json['id'] as String,
      content: json['content'] as String,
      createTime: json['createTime'] as int,
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createTime': createTime,
    };
  }
}
