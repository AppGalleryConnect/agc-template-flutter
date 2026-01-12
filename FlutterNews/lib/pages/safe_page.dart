import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/models/window_model.dart';
import '../viewmodels/safe_page_vm.dart';
import 'agree_dialog_page.dart';
import 'package:flutter/services.dart';

class SafePage extends StatefulWidget {
  const SafePage({super.key});

  @override
  State<SafePage> createState() => _SafePageState();
}

class _SafePageState extends State<SafePage> {
  SafePageVM vm = SafePageVM();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final windowModel = WindowModel();
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 20 && details.localPosition.dx < 50) {
          SystemNavigator.pop();
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (!didPop) {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CommonConstants.PADDING_PAGE,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/startIcon.png',
                        width: 80,
                        fit: BoxFit.contain,
                      ).margin(
                        top: 136,
                      ),
                      const Text(
                        '新闻阅读',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ).margin(
                        top: CommonConstants.PADDING_XXL,
                        bottom: 2,
                      ),
                      const Text(
                        '业务描述',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 122, 122, 122),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: CommonConstants.PADDING_PAGE,
                  right: CommonConstants.PADDING_PAGE,
                  bottom: windowModel.windowBottomPadding,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/ic_security.svg',
                      width: 25,
                      fit: BoxFit.contain,
                    ),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text:
                                '本应用需联网，调用XX、XX权限，获取XX信息，以为您提供XX服务。我们仅在您使用具体功能业务时，才会触发上述行为收集使用相关的个人信息。详情请参阅',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: 'XX业务与隐私的声明、权限使用说明',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color.fromARGB(255, 109, 135, 221),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => vm.privacyClick(context),
                          ),
                          const TextSpan(
                            text: '。',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ).margin(
                      top: CommonConstants.PADDING_L,
                      bottom: 6,
                    ),
                    const Text(
                      '请您仔细阅读上述声明，点击"同意"，即表示您知悉并同意我们向您提供本应用服务。',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 取消按钮
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierColor: Colors.black.withOpacity(0.6),
                                builder: (context) => AgreePrivacyPage(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor:
                                  const Color.fromARGB(255, 109, 135, 221),
                              minimumSize: const Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('取消'),
                          ),
                        ),
                        const SizedBox(width: CommonConstants.SPACE_M),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async =>
                                await vm.agreeBtnClick(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 109, 135, 221),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('同意'),
                          ),
                        ),
                      ],
                    ).margin(
                      top: CommonConstants.PADDING_L,
                      bottom: CommonConstants.PADDING_L,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension WidgetMarginExtension on Widget {
  Widget margin(
      {double top = 0, double right = 0, double bottom = 0, double left = 0}) {
    return Container(
      margin:
          EdgeInsets.only(top: top, right: right, bottom: bottom, left: left),
      child: this,
    );
  }
}
