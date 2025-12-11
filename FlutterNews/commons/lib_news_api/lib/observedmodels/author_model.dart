import 'package:flutter/foundation.dart';
import 'package:lib_account/services/account_api.dart';
import '../params/response/author_response.dart';

/// 作者信息模型类
class AuthorModel with ChangeNotifier implements AuthorResponse {
  /// 临时标记：用于在特定页面（如关注列表页）强制设置关注状态
  bool? _forceWatchStatus;

  /// 作者唯一标识符
  @override
  String authorId;

  /// 作者昵称
  @override
  String authorNickName;

  /// 作者头像URL
  @override
  String authorIcon;

  /// 作者个人描述
  @override
  String authorDesc;

  /// 作者IP地址
  @override
  String authorIp;

  /// 关注者数量
  @override
  int watchersCount;

  /// 粉丝数量
  @override
  int followersCount;

  /// 获得的点赞数
  @override
  int likeNum;

  /// 关注者ID列表
  @override
  List<String>? watchers;

  /// 粉丝ID列表
  @override
  List<String>? followers;

  /// 作者手机号码
  @override
  String? authorPhone;

  @override
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

  AuthorModel(AuthorResponse v)
      : authorId = v.authorId,
        authorNickName = v.authorNickName,
        authorPhone = v.authorPhone ?? '',
        authorIcon = v.authorIcon,
        authorDesc = v.authorDesc,
        authorIp = v.authorIp,
        watchersCount = v.watchersCount,
        followersCount = v.followersCount,
        likeNum = v.likeNum,
        watchers = v.watchers ?? [],
        followers = v.followers ?? [];

  void updateInfo(AuthorResponse v) {
    authorId = v.authorId;
    authorNickName = v.authorNickName;
    authorPhone = v.authorPhone ?? '';
    authorIcon = v.authorIcon;
    authorDesc = v.authorDesc;
    authorIp = v.authorIp;
    watchersCount = v.watchersCount;
    followersCount = v.followersCount;
    likeNum = v.likeNum;
    watchers = v.watchers ?? [];
    followers = v.followers ?? [];
    notifyListeners();
  }

  /// 更新关注者数量
  void updateWatchersCount(int count) {
    watchersCount = count;
    notifyListeners();
  }

  /// 更新粉丝数量
  void updateFollowersCount(int count) {
    followersCount = count;
    notifyListeners();
  }

  /// 更新点赞数量
  void updateLikeNum(int count) {
    likeNum = count;
    notifyListeners();
  }

  /// 判断当前用户是否关注了该作者
  bool get isWatchByMe {
    if (_forceWatchStatus != null) {
      return _forceWatchStatus!;
    }
    final userInfoModel = AccountApi.getInstance().userInfoModel;
    if (!userInfoModel.isLogin || userInfoModel.authorId.isEmpty) {
      return false;
    }
    return userInfoModel.watchers.contains(authorId);
  }

  void setForceWatchStatus(bool isWatched) {
    _forceWatchStatus = isWatched;
  }

  /// 判断该作者是否关注了当前用户
  bool get isWatchByHim {
    final userInfoModel = AccountApi.getInstance().userInfoModel;
    if (!userInfoModel.isLogin || userInfoModel.authorId.isEmpty) {
      return false;
    }
    return (watchers?.contains(userInfoModel.authorId)) ?? false;
  }

  /// 判断是否互相关注
  bool get isMutualFollow {
    return isWatchByMe && isWatchByHim;
  }

  /// 快速判断关注状态，用于UI显示优化
  String get followStatusText {
    if (isMutualFollow) return '互相关注';
    if (isWatchByMe) return '已关注';
    if (isWatchByHim) return '回关';
    return '关注';
  }
}
