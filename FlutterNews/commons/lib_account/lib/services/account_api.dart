import 'package:lib_common/models/userInfo_model.dart';
import 'package:lib_common/utils/storage_utils.dart';
import 'package:lib_news_api/services/author_service.dart';

class AccountApi {
  static AccountApi? _instance;
  late final UserInfoModel userInfoModel;

  // 私有构造函数
  AccountApi._internal() {
    userInfoModel = StorageUtils.connect(
      create: () => UserInfoModel(),
      type: StorageType.persistence,
    );
  }

  // 获取单例实例
  static AccountApi getInstance() {
    _instance ??= AccountApi._internal();
    return _instance!;
  }

  // 查询用户信息方法
  UserInfoModel queryUserInfo() {
    if (userInfoModel.isLogin) {}
    return userInfoModel;
  }

  /// 华为账号登录
  Future<bool> huaweiLogin() async {
    try {
      await Future.microtask(() {});

      final authorInfo = authorServiceApi.signIn('huawei');

      if (authorInfo != null) {
        // 使用author_service的数据设置userInfoModel
        userInfoModel.authorId = authorInfo.authorId;
        userInfoModel.authorNickName = authorInfo.authorNickName;
        userInfoModel.authorIcon = authorInfo.authorIcon;
        userInfoModel.authorDesc = authorInfo.authorDesc;
        userInfoModel.authorPhone = authorInfo.authorPhone ?? '177******96';
        userInfoModel.authorIp = '南京';
        userInfoModel.likeNum = authorInfo.likeNum;
        userInfoModel.isLogin = true;
        userInfoModel.loginChannel = 'huawei';
        if (authorInfo.watchers != null && authorInfo.watchers!.isNotEmpty) {
          for (var watcherId in authorInfo.watchers!) {
            userInfoModel.addWatcher(watcherId);
          }
        } else {
          final defaultWatchers = [
            'author_1',
            'author_2',
            'author_6',
            'author_7'
          ];
          for (var id in defaultWatchers) {
            userInfoModel.addWatcher(id);
          }
        }

        // 添加粉丝列表初始化
        if (authorInfo.followers != null && authorInfo.followers!.isNotEmpty) {
          for (var followerId in authorInfo.followers!) {
            userInfoModel.addFollower(followerId);
          }
        } else {
          final defaultFollowers = [
            'author_1',
            'author_2',
            'author_3',
            'author_4',
            'author_5'
          ];
          for (var id in defaultFollowers) {
            userInfoModel.addFollower(id);
          }
        }

        userInfoModel.notifyListeners();
        return true;
      }

      _setDefaultUserInfo('huawei');
      return true;
    } catch (e) {
      _setDefaultUserInfo('huawei');
      return true;
    }
  }

  /// 账密登录
  Future<bool> accountPasswordLogin(String account, String password) async {
    try {
      await Future.microtask(() {});

      final authorInfo = authorServiceApi.signIn('password', null);

      if (authorInfo != null) {
        userInfoModel.authorId = authorInfo.authorId;
        userInfoModel.authorNickName = authorInfo.authorNickName;
        userInfoModel.authorIcon = authorInfo.authorIcon;
        userInfoModel.authorDesc = authorInfo.authorDesc;
        userInfoModel.authorPhone = '177******96';
        userInfoModel.authorIp = '南京';
        userInfoModel.likeNum = authorInfo.likeNum;
        userInfoModel.isLogin = true;
        userInfoModel.loginChannel = 'password';
        if (authorInfo.watchers != null && authorInfo.watchers!.isNotEmpty) {
          for (var watcherId in authorInfo.watchers!) {
            userInfoModel.addWatcher(watcherId);
          }
        } else {
          final defaultWatchers = [
            'author_1',
            'author_2',
            'author_6',
            'author_7'
          ];
          for (var id in defaultWatchers) {
            userInfoModel.addWatcher(id);
          }
        }

        // 添加粉丝列表初始化
        if (authorInfo.followers != null && authorInfo.followers!.isNotEmpty) {
          for (var followerId in authorInfo.followers!) {
            userInfoModel.addFollower(followerId);
          }
        } else {
          final defaultFollowers = [
            'author_1',
            'author_2',
            'author_3',
            'author_4',
            'author_5'
          ];
          for (var id in defaultFollowers) {
            userInfoModel.addFollower(id);
          }
        }

        // 通知监听器数据已更新
        userInfoModel.notifyListeners();
        return true;
      } else {
        _setDefaultUserInfo('password');
        return true;
      }
    } catch (e) {
      _setDefaultUserInfo('password');
      return true;
    }
  }

  /// 设置默认用户信息
  void _setDefaultUserInfo(String channel) {
    userInfoModel.authorId = '001';
    userInfoModel.authorNickName = channel == 'password' ? '测试用户' : '华为用户';
    userInfoModel.authorIcon =
        'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/avatar%2Favatar_12.jpg';
    userInfoModel.authorDesc = '在自己的小世界里，做一个快乐的普通人，把节奏放慢，享受生活！';
    userInfoModel.authorPhone = '177******96';
    userInfoModel.authorIp = '南京';
    userInfoModel.likeNum = 12;
    userInfoModel.isLogin = true;
    userInfoModel.loginChannel = channel;
    try {
      final defaultWatchers = ['author_1', 'author_2', 'author_6', 'author_7'];
      for (var id in defaultWatchers) {
        userInfoModel.addWatcher(id);
      }

      final defaultFollowers = [
        'author_1',
        'author_2',
        'author_3',
        'author_4',
        'author_5'
      ];
      for (var id in defaultFollowers) {
        userInfoModel.addFollower(id);
      }
    } catch (e) {
      // 捕获任何可能的异常
    }

    userInfoModel.notifyListeners();
  }

  /// 处理用户信息
  void handleUserInfo(dynamic user) {
    // 处理用户信息的逻辑
  }

  // 退出登录方法
  void logout() {
    userInfoModel.isLogin = false;
    userInfoModel.authorId = '';
    userInfoModel.authorNickName = '';
    userInfoModel.authorIcon = '';
    userInfoModel.authorDesc = '';
    userInfoModel.notifyListeners();
  }
}
