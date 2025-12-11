import 'package:flutter/foundation.dart';

/// 用户信息模型
class UserInfoModel with ChangeNotifier {
  /// 是否登录
  bool _isLogin = false;

  /// 用户ID
  String _authorId = '';

  /// 用户昵称
  String _authorNickName = '';

  /// 用户头像
  String _authorIcon = '';

  /// 用户简介
  String _authorDesc = '';

  /// 用户手机号
  String _authorPhone = '';

  /// 用户IP地址
  String _authorIp = '';

  /// 关注者数量
  int _watchersCount = 0;

  /// 粉丝数量
  int _followersCount = 0;

  /// 关注列表
  final List<String> _watchers = [];

  /// 粉丝列表
  final List<String> _followers = [];

  /// 获赞数量
  int _likeNum = 0;

  /// 登录渠道
  String _loginChannel = '';

  bool get isLogin => _isLogin;
  String get authorId => _authorId;
  String get authorNickName => _authorNickName;
  String get authorIcon => _authorIcon;
  String get authorDesc => _authorDesc;
  String get authorPhone => _authorPhone;
  String get authorIp => _authorIp;
  int get watchersCount => _watchersCount;
  int get followersCount => _followersCount;
  List<String> get watchers => List.unmodifiable(_watchers);
  List<String> get followers => List.unmodifiable(_followers);
  int get likeNum => _likeNum;
  String get loginChannel => _loginChannel;

  set isLogin(bool value) {
    if (_isLogin != value) {
      _isLogin = value;
      notifyListeners();
    }
  }

  set authorId(String value) {
    if (_authorId != value) {
      _authorId = value;
      notifyListeners();
    }
  }

  set authorNickName(String value) {
    if (_authorNickName != value) {
      _authorNickName = value;
      notifyListeners();
    }
  }

  set authorIcon(String value) {
    if (_authorIcon != value) {
      _authorIcon = value;
      notifyListeners();
    }
  }

  set authorDesc(String value) {
    if (_authorDesc != value) {
      _authorDesc = value;
      notifyListeners();
    }
  }

  set authorPhone(String value) {
    if (_authorPhone != value) {
      _authorPhone = value;
      notifyListeners();
    }
  }

  set authorIp(String value) {
    if (_authorIp != value) {
      _authorIp = value;
      notifyListeners();
    }
  }

  set watchersCount(int value) {
    if (_watchersCount != value) {
      _watchersCount = value;
      notifyListeners();
    }
  }

  set followersCount(int value) {
    if (_followersCount != value) {
      _followersCount = value;
      notifyListeners();
    }
  }

  /// 添加关注用户
  void addWatcher(String userId) {
    if (!_watchers.contains(userId)) {
      _watchers.add(userId);
      watchersCount = _watchers.length;
      notifyListeners();
    }
  }

  /// 移除关注用户
  void removeWatcher(String userId) {
    if (_watchers.contains(userId)) {
      _watchers.remove(userId);
      watchersCount = _watchers.length;
      notifyListeners();
    }
  }

  /// 添加粉丝
  void addFollower(String userId) {
    if (!_followers.contains(userId)) {
      _followers.add(userId);
      followersCount = _followers.length;
      notifyListeners();
    }
  }

  /// 移除粉丝
  void removeFollower(String userId) {
    if (_followers.contains(userId)) {
      _followers.remove(userId);
      followersCount = _followers.length;
      notifyListeners();
    }
  }

  set likeNum(int value) {
    if (_likeNum != value) {
      _likeNum = value;
      notifyListeners();
    }
  }

  set loginChannel(String value) {
    if (_loginChannel != value) {
      _loginChannel = value;
      notifyListeners();
    }
  }

  /// 清空用户信息
  void clearUserInfo() {
    _isLogin = false;
    _authorId = '';
    _authorNickName = '';
    _authorIcon = '';
    _authorDesc = '';
    _authorPhone = '';
    _authorIp = '';
    _watchersCount = 0;
    _followersCount = 0;
    _watchers.clear();
    _followers.clear();
    _likeNum = 0;
    _loginChannel = '';
    notifyListeners();
  }
}
