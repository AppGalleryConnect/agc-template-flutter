import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lib_common/constants/common_constants.dart';
import '../viewmodels/safe_page_vm.dart';

class AgreePrivacyPage extends StatefulWidget {
  final SafePageVM vm = SafePageVM();

  AgreePrivacyPage({super.key});

  @override
  AgreePrivacyPageState createState() => AgreePrivacyPageState();
}

class AgreePrivacyPageState extends State<AgreePrivacyPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _closeDialog() async {
    await _controller.reverse();
    Navigator.pop(context);
  }

  Future<void> _exitApp() async {
    await _controller.reverse();
    widget.vm.cancelBtnClick(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _closeDialog();
        return false;
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(CommonConstants.PADDING_XM),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '您需要同意协议才能体验新闻模板',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '本应用需联网，调用XX、XX权限，获取XX信息，以为您提供XX服务。我们仅在您使用具体功能业务时，才会触发上述行为收集使用相关的个人信息。详情请参阅',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextSpan(
                            text: 'XX业务与隐私的声明、权限使用说明',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color.fromARGB(255, 109, 135, 221),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => widget.vm.privacyClick(context),
                          ),
                          TextSpan(
                            text: '。',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '请您仔细阅读上述声明，点击“同意”，即表示您知悉并同意我们向您提供本应用服务。',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _exitApp(),
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                              foregroundColor:
                                  const Color.fromARGB(255, 109, 135, 221),
                              minimumSize: const Size(double.infinity, 37),
                              side: const BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: const Text('退出应用'),
                          ),
                        ),
                        const SizedBox(width: CommonConstants.SPACE_L),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => widget.vm.agreeBtnClick(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 37),
                              backgroundColor:
                                  const Color.fromARGB(255, 109, 135, 221),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: const Text('同意并继续'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
