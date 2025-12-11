import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/utils/global_context.dart';
import 'package:module_newsfeed/components/native_navigation_utils.dart';
import '../constants/Constants.dart';
import '../constants/Types.dart';
import '../services/account_api.dart';
import '../constants/error_code.dart';
import '../services/mockdata/protocol_data.dart';
import '../pages/other_login_page.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart';

class LoginVM extends ChangeNotifier {
  static const String TAG = Constants.TAG_LOGIN_VM;
  String anonymousPhone = Constants.ANONYMOUS_PHONE;
  bool isAgreePrivacy = false;
  String userProtocolInfo = '';
  String privacyInfo = '';
  String huaweiUserProtocolInfo = '';
  bool isSheet = false;
  bool isHalfModal = false;
  late AccountApi accountInstance;
  late WindowModel windowModel;

  String accountInput = '';
  String passwordInput = '';

  static LoginVM? _instance;

  factory LoginVM.getInstance([bool reCreate = false]) {
    if (_instance == null || reCreate) {
      _instance = LoginVM._internal();
    }
    return _instance!;
  }

  static void clearInstance() {
    _instance = null;
  }

  LoginVM._internal() {
    accountInstance = AccountApi.getInstance();
    queryAnonymousPhone();
    queryProtocol();
    windowModel = WindowModel();
  }

  void resetInput() {
    accountInput = '';
    passwordInput = '';
    agreePrivacyChange(false);
  }

  void agreePrivacyChange(bool value) {
    isAgreePrivacy = value;
    notifyListeners();
  }

  void handleHuaweiLoginFail(dynamic error) {
    if (error.code == ErrorCode.ERROR_CODE_AGREEMENT_STATUS_NOT_ACCEPTED) {
      agreePrivacyChange(false);
      showToast(Constants.TOAST_AGREE_PROTOCOL);
    } else {
      String errorMsg = '';
      if (error.code == ErrorCode.ERROR_CODE_LOGIN_OUT) {
        errorMsg = Constants.TOAST_HUAWEI_NOT_LOGIN;
      } else if (error.code == ErrorCode.ERROR_CODE_INVALID_PARAM) {
        errorMsg = Constants.TOAST_INVALID_CLIENT_ID;
      } else if (error.code == ErrorCode.ERROR_CODE_NOT_SCOPE) {
        errorMsg = Constants.TOAST_NOT_SCOPE;
      } else {
        errorMsg = Constants.TOAST_OTHER_ERROR;
      }

      showToast(errorMsg);
    }
  }

  Future<void> huaweiLogin() async {
    if (!isAgreePrivacy) {
      showToast(Constants.TOAST_AGREE_PROTOCOL);
      return;
    }

    try {
      await _doHuaweiLogin();
    } catch (e) {
      showToast(Constants.TOAST_LOGIN_ERROR);
    }
  }

  Future<void> _doHuaweiLogin() async {
    try {
      await Future.microtask(() {});

      await accountInstance.huaweiLogin();

      await Future.microtask(() {
        showToast(Constants.TOAST_LOGIN_SUCCESS);
      });

      await Future.delayed(const Duration(milliseconds: 300));
      handleClose();
    } catch (e) {
      showToast(Constants.TOAST_LOGIN_ERROR);
    }
  }

  void jumpOtherLogin() {
    try {
      Navigator.of(GlobalContext.context).pushReplacement(
        PageRouteBuilder(
          opaque: !isHalfModal,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) {
            Widget content = otherLoginPageBuilder(context,
                params: LoginRouterParams(
                  isSheet: isSheet,
                  isHalfModal: isHalfModal,
                ));

            if (isHalfModal) {
              content = Stack(
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  content,
                ],
              );
            }

            return content;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      showToast(Constants.TOAST_JUMP_ERROR);
    }
  }

  void handleClose() {
    Navigator.of(GlobalContext.context).pop();
  }

  double iconMarginTop() {
    return Constants.ICON_MARGIN_TOP;
  }

  double otherWayMarginTop() {
    return Constants.OTHER_WAY_MARGIN_TOP;
  }

  Color pageBgColor() {
    return Colors.white;
  }

  Widget buildHuaweiLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: Constants.PADDING_40 + CommonConstants.PADDING_S,
      ),
      child: ElevatedButton(
        onPressed: () async {
          await huaweiLogin();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 92, 121, 217),
          minimumSize: const Size(double.infinity, Constants.BTN_HEIGHT),
        ),
        child: const Text(
          Constants.HUAWEI_LOGIN_BUTTON_TEXT,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void queryAnonymousPhone() {
    // 查询匿名手机号的逻辑
  }

  void queryProtocol() {
    try {
      userProtocolInfo = ProtocolData.userProtocol.isNotEmpty
          ? ProtocolData.userProtocol
          : Constants.DEFAULT_USER_PROTOCOL;

      privacyInfo = ProtocolData.privacyProtocol.isNotEmpty
          ? ProtocolData.privacyProtocol
          : Constants.DEFAULT_PRIVACY_PROTOCOL;

      huaweiUserProtocolInfo = ProtocolData.huaweiUserProtocol.isNotEmpty
          ? ProtocolData.huaweiUserProtocol
          : Constants.DEFAULT_HUAWEI_PROTOCOL;

      notifyListeners();
    } catch (e) {
      userProtocolInfo = Constants.DEFAULT_USER_PROTOCOL;
      privacyInfo = Constants.DEFAULT_PRIVACY_PROTOCOL;
      huaweiUserProtocolInfo = Constants.DEFAULT_HUAWEI_PROTOCOL;

      notifyListeners();
    }
  }

  void showToast(String message) {
    CommonToastDialog.show(ToastDialogParams(message: message));
  }

  Future<void> accountPasswordLogin() async {
    if (!isAgreePrivacy) {
      showToast(Constants.TOAST_AGREE_PROTOCOL);
      return;
    }

    if (accountInput.isEmpty) {
      showToast(Constants.TOAST_INPUT_ACCOUNT);
      return;
    }

    if (passwordInput.isEmpty) {
      showToast(Constants.TOAST_INPUT_PASSWORD);
      return;
    }

    try {
      await Future.microtask(() {});
      // 等待登录操作完成
      await accountInstance.accountPasswordLogin(accountInput, passwordInput);
      await Future.microtask(() {
        showToast(Constants.TOAST_LOGIN_SUCCESS);
      });
      await Future.delayed(const Duration(milliseconds: 300));
      handleClose();
    } catch (e) {
      showToast(Constants.TOAST_LOGIN_ERROR);
    }
  }

  Future<void> jumpWX() async {
    if (!isAgreePrivacy) {
      showToast(Constants.TOAST_AGREE_PROTOCOL);
      return;
    }

    try {
      final Map<String, String> params = {};
      dynamic result;
      try {
        result = await NativeNavigationUtils.pushToShareWX();
        print('pushToNativePage调用完成，结果: $result');
      } catch (e) {
        print('pushToNativePage调用异常: $e');
      }
    } catch (e) {
      showToast(Constants.TOAST_INSTALL_WECHAT);
    }
  }
}

class WindowModel {
  double windowBottomPadding = 0;
}
