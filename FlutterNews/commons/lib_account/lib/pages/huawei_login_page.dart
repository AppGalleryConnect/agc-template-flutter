import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:provider/provider.dart';
import '../components/agree_privacy_box.dart';
import '../constants/Constants.dart';
import '../constants/Types.dart';
import '../viewmodels/login_vm.dart';

class HuaweiLoginPage extends StatelessWidget {
  final LoginRouterParams? params;

  const HuaweiLoginPage({super.key, this.params});

  @override
  Widget build(BuildContext context) {
    final loginVM = LoginVM.getInstance(true);
    loginVM.isSheet = params?.isSheet ?? false;
    loginVM.isHalfModal = params?.isHalfModal ?? false;
    loginVM.resetInput(); // 重置协议状态

    final routeParams = RouterUtils.of.currentRouteArguments(context);
    if (routeParams?['isHalfModal'] == true) {
      loginVM.isHalfModal = true;
    }

    return ChangeNotifierProvider<LoginVM>.value(
      value: loginVM,
      child: _LoginPageContent(loginVM: loginVM),
    );
  }
}

// 内部内容组件，直接接收LoginVM实例
class _LoginPageContent extends StatelessWidget {
  final LoginVM loginVM;

  const _LoginPageContent({required this.loginVM});

  @override
  Widget build(BuildContext context) {
    if (loginVM.isHalfModal) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            if (notification.extent == Constants.SHEET_MIN_EXTENT) {
              Navigator.of(context).pop();
              return true;
            }
            return false;
          },
          child: Container(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: Constants.SHEET_INITIAL_EXTENT,
              minChildSize: Constants.SHEET_MIN_EXTENT,
              maxChildSize: Constants.SHEET_MAX_EXTENT,
              expand: false,
              snap: true,
              snapSizes: const [
                Constants.SHEET_MIN_EXTENT,
                Constants.SHEET_SNAP_EXTENT_MEDIUM,
                Constants.SHEET_INITIAL_EXTENT,
                Constants.SHEET_MAX_EXTENT
              ],
              snapAnimationDuration: const Duration(
                  milliseconds: Constants.SHEET_SNAP_ANIMATION_DURATION),
              builder: (context, scrollController) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular(Constants.SHEET_BORDER_RADIUS),
                          topRight:
                              Radius.circular(Constants.SHEET_BORDER_RADIUS),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // 内容区域
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 拖动条和关闭按钮
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    top: Constants.DRAG_HANDLE_TOP_PADDING,
                                    bottom:
                                        Constants.DRAG_HANDLE_BOTTOM_PADDING),
                                child: Stack(
                                  children: [
                                    // 拖动条
                                    Center(
                                      child: Container(
                                        width: Constants.DRAG_HANDLE_WIDTH,
                                        height: Constants.DRAG_HANDLE_HEIGHT,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                              Constants
                                                  .DRAG_HANDLE_BORDER_RADIUS),
                                        ),
                                      ),
                                    ),
                                    // 关闭按钮
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            right: Constants
                                                .CLOSE_BUTTON_RIGHT_PADDING),
                                        child: Container(
                                          width: Constants.CLOSE_BUTTON_SIZE,
                                          height: Constants.CLOSE_BUTTON_SIZE,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                                Constants
                                                    .CLOSE_BUTTON_BORDER_RADIUS),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.close,
                                                size: Constants
                                                    .CLOSE_BUTTON_ICON_SIZE,
                                                color: Colors.grey),
                                            padding: const EdgeInsets.all(
                                                Constants
                                                    .CLOSE_BUTTON_INNER_PADDING),
                                            constraints: const BoxConstraints(
                                              minWidth: Constants
                                                  .CLOSE_BUTTON_MIN_SIZE,
                                              minHeight: Constants
                                                  .CLOSE_BUTTON_MIN_SIZE,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 核心内容区域
                              Flexible(
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.only(
                                    left: CommonConstants.PADDING_XL,
                                    right: CommonConstants.PADDING_XL,
                                    // 协议区域
                                  ),
                                  physics: const ClampingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // 原有内容
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: Constants.ICON_MARGIN,
                                          bottom: Constants.ICON_MARGIN,
                                        ),
                                        child: Image.asset(
                                          Constants.startIconPath,
                                          width: Constants.START_ICON_WIDTH *
                                              Constants.ICON_SCALE_FACTOR,
                                          fit: BoxFit.contain,
                                          height: Constants.START_ICON_WIDTH *
                                              Constants.ICON_SCALE_FACTOR,
                                        ),
                                      ),
                                      Text(
                                        loginVM.anonymousPhone,
                                        style: const TextStyle(
                                          fontSize: Constants.TITLE_FONT_SIZE,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: CommonConstants.PADDING_XS),
                                        child: Text(
                                          '华为账号绑定号码',
                                          style: TextStyle(
                                            fontSize:
                                                Constants.SUBTITLE_FONT_SIZE,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top:
                                              Constants.LOGIN_BUTTON_MARGIN_TOP,
                                        ),
                                        child: loginVM.buildHuaweiLoginButton(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: CommonConstants.PADDING_M,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            loginVM.jumpOtherLogin();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[100],
                                            minimumSize: const Size(
                                                double.infinity,
                                                Constants.BTN_HEIGHT),
                                          ),
                                          child: const Text(
                                            '其他方式登录',
                                            style: TextStyle(
                                              fontSize:
                                                  Constants.BUTTON_FONT_SIZE,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // 协议区域
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: CommonConstants.PADDING_XL,
                                right: CommonConstants.PADDING_XL,
                                top: CommonConstants.PADDING_S,
                              ),
                              color: Colors.white,
                              width: double.infinity,
                              child: const AgreePrivacyBox(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
    }

    // 正常模式下的登录页面
    return Scaffold(
        backgroundColor: loginVM.pageBgColor(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: CommonConstants.PADDING_L,
              right: CommonConstants.PADDING_L,
              bottom: CommonConstants.PADDING_XXS,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: loginVM.iconMarginTop(),
                          bottom: Constants.PADDING_40,
                        ),
                        child: Image.asset(
                          Constants.startIconPath,
                          width: Constants.START_ICON_WIDTH,
                          fit: BoxFit.contain,
                          height: Constants.START_ICON_WIDTH,
                        ),
                      ),
                      Text(
                        loginVM.anonymousPhone,
                        style: const TextStyle(
                          fontSize: Constants.PHONE_NUMBER_FONT_SIZE,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.only(top: CommonConstants.PADDING_XS),
                        child: Text(
                          '华为账号绑定号码',
                          style: TextStyle(
                            fontSize: Constants.SUBTITLE_FONT_SIZE,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: Constants.LOGIN_BUTTON_MARGIN_TOP,
                        ),
                        child: loginVM.buildHuaweiLoginButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: CommonConstants.PADDING_M,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            loginVM.jumpOtherLogin();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            minimumSize: const Size(
                                double.infinity, Constants.BTN_HEIGHT),
                          ),
                          child: const Text(
                            '其他方式登录',
                            style: TextStyle(
                              fontSize: Constants.BUTTON_FONT_SIZE,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
                const AgreePrivacyBox(),
              ],
            ),
          ),
        ));
  }
}

// 页面构建器函数 - 简化为直接返回HuaweiLoginPage，因为Provider已在组件内部处理
Widget huaweiLoginPageBuilder({LoginRouterParams? params}) {
  return HuaweiLoginPage(params: params);
}
