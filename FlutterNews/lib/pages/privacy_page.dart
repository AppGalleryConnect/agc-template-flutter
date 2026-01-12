import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/models/window_model.dart';
import 'package:lib_widget/components/nav_header_bar.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late final WebViewController _webViewController;
  final WindowModel windowModel = WindowModel();

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..loadFlutterAsset('assets/privacy_statement.htm');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          bottom: windowModel.windowBottomPadding,
        ),
        color: const Color.fromARGB(255, 241, 243, 244),
        child: Column(
          children: [
            NavHeaderBar(
              windowModel: windowModel,
              leftPadding: 0,
              rightPadding: 0,
              showBackBtn: true,
              backButtonBackgroundColor:
                  const Color.fromARGB(255, 229, 231, 232),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: CommonConstants.PADDING_PAGE,
                  right: CommonConstants.PADDING_PAGE,
                ),
                child: WebViewWidget(
                  controller: _webViewController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
