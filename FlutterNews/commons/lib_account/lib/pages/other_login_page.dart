import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:provider/provider.dart';
import './huawei_login_page.dart';
import '../components/agree_privacy_box.dart';
import '../constants/Constants.dart';
import '../constants/Types.dart';
import '../viewmodels/login_vm.dart';

// 页面构建器函数
Widget otherLoginPageBuilder(BuildContext context,
    {LoginRouterParams? params}) {
  final loginVM = LoginVM.getInstance(true);
  loginVM.isSheet = params?.isSheet ?? false;
  loginVM.isHalfModal = params?.isHalfModal ?? false;
  loginVM.resetInput();

  return ChangeNotifierProvider<LoginVM>.value(
    value: loginVM,
    child: OtherLoginPage(loginVM: loginVM),
  );
}

class OtherLoginPage extends StatefulWidget {
  final LoginVM loginVM;

  const OtherLoginPage({super.key, required this.loginVM});

  @override
  State<OtherLoginPage> createState() => _OtherLoginPageState();
}

class _OtherLoginPageState extends State<OtherLoginPage> {
  bool _hasCheckedRouteParams = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasCheckedRouteParams) {
      _hasCheckedRouteParams = true;
      final routeParams = RouterUtils.of.currentRouteArguments(context);
      if (routeParams?['isHalfModal'] == true) {
        widget.loginVM.isHalfModal = true;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginVM = widget.loginVM;

    // 半模态模式
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
                                    left: CommonConstants.PADDING_L,
                                    right: CommonConstants.PADDING_L,
                                  ),
                                  physics: const ClampingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        Constants.startIconPath,
                                        width: Constants.START_ICON_WIDTH *
                                            Constants.ICON_SCALE_FACTOR,
                                        fit: BoxFit.contain,
                                      ).marginOnly(
                                        top: Constants.ICON_MARGIN,
                                        bottom: Constants.ICON_MARGIN,
                                      ),
                                      TextField(
                                        controller: TextEditingController(
                                            text: loginVM.accountInput),
                                        onChanged: (value) =>
                                            loginVM.accountInput = value,
                                        decoration: InputDecoration(
                                          hintText:
                                              Constants.TOAST_INPUT_ACCOUNT,
                                          hintStyle: const TextStyle(
                                            fontSize: 16,
                                            color: Constants.TEXT_HINT_COLOR,
                                          ),
                                          filled: true,
                                          fillColor:
                                              Constants.BACKGROUND_COLOR_F5,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: CommonConstants.PADDING_S,
                                            horizontal:
                                                CommonConstants.PADDING_L,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Constants.TEXT_NORMAL_COLOR,
                                        ),
                                      ),
                                      TextField(
                                        controller: TextEditingController(
                                            text: loginVM.passwordInput),
                                        onChanged: (value) =>
                                            loginVM.passwordInput = value,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText:
                                              Constants.TOAST_INPUT_PASSWORD,
                                          hintStyle: const TextStyle(
                                            fontSize: 16,
                                            color: Constants.TEXT_HINT_COLOR,
                                          ),
                                          filled: true,
                                          fillColor:
                                              Constants.BACKGROUND_COLOR_F5,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: CommonConstants.PADDING_S,
                                            horizontal:
                                                CommonConstants.PADDING_L,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Constants.TEXT_NORMAL_COLOR,
                                        ),
                                      ).marginOnly(
                                        top: CommonConstants.PADDING_L,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          loginVM.accountPasswordLogin();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Constants.LOGIN_BUTTON_COLOR,
                                          minimumSize:
                                              const Size(double.infinity, 40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          Constants.LOGIN_BUTTON_TEXT,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ).marginOnly(
                                        top: Constants.PADDING_40 +
                                            CommonConstants.PADDING_S,
                                        bottom: CommonConstants.PADDING_S,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            Constants.OTHER_LOGIN_METHODS_TEXT,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Constants.TEXT_HINT_COLOR,
                                            ),
                                          ).marginOnly(
                                              bottom: CommonConstants.SPACE_M),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      PageRouteBuilder(
                                                        opaque: !loginVM
                                                            .isHalfModal,
                                                        transitionDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) {
                                                          Widget content =
                                                              HuaweiLoginPage(
                                                            params:
                                                                LoginRouterParams(
                                                              isHalfModal: loginVM
                                                                  .isHalfModal,
                                                              isSheet: loginVM
                                                                  .isSheet,
                                                            ),
                                                          );

                                                          if (loginVM
                                                              .isHalfModal) {
                                                            content = Stack(
                                                              children: [
                                                                Container(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                                content,
                                                              ],
                                                            );
                                                          }

                                                          return content;
                                                        },
                                                        transitionsBuilder:
                                                            (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                          return FadeTransition(
                                                            opacity: animation,
                                                            child: child,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: AbsorbPointer(
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          Constants
                                                              .huaweiIconPath,
                                                          width: Constants
                                                              .WAY_ICON_WIDTH,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        const Text(
                                                          Constants
                                                              .HUAWEI_LOGIN_BUTTON_TEXT,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Constants
                                                                .TEXT_HINT_COLOR,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ).marginOnly(
                                                            top: CommonConstants
                                                                .SPACE_S),
                                                      ],
                                                    ).paddingOnly(right: 8),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    loginVM.jumpWX();
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        Constants
                                                            .wechatIconPath,
                                                        width: Constants
                                                            .WAY_ICON_WIDTH,
                                                        fit: BoxFit.contain,
                                                      ),
                                                      const Text(
                                                        Constants
                                                            .WECHAT_LOGIN_TEXT,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Constants
                                                              .TEXT_HINT_COLOR,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ).marginOnly(
                                                          top: CommonConstants
                                                              .SPACE_S),
                                                    ],
                                                  ).paddingOnly(left: 8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ).marginOnly(
                                        top: loginVM.otherWayMarginTop() - 20,
                                      ),
                                      const SizedBox(height: 80),
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
                              padding: EdgeInsets.only(
                                left: CommonConstants.PADDING_XL,
                                right: CommonConstants.PADDING_XL,
                                top: CommonConstants.PADDING_S,
                                bottom: loginVM.windowModel.windowBottomPadding,
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

    // 正常模式
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      Constants.startIconPath,
                      width: Constants.START_ICON_WIDTH,
                      fit: BoxFit.contain,
                    ).marginOnly(
                      top: loginVM.iconMarginTop(),
                      bottom: Constants.PADDING_40,
                    ),
                    TextField(
                      controller:
                          TextEditingController(text: loginVM.accountInput),
                      onChanged: (value) => loginVM.accountInput = value,
                      decoration: InputDecoration(
                        hintText: Constants.TOAST_INPUT_ACCOUNT,
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Constants.TEXT_HINT_COLOR,
                        ),
                        filled: true,
                        fillColor: Constants.BACKGROUND_COLOR_F5,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: CommonConstants.PADDING_S,
                          horizontal: CommonConstants.PADDING_L,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Constants.TEXT_NORMAL_COLOR,
                      ),
                    ),
                    TextField(
                      controller:
                          TextEditingController(text: loginVM.passwordInput),
                      onChanged: (value) => loginVM.passwordInput = value,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: Constants.TOAST_INPUT_PASSWORD,
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Constants.TEXT_HINT_COLOR,
                        ),
                        filled: true,
                        fillColor: Constants.BACKGROUND_COLOR_F5,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: CommonConstants.PADDING_S,
                          horizontal: CommonConstants.PADDING_L,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Constants.TEXT_NORMAL_COLOR,
                      ),
                    ).marginOnly(
                      top: CommonConstants.PADDING_L,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // 异步处理登录操作
                        await loginVM.accountPasswordLogin();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.LOGIN_BUTTON_COLOR,
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        Constants.LOGIN_BUTTON_TEXT,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ).marginOnly(
                      top: Constants.PADDING_40 + CommonConstants.PADDING_S,
                      bottom: CommonConstants.PADDING_S,
                    ),
                    Column(
                      children: [
                        const Text(
                          Constants.OTHER_LOGIN_METHODS_TEXT,
                          style: TextStyle(
                            fontSize: 14,
                            color: Constants.TEXT_HINT_COLOR,
                          ),
                        ).marginOnly(bottom: CommonConstants.SPACE_M),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 300),
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return const HuaweiLoginPage();
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: AbsorbPointer(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        Constants.huaweiIconPath,
                                        width: Constants.WAY_ICON_WIDTH,
                                        fit: BoxFit.contain,
                                      ),
                                      const Text(
                                        Constants.HUAWEI_LOGIN_BUTTON_TEXT,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Constants.TEXT_HINT_COLOR,
                                        ),
                                        textAlign: TextAlign.center,
                                      ).marginOnly(
                                          top: CommonConstants.SPACE_S),
                                    ],
                                  ).paddingOnly(right: 8),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  loginVM.jumpWX();
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      Constants.wechatIconPath,
                                      width: Constants.WAY_ICON_WIDTH,
                                      fit: BoxFit.contain,
                                    ),
                                    const Text(
                                      Constants.WECHAT_LOGIN_TEXT,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Constants.TEXT_HINT_COLOR,
                                      ),
                                      textAlign: TextAlign.center,
                                    ).marginOnly(top: CommonConstants.SPACE_S),
                                  ],
                                ).paddingOnly(left: 8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).marginOnly(
                      top: loginVM.otherWayMarginTop() - 20,
                    ),
                  ],
                ),
              ),
            ),
            const AgreePrivacyBox(),
          ],
        ).paddingOnly(
          left: CommonConstants.PADDING_L,
          right: CommonConstants.PADDING_L,
          bottom: CommonConstants.PADDING_XXS,
        ),
      ),
      backgroundColor: loginVM.pageBgColor(),
    );
  }
}

extension WidgetMargin on Widget {
  Widget marginOnly({
    double top = 0,
    double right = 0,
    double bottom = 0,
    double left = 0,
  }) {
    return Container(
      margin: EdgeInsets.only(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      ),
      child: this,
    );
  }

  Widget paddingOnly({
    double top = 0,
    double right = 0,
    double bottom = 0,
    double left = 0,
  }) {
    return Container(
      padding: EdgeInsets.only(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      ),
      child: this,
    );
  }
}
