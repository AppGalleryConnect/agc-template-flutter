import 'package:flutter/material.dart';
import 'package:lib_common/models/userInfo_model.dart';
import 'package:lib_news_api/params/response/message_response.dart';
import 'package:lib_news_api/database/message_type.dart';
import 'package:lib_news_api/services/message_service.dart';
import 'package:lib_account/services/account_api.dart';
import '../constants/constants.dart';
import '../types/types.dart';

class MessageViewModel extends ChangeNotifier implements MessageObserver {
  List<MineMsgMenuItem> menuInfoList = [];
  late UserInfoModel userInfoModel;

  MessageViewModel() {
    // 获取全局共享的用户信息模型实例
    userInfoModel = AccountApi.getInstance().userInfoModel;
    // 监听登录状态变化
    userInfoModel.addListener(_onLoginStateChanged);
    // 添加为消息服务的观察者
    messageServiceApi.addObserver(this);

    _initializeMenuList();
    queryAllBriefInfo();
    setPopEvent();
  }

  // 登录状态变化处理
  void _onLoginStateChanged() {
    _initializeMenuList();
    // 重新设置pop事件，确保新添加的菜单项有回调
    setPopEvent();
    queryAllBriefInfo();
  }

  void _initializeMenuList() {
    // 根据登录状态过滤消息菜单
    List<MineMsgMenuItem> filteredMenuList = [];

    if (userInfoModel.isLogin) {
      // 已登录：显示所有消息类型
      filteredMenuList = messageMenuList;
    } else {
      // 未登录：只显示系统消息
      filteredMenuList = messageMenuList.where((item) {
        return item.type == MineMsgMenuType.System;
      }).toList();
    }

    // 初始化菜单列表
    menuInfoList = filteredMenuList.map((item) {
      return MineMsgMenuItem(
        type: item.type,
        menuIcon: item.menuIcon,
        menuTitle: item.menuTitle,
        routerName: item.routerName,
        latestNews: '',
        allUnreadCount: 0,
        receiveTime: 0,
      );
    }).toList();
  }

  void queryAllBriefInfo() {
    queryBriefCommentReplyInfo();
    queryBriefMessageInfo();
    queryBriefFanInfo();
    queryBriefSystemInfo();
  }

  void queryBriefCommentReplyInfo() {
    messageServiceApi.queryBriefCommentReply().then((resp) {
      assignValue(MineMsgMenuType.Comment, resp);
    });
  }

  void queryBriefMessageInfo() {
    messageServiceApi.queryBriefIM().then((resp) {
      // 处理BriefIMInfo类型的数据
      assignIMValue(resp);
    });
  }

  void queryBriefFanInfo() {
    messageServiceApi.queryBriefNewFans().then((resp) {
      assignValue(MineMsgMenuType.Fan, resp);
    });
  }

  void queryBriefSystemInfo() {
    messageServiceApi.queryBriefSystemInfo().then((resp) {
      assignValue(MineMsgMenuType.System, resp);
    });
  }

  // 处理BriefMsgInfo类型的数据
  void assignValue(MineMsgMenuType type, BriefMsgInfo value) {
    final menu = menuInfoList.firstWhere((v) => v.type == type,
        orElse: () => MineMsgMenuItem(
            type: MineMsgMenuType.Comment,
            menuIcon: '',
            menuTitle: '',
            routerName: '',
            latestNews: '',
            allUnreadCount: 0,
            receiveTime: 0));
    menu.allUnreadCount = value.allUnreadCount;
    menu.receiveTime = value.receiveTime;
    menu.latestNews = value.latestNews;
    notifyListeners();
  }

  // 专门处理BriefIMInfo类型的数据
  void assignIMValue(BriefIMInfo value) {
    final menu = menuInfoList.firstWhere((v) => v.type == MineMsgMenuType.IM,
        orElse: () => MineMsgMenuItem(
            type: MineMsgMenuType.IM,
            menuIcon: '',
            menuTitle: '',
            routerName: '',
            latestNews: '',
            allUnreadCount: 0,
            receiveTime: 0));
    menu.allUnreadCount = value.allUnreadCount;
    menu.receiveTime = value.receiveTime;
    menu.latestNews = value.latestNews;
    notifyListeners();
  }

  Future<void> setAllRead() async {
    try {
      if (isLogin) {
        await messageServiceApi.setAllRead();
      } else {
        await messageServiceApi.setSystemRead();
      }
      queryAllBriefInfo();
    } catch (e) {
      print('Failed to set all messages read: $e');
    }
  }

  void setPopEvent() {
    for (var v in menuInfoList) {
      if (v.type == MineMsgMenuType.Comment) {
        v.routerOnPop = () {
          queryBriefCommentReplyInfo();
        };
      } else if (v.type == MineMsgMenuType.IM) {
        v.routerOnPop = () {
          queryBriefMessageInfo();
        };
      } else if (v.type == MineMsgMenuType.Fan) {
        v.routerOnPop = () {
          queryBriefFanInfo();
        };
      } else {
        v.routerOnPop = () {
          queryBriefSystemInfo();
        };
      }
    }
  }

  bool get isLogin {
    return userInfoModel.isLogin;
  }

  bool get allowClean {
    return menuInfoList.any((v) => v.allUnreadCount != 0);
  }

  @override
  void dispose() {
    // 移除观察者，避免内存泄漏
    messageServiceApi.removeObserver(this);
    super.dispose();
  }

  @override
  void onMessageUpdated(MessageUpdateType type) {
    // 根据消息更新类型刷新相应的消息信息
    if (type == MessageUpdateType.Comment || type == MessageUpdateType.All) {
      queryBriefCommentReplyInfo();
    } else if (type == MessageUpdateType.IM || type == MessageUpdateType.All) {
      queryBriefMessageInfo();
    } else if (type == MessageUpdateType.Fan || type == MessageUpdateType.All) {
      queryBriefFanInfo();
    } else if (type == MessageUpdateType.System ||
        type == MessageUpdateType.All) {
      queryBriefSystemInfo();
    }
  }
}
