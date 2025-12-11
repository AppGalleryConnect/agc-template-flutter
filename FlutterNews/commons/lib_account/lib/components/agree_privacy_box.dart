import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../viewmodels/login_vm.dart';

class AgreePrivacyBox extends StatelessWidget {
  const AgreePrivacyBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginVM>(
      builder: (context, vm, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: CommonConstants.PADDING_L,
            bottom: CommonConstants.PADDING_XXL,
            left: CommonConstants.PADDING_L,
            right: CommonConstants.PADDING_L,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Constants.CHECKBOX_SIZE,
                width: Constants.CHECKBOX_SIZE,
                child: Checkbox(
                  value: vm.isAgreePrivacy,
                  shape: const CircleBorder(),
                  activeColor: Constants.LOGIN_BUTTON_COLOR,
                  side: const BorderSide(
                      color: Constants.BORDER_GRAY_COLOR, width: 1.0),
                  onChanged: (bool? value) {
                    final newValue = value ?? false;
                    vm.agreePrivacyChange(newValue);
                  },
                ),
              ),
              const SizedBox(width: CommonConstants.PADDING_S),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '已阅读并同意 ',
                        style: TextStyle(
                          fontSize: Constants.BODY_SMALL_FONT_SIZE,
                          color: Constants.TEXT_GRAY_COLOR,
                        ),
                      ),
                      TextSpan(
                        text: '《用户协议》   ',
                        style: const TextStyle(
                          fontSize: Constants.BODY_SMALL_FONT_SIZE,
                          color: Constants.TEXT_LINK_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            RouterUtils.of
                                .pushPathByName(RouterMap.PROTOCOL_WEB_VIEW,
                                    param: {
                                      'content': vm.userProtocolInfo,
                                      'title': '用户协议',
                                    },
                                    animated: true);
                          },
                      ),
                      TextSpan(
                        text: '《xxxx隐私政策》',
                        style: const TextStyle(
                          fontSize: Constants.BODY_SMALL_FONT_SIZE,
                          color: Constants.TEXT_LINK_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            RouterUtils.of
                                .pushPathByName(RouterMap.PROTOCOL_WEB_VIEW,
                                    param: {
                                      'content': vm.privacyInfo,
                                      'title': '隐私政策',
                                    },
                                    animated: true);
                          },
                      ),
                      const TextSpan(
                        text: '和',
                        style: TextStyle(
                          fontSize: Constants.BODY_SMALL_FONT_SIZE,
                          color: Constants.TEXT_GRAY_COLOR,
                        ),
                      ),
                      TextSpan(
                        text: '《华为账号用户认证协议》',
                        style: const TextStyle(
                          fontSize: Constants.BODY_SMALL_FONT_SIZE,
                          color: Constants.TEXT_LINK_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            RouterUtils.of
                                .pushPathByName(RouterMap.PROTOCOL_WEB_VIEW,
                                    param: {
                                      'content': vm.huaweiUserProtocolInfo,
                                      'title': '华为账号用户认证协议',
                                    },
                                    animated: true);
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
