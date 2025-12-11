import 'package:flutter/material.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/models/userInfo_model.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_account/services/account_api.dart';
import '../constants/constants.dart';
import '../types/types.dart';

class MineViewModel extends ChangeNotifier {
  List<MineGridItem> get serviceList => [
        const MineGridItemImpl(
          icon: 'packages/business_mine/assets/ic_public_history.svg',
          label: '浏览历史',
          routerName: '/mine/history',
        ),
        MineGridItemImpl(
          icon: 'packages/business_mine/assets/ic_public_edit.svg',
          label: '意见反馈',
          routerName: RouterMap.FEEDBACK_MANAGE_PAGE,
        ),
        const MineGridItemImpl(
          icon: 'packages/business_mine/assets/ic_public_setting.svg',
          label: '设置',
          routerName: RouterMap.SETTING_PAGE,
        ),
      ];

  WindowModel windowModel = WindowModel();
  UserInfoModel get userInfoModel => AccountApi.getInstance().userInfoModel;

  MineViewModel() {
    // 统一使用_onUserInfoChanged方法进行监听，避免重复代码
    userInfoModel.addListener(_onUserInfoChanged);
  }

  void jumpLogin({bool useHalfModal = false}) {
    if (useHalfModal) {
      // 使用半模态样式打开登录页面
      // 通过参数标记为半模态模式
      RouterUtils.of
          .pushPathByName('/huawei_login_page', param: {'isHalfModal': true});
    } else {
      // 保持原有的跳转方式
      RouterUtils.of.pushPathByName('/huawei_login_page');
    }
  }

  void jumpProfile() {
    RouterUtils.of.pushPathByName('/profile_home');
  }

  void gridClick(MineGridItem v) {
    // 需要登录才能访问的功能
    List<String> needLoginRoutes = [
      '/mine/comment',
      '/mine/mark',
      '/mine/like'
    ];

    // 检查是否需要登录且当前未登录
    if (needLoginRoutes.contains(v.routerName) && !userInfoModel.isLogin) {
      // 未登录则跳转到登录页面，使用半模态样式
      jumpLogin(useHalfModal: true);
      return;
    }

    if (v.routerName.isNotEmpty) {
      RouterUtils.of.pushPathByName(v.routerName);
    }
  }

  String get userIcon {
    return userInfoModel.authorIcon;
  }

  // 专门的用户信息变化处理方法
  void _onUserInfoChanged() {
    notifyListeners();
  }

  // 确保在VM销毁时移除监听器，防止内存泄漏
  @override
  void dispose() {
    userInfoModel.removeListener(_onUserInfoChanged);
    super.dispose();
  }
}

class WindowModel {
  double get windowTopPadding => 0.0;
  double get windowBottomPadding => 0.0;
}
