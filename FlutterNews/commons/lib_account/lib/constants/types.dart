import '../constants/constants.dart';

/// 跳转登录路由参数
class LoginRouterParams {
  final bool? isSheet;
  final bool? keepVM;
  late bool isHalfModal;

  LoginRouterParams({
    this.isSheet,
    this.keepVM,
    this.isHalfModal = false,
  });
}

/// 登录半模态弹窗参数
class LoginSheetParams {
  double height = Constants.DEFAULT_LOGIN_SHEET_HEIGHT;
  LoginSheetParams({double? height}) {
    if (height != null) {
      this.height = height;
    }
  }
}
