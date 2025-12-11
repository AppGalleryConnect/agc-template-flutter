/// 用户数据库字段模型
class BaseAuthor {
  /// 作者唯一标识符
  String authorId;

  /// 作者昵称
  String authorNickName;

  /// 作者头像URL
  String authorIcon;

  /// 作者简介
  String authorDesc;

  /// 手机号（可选）
  String? authorPhone;

  /// 作者IP地址
  String authorIp;

  /// 关注的人ID列表
  List<String> watchers;

  /// 粉丝ID列表
  List<String> followers;

  /// 获赞数量
  int likeNum;

  /// 关注数量
  int? watchersCount;

  /// 粉丝数量
  int? followersCount;

  /// 作者基础信息模型
  BaseAuthor({
    required this.authorId,
    required this.authorNickName,
    required this.authorIcon,
    required this.authorDesc,
    required this.authorIp,
    required this.watchers,
    required this.followers,
    required this.likeNum,
    this.authorPhone,
    this.watchersCount,
    this.followersCount,
  });

  factory BaseAuthor.fromJson(Map<String, dynamic> json) {
    return BaseAuthor(
      authorId: json['authorId'],
      authorNickName: json['authorNickName'],
      authorIcon: json['authorIcon'],
      authorDesc: json['authorDesc'],
      authorIp: json['authorIp'],
      watchers: json['watchers'] ?? [],
      followers: json['followers'] ?? [],
      likeNum: json['likeNum'] ?? 0,
      authorPhone: json['authorPhone'],
      watchersCount:
          json['watchersCount'] ?? (json['watchers'] as List?)?.length ?? 0,
      followersCount:
          json['followersCount'] ?? (json['followers'] as List?)?.length ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorNickName': authorNickName,
      'authorIcon': authorIcon,
      'authorDesc': authorDesc,
      'authorIp': authorIp,
      'watchers': watchers,
      'followers': followers,
      'likeNum': likeNum,
      'authorPhone': authorPhone,
      'watchersCount': watchersCount ?? watchers.length,
      'followersCount': followersCount ?? followers.length,
    };
  }
}

/// 本人数据库字段模型
class MyAuthor extends BaseAuthor {
  /// 我的点赞列表（新闻ID）
  List<String> myLikes;

  /// 我的收藏列表（新闻ID）
  List<String> myMarks;

  /// 我的评论列表（评论ID）
  List<String> myComments;

  /// 阅读历史列表（新闻ID）
  List<String> myHistory;

  /// 我的作者模型
  MyAuthor({
    required super.authorId,
    required super.authorNickName,
    required super.authorIcon,
    required super.authorDesc,
    required super.authorIp,
    required super.watchers,
    required super.followers,
    required super.likeNum,
    required this.myLikes,
    required this.myMarks,
    required this.myComments,
    required this.myHistory,
    super.authorPhone,
  });

  factory MyAuthor.fromJson(Map<String, dynamic> json) {
    return MyAuthor(
      authorId: json['authorId'],
      authorNickName: json['authorNickName'],
      authorIcon: json['authorIcon'],
      authorDesc: json['authorDesc'],
      authorIp: json['authorIp'],
      watchers: json['watchers'],
      followers: json['followers'],
      likeNum: json['likeNum'],
      myLikes: json['myLikes'],
      myMarks: json['myMarks'],
      myComments: json['myComments'],
      myHistory: json['myHistory'],
      authorPhone: json['authorPhone'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorNickName': authorNickName,
      'authorIcon': authorIcon,
      'authorDesc': authorDesc,
      'authorIp': authorIp,
      'watchers': watchers,
      'followers': followers,
      'likeNum': likeNum,
      'myLikes': myLikes,
      'myMarks': myMarks,
      'myComments': myComments,
      'myHistory': myHistory,
      'authorPhone': authorPhone,
    };
  }
}
