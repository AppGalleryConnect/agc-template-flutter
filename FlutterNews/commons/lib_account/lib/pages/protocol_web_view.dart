import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/constants.dart';
import 'package:lib_widget/lib_widget.dart';

class ProtocolWebView extends StatefulWidget {
  final String content;

  final String? title;

  const ProtocolWebView({super.key, required this.content, this.title});

  @override
  State<ProtocolWebView> createState() => _ProtocolWebViewState();
}

class _ProtocolWebViewState extends BaseStatefulWidgetState<ProtocolWebView> {
  late WebViewController _controller;

  late WindowModel _windowModel;

  @override
  void initState() {
    super.initState();
    _windowModel = WindowModel();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(
          ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            _showErrorPage();
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );

    _loadProtocolContent();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _windowModel.updateWindowPadding(
          MediaQuery.of(context).padding.top,
          MediaQuery.of(context).padding.bottom,
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProtocolContent();
  }

  void _loadProtocolContent() {
    String contentToLoad = widget.content;
    if (contentToLoad.trim().isEmpty) {
      contentToLoad = Constants.PROTOCOL_WEBVIEW_DEFAULT_HTML;
    }

    final bool isDark = settingInfo.darkSwitch;
    final String bgColor = isDark ? '#000000' : '#F1F3F5';
    final String textColor = isDark ? '#FFFFFF' : '#000000';

    final String title = widget.title ?? '用户协议';
    final String wrappedContent = contentToLoad
        .replaceAll(RegExp(r'<script[^>]*tailwindcss[^>]*></script>'), '')
        .replaceAll(RegExp(r'<body[^>]*>'), '<body>')
        .replaceFirst(
          '<body>',
          '<body><h1>$title</h1>',
        )
        .replaceFirst(
      '</head>',
      '''
    <style>
        /* 隐藏所有原有的Tailwind样式类名显示 */
        * { 
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif !important;
        }
        body { 
          background-color: $bgColor !important; 
          margin: 0 !important; 
          padding: 16px !important;
          color: $textColor !important;
        }
        /* 隐藏header */
        header { 
          display: none !important; 
        }
        /* 隐藏所有带卡片效果的容器 */
        main, .max-w-4xl, .bg-white, .rounded-xl, .shadow-md {
          background-color: $bgColor !important;
          box-shadow: none !important;
          border-radius: 0 !important;
          margin: 0 !important;
          padding: 0 !important;
        }
        /* 标题样式 */
        h1 {
          text-align: left !important;
          font-size: 32px !important;
          font-weight: 700 !important;
          color: $textColor !important;
          margin: 16px 0 !important;
        }
        h2 {
          text-align: left !important;
          font-size: 28px !important;
          font-weight: 700 !important;
          color: $textColor !important;
          margin: 24px 0 16px 0 !important;
        }
        h3 {
          text-align: left !important;
          font-size: 22px !important;
          font-weight: 600 !important;
          color: $textColor !important;
          margin: 16px 0 12px 0 !important;
        }
        /* 段落样式 */
        p {
          text-align: left !important;
          color: $textColor !important;
          line-height: 1.6 !important;
          margin: 8px 0 !important;
          font-size: 14px !important;
        }
        /* section样式 */
        section {
          margin: 16px 0 !important;
        }
        /* section-number序号样式 */
        span.section-number {
          display: inline-block !important;
          width: auto !important;
          height: auto !important;
          border-radius: 0 !important;
          background-color: transparent !important;
          color: $textColor !important;
          font-size: 18px !important;
          font-weight: 700 !important;
          text-align: center !important;
          line-height: normal !important;
          margin-right: 8px !important;
          padding: 0 !important;
        }
    </style>
</head>''',
    );

    try {
      _controller.loadHtmlString(
        wrappedContent,
        baseUrl: Constants.PROTOCOL_WEBVIEW_BASE_URL,
      );
    } catch (error) {
      _showErrorPage();
    }
  }

  void _showErrorPage() {
    try {
      _controller.loadHtmlString(Constants.PROTOCOL_WEBVIEW_ERROR_HTML);
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
      body: Column(
        children: [
          NavHeaderBar(
            title: '',
            showBackBtn: true,
            bgColor: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
            backButtonBackgroundColor: Constants.WEBVIEW_BACKGROUND_COLOR,
            backButtonPressedBackgroundColor: Constants.WEBVIEW_PRESSED_COLOR,
            windowModel: _windowModel,
          ),
          // WebView 区域
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: _windowModel.windowBottomPadding,
              ),
              child: WebViewWidget(controller: _controller),
            ),
          ),
        ],
      ),
    );
  }
}

// 页面构建器函数
Widget protocolWebViewBuilder(String content) {
  return ProtocolWebView(content: content);
}
