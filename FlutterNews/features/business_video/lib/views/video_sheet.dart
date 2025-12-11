import 'package:flutter/material.dart';
import 'package:module_share/model/share_model.dart';
import 'package:module_share/module_share.dart';
import 'package:lib_common/utils/router_utils.dart';

class VideoSheet {
  static void showLoginSheet(BuildContext context) {
    RouterUtils.of
        .pushPathByName('/huawei_login_page', param: {'isHalfModal': true});
  }

  static void showShareSheet(BuildContext context, String title) {
    final ShareOptions shareOptions = ShareOptions(
      id: 'test_123',
      title: title,
      articleFrom: '测试来源',
    );
    Share.show(context, shareOptions, title);
  }
}
