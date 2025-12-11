import 'package:flutter/material.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/constants/router_map.dart';

/// 统一登录全屏页面工具类
class LoginSheetUtils {
  /// 登录全屏页面（半模态）
  static void open(BuildContext context) {
    RouterUtils.of.pushPathByName(
      RouterMap.HUAWEI_LOGIN_PAGE,
      param: {
        'isHalfModal': true,
      },
    );
  }

  static void showLoginSheet(BuildContext context) {
    RouterUtils.of
        .pushPathByName('/huawei_login_page', param: {'isHalfModal': true});
  }
}

/// 登录页面参数
class LoginSheetParams {
  double height = 600;
}
