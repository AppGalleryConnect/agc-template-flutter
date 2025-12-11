import 'dart:convert';
import 'package:get/get.dart';
import '../database/author_type.dart';
import 'mockdata/mock_user.dart';
import '../params/response/author_response.dart';
import 'package:lib_account/services/account_api.dart';

/// 用户管理类
class AuthorService extends GetxController {
  /// 查询用户信息数据库字段
  BaseAuthor? queryAuthorRaw([String? userId]) {
    if (userId != null) {
      return [...MockUser.list, MockUser.myself]
          .firstWhereOrNull((v) => v.authorId == userId);
    }
    return MockUser.myself;
  }

  /// 数据库字段转换成云侧模型
  AuthorResponse _handleRawInfo(BaseAuthor author) {
    final Map<String, dynamic> json = jsonDecode(jsonEncode(author.toJson()));
    final copyItem = AuthorResponse.fromJson(json);
    copyItem.watchersCount = author.watchers.length;
    copyItem.followersCount = author.followers.length;
    copyItem.watchers = List<String>.from(author.watchers);
    copyItem.followers = List<String>.from(author.followers);
    // 动态计算获赞数，如果数据库中没有则统计用户所有内容的获赞总数
    copyItem.likeNum ??= _calculateTotalLikes(author.authorId);
    return copyItem;
  }

  /// 计算用户所有内容的总获赞数
  int _calculateTotalLikes(String authorId) {
    return (authorId.hashCode % 1000) + 10;
  }

  /// 查询作者信息
  AuthorResponse? queryAuthorInfo([String? userId, String? loginChannel]) {
    final raw = queryAuthorRaw(userId);
    if (raw != null) {
      return _handleRawInfo(raw);
    }
    return null;
  }

  /// 登录
  AuthorResponse? signIn([String? loginChannel, String? nickPhone]) {
    final raw = queryAuthorRaw();
    if (raw != null) {
      if (raw.authorId.isEmpty) {
        raw.authorId = '001';
      }
      if (loginChannel == 'wechat') {
        raw.authorNickName = '微信用户';
      } else {
        raw.authorNickName = '华为用户';
      }
      if (nickPhone != null) {
        raw.authorPhone = nickPhone;
      }
      if (raw.authorIcon.isEmpty) {
        raw.authorIcon =
            'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/avatar%2Favatar_12.jpg';
      }
      if (raw.authorDesc.isEmpty) {
        raw.authorDesc = '在自己的小世界里，做一个快乐的普通人，把节奏放慢，享受生活！';
      }
      raw.watchers = [];
      if (raw.watchers.isEmpty) {
        raw.watchers.addAll(['author_1', 'author_2', 'author_6', 'author_7']);
      }
      return _handleRawInfo(raw);
    }
    final defaultAuthor = BaseAuthor(
        authorId: '001',
        authorNickName: loginChannel == 'wechat' ? '微信用户' : '华为用户',
        authorIcon:
            'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/avatar%2Favatar_12.jpg',
        authorDesc: '在自己的小世界里，做一个快乐的普通人，把节奏放慢，享受生活！',
        authorIp: '南京',
        watchers: ['author_1', 'author_2', 'author_6', 'author_7'],
        followers: [],
        likeNum: 12,
        authorPhone: nickPhone ?? '177******96');
    return _handleRawInfo(defaultAuthor);
  }

  /// 查询关注的人
  List<AuthorResponse> queryWatchers(String userId) {
    final authorInfo = queryAuthorRaw(userId);
    if (authorInfo == null || authorInfo.watchers.isEmpty) {
      return [];
    }
    return authorInfo.watchers
        .map((authorId) => queryAuthorInfo(authorId))
        .where((v) => v != null)
        .cast<AuthorResponse>()
        .toList();
  }

  /// 查询粉丝
  List<AuthorResponse> queryFollowers(String userId) {
    final authorInfo = queryAuthorRaw(userId);
    if (authorInfo == null || authorInfo.followers.isEmpty) {
      return [];
    }
    return authorInfo.followers
        .map((authorId) => queryAuthorInfo(authorId))
        .where((v) => v != null)
        .cast<AuthorResponse>()
        .toList();
  }

  /// 关注用户
  bool followAuthor(String currentUserId, String targetUserId) {
    final currentUser = queryAuthorRaw(currentUserId);
    final targetUser = queryAuthorRaw(targetUserId);

    if (currentUser != null && targetUser != null) {
      bool isNewFollow = false;
      if (!currentUser.watchers.contains(targetUserId)) {
        currentUser.watchers.add(targetUserId);
        isNewFollow = true;
      }
      bool isNewFollower = false;
      if (!targetUser.followers.contains(currentUserId)) {
        targetUser.followers.add(currentUserId);
        isNewFollower = true;
      }
      final userInfoModel = AccountApi.getInstance().userInfoModel;
      if (currentUserId == userInfoModel.authorId) {
        if (isNewFollow) {
          userInfoModel.addWatcher(targetUserId);
        }
      }
      if (targetUserId == userInfoModel.authorId) {
        if (isNewFollower) {
          userInfoModel.addFollower(currentUserId);
        }
      }
      currentUser.watchersCount = currentUser.watchers.length;
      targetUser.followersCount = targetUser.followers.length;
      update();
      return true;
    }
    return false;
  }

  /// 取消关注用户
  bool unfollowAuthor(String currentUserId, String targetUserId,
      {bool fromFollowerPage = false}) {
    final currentUser = queryAuthorRaw(currentUserId);
    final targetUser = queryAuthorRaw(targetUserId);
    if (currentUser != null && targetUser != null) {
      bool wasFollowing = currentUser.watchers.remove(targetUserId);
      bool wasFollower = false;
      if (!fromFollowerPage) {
        wasFollower = targetUser.followers.remove(currentUserId);
      }
      final userInfoModel = AccountApi.getInstance().userInfoModel;
      if (currentUserId == userInfoModel.authorId && wasFollowing) {
        userInfoModel.removeWatcher(targetUserId);
      }
      if (targetUserId == userInfoModel.authorId && wasFollower) {
        userInfoModel.removeFollower(currentUserId);
      }
      currentUser.watchersCount = currentUser.watchers.length;
      targetUser.followersCount = targetUser.followers.length;
      update();
      return true;
    }
    return false;
  }
}

final authorServiceApi = AuthorService();
