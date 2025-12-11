/// 作者-云侧接口响应模型
class AuthorResponse {
  /// 作者id
  String authorId;

  /// 作者昵称
  String authorNickName;

  /// 作者icon
  String authorIcon;

  /// 作者简介
  String authorDesc;

  /// 作者ip
  String authorIp;

  /// 关注的人数
  int watchersCount;

  /// 粉丝数量
  int followersCount;

  /// 获赞数量
  int likeNum;

  /// 关注的人id集合
  List<String>? watchers;

  /// 粉丝id集合
  List<String>? followers;

  /// 手机号
  String? authorPhone;

  AuthorResponse({
    required this.authorId,
    required this.authorNickName,
    required this.authorIcon,
    required this.authorDesc,
    required this.authorIp,
    required this.watchersCount,
    required this.followersCount,
    required this.likeNum,
    this.watchers,
    this.followers,
    this.authorPhone,
  });

  factory AuthorResponse.fromJson(Map<String, dynamic> json) {
    return AuthorResponse(
      authorId: json['authorId'] as String,
      authorNickName: json['authorNickName'] as String,
      authorIcon: json['authorIcon'] as String,
      authorDesc: json['authorDesc'] as String,
      authorIp: json['authorIp'] as String,
      watchersCount:
          json['watchersCount'] != null ? json['watchersCount'] as int : 0,
      followersCount:
          json['followersCount'] != null ? json['followersCount'] as int : 0,
      likeNum: json['likeNum'] as int,
      watchers: json['watchers'] != null
          ? List<String>.from(json['watchers'] as List<dynamic>)
          : null,
      followers: json['followers'] != null
          ? List<String>.from(json['followers'] as List<dynamic>)
          : null,
      authorPhone: json['authorPhone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorNickName': authorNickName,
      'authorIcon': authorIcon,
      'authorDesc': authorDesc,
      'authorIp': authorIp,
      'watchersCount': watchersCount,
      'followersCount': followersCount,
      'likeNum': likeNum,
      'watchers': watchers,
      'followers': followers,
      'authorPhone': authorPhone,
    };
  }
}
