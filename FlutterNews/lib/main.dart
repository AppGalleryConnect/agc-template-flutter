import 'package:business_home/components/harmony_qr_scanner.dart';
import 'package:business_interaction/business_interaction.dart';
import 'package:business_video/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart';
import 'package:lib_common/lib_common.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:business_home/pages/news_search.dart';
import 'package:lib_account/pages/huawei_login_page.dart';
import 'package:business_mine/pages/comment_page.dart';
import 'package:business_mine/pages/message_page.dart';
import 'package:business_mine/pages/message_comment_reply_page.dart';
import 'package:business_mine/pages/message_im_list_page.dart';
import 'package:business_mine/pages/message_system_page.dart';
import 'package:business_mine/pages/message_fans_page.dart';
import 'package:business_mine/pages/mark_page.dart';
import 'package:business_mine/pages/like_page.dart';
import 'package:business_mine/pages/history_page.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/services/video_service.dart';
import 'package:module_feedback/pages/submit_page.dart';
import 'package:module_feedback/pages/feedback_manage_page.dart';
import 'package:module_feedback/pages/record_list_page.dart';
import 'package:module_newsfeed/components/news_detail_page.dart';
import 'package:newsflutterstemplate/notifier/fullScreenProvider.dart';
import 'index_page.dart';
import 'package:lib_account/pages/protocol_web_view.dart';
import 'package:business_mine/pages/message_im_chat_page.dart';
import 'package:business_setting/business_setting.dart';
import 'package:get/get.dart';
import 'package:business_video/pages/video_detail_page.dart';
import 'package:business_video/pages/video_live_detail_page.dart';
import 'package:business_profile/pages/person_home_page.dart';
import 'package:business_profile/pages/watch_page.dart';
import 'package:business_profile/pages/follower_page.dart';
import 'pages/splash_page.dart';
import 'pages/safe_page.dart';
import 'pages/privacy_page.dart';
import 'pages/agree_dialog_page.dart';
import 'package:business_mine/pages/message_single_comment_list.dart';
import 'package:business_mine/pages/mine_page.dart';
import 'package:module_setfontsize/module_setfontsize.dart';
import 'constants/constants.dart';

void main() async {
  initializeDateFormatting('zh_CN');
  WidgetsFlutterBinding.ensureInitialized();
  await initSetting();
  Get.put(BreakpointController());
  await BreakponitUtils.initBreakponit();
  // 监听原生侧卡片数据（应用存活状态）
  FormCardUtils.initFormCard();
  FormCardUtils.formCardDataNotifier.addListener(_onFormCardDataChanged);
  // 监听原生侧快捷方式数据（应用存活状态）
  ShortcutUtils.initShortcut();
  runApp(const MyApp());
}

void _onFormCardDataChanged() {
  dynamic arguments = FormCardUtils.formCardDataNotifier.value;
  if (arguments == null) return;
  _pushToNewsDetailsById(arguments['newsId'], arguments['newsType']);
}

void _pushToNewsDetailsById(newsId, newsType) {
  final newModel = VideoServiceApi.queryVideoById(newsId);
  if (newModel == null) {
    CommonToastDialog.show(ToastDialogParams(message: '暂无此新闻详情！'));
    return;
  }
  Navigator.of(GlobalContext.context).popUntil((route) {
    String? name = route.settings.name;
    if (name == "/NewsDetailPage" || name == RouterMap.VIDEO_PLAY_PAGE) {
      return false;
    }
    return true;
  });

  if (newsType == 0) {
    // 新闻页
    Navigator.push(
      GlobalContext.context,
      MaterialPageRoute(
        settings: const RouteSettings(name: "/NewsDetailPage"),
        builder: (context) => NewsDetailPage(
          news: newModel as NewsResponse,
        ),
      ),
    );
  } else {
    // 视频页
    VideoNewsData videoData = VideoNewsData.fromCommentResponse(newModel!);
    RouterUtils.of.pushPathByName(
      RouterMap.VIDEO_PLAY_PAGE,
      param: videoData,
    );
  }
}

Future<void> initSetting() async {
  final settingModel = SettingModel.getInstance();
  await settingModel.initPreferences();
  Get.put(SettingFontViewModel(), permanent: true);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness:
          settingModel.darkSwitch ? Brightness.light : Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness:
          settingModel.darkSwitch ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: settingModel.darkSwitch
          ? AppConstants.systemNavigationBarDarkColor
          : AppConstants.systemNavigationBarColor,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final settingModel = SettingModel.getInstance();

  @override
  void initState() {
    super.initState();
    queryBrightness();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    queryBrightness();
  }

  queryBrightness() {
    final newBrightness = WidgetsBinding.instance.window.platformBrightness;
    if (settingModel.currentThemeMode == 0) {
      settingModel.darkSwitch = newBrightness == Brightness.dark;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ListenableBuilder(
        listenable: settingModel,
        builder: (context, child) {
          return MaterialApp(
            title: '新闻模板',
            debugShowCheckedModeBanner: false,
            initialRoute: RouterMap.SPLASH_PAGE,
            navigatorKey: GlobalContext.globalKey,
            navigatorObservers: [
              interactionPageRouteObserver,
            ],
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0x66FFFFFF),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0x66FFFFFF),
                brightness: Brightness.dark,
                surface: AppConstants.scaffoldBackgroundColor,
              ),
              scaffoldBackgroundColor: AppConstants.scaffoldBackgroundColor,
              useMaterial3: true,
            ),
            themeMode:
                settingModel.darkSwitch ? ThemeMode.dark : ThemeMode.light,
            routes: {
              RouterMap.SPLASH_PAGE: (context) => const SplashPage(),
              RouterMap.INDEX_PAGE: (context) => const IndexPage(),
              RouterMap.SAFE_PAGE: (context) => const SafePage(),
              RouterMap.PRIVACY_PAGE: (context) => const PrivacyPage(),
              RouterMap.AGREE_PRIVACY_PAGE: (context) => AgreePrivacyPage(),
              RouterMap.MINE_SCANNER_PAGE: (context) =>
                  const HarmonyQrScanner(),
              RouterMap.NEWS_SEARCH_PAGE: (context) => const NewsSearch(),
              RouterMap.HUAWEI_LOGIN_PAGE: (context) => const HuaweiLoginPage(),
              RouterMap.MINE_COMMENT_PAGE: (context) => const CommentPage(),
              RouterMap.MINE_MESSAGE_PAGE: (context) => const MessagePage(),
              RouterMap.MINE_MARK_PAGE: (context) => const MarkPage(),
              RouterMap.MINE_LIKE_PAGE: (context) => const LikePage(),
              RouterMap.MINE_HISTORY_PAGE: (context) => const HistoryPage(),
              RouterMap.FEEDBACK_MANAGE_PAGE: (context) =>
                  const FeedbackManagePage(),
              RouterMap.FEEDBACK_SUBMIT_PAGE: (context) => const SubmitPage(),
              RouterMap.FEEDBACK_RECORD_LIST_PAGE: (context) =>
                  recordListPageBuilder(),
              RouterMap.MINE_MESSAGE_COMMENT_PAGE: (context) =>
                  const MsgCommentReplyPage(),
              RouterMap.MINE_MESSAGE_IM_PAGE: (context) =>
                  const MsgIMListPage(),
              RouterMap.MINE_MESSAGE_SYSTEM_PAGE: (context) =>
                  const MsgSystemPage(),
              RouterMap.MINE_MESSAGE_FANS_PAGE: (context) =>
                  const MsgFansPage(),
              RouterMap.MINE_MSG_IM_CHAT_PAGE: (context) =>
                  const MsgIMChatPage(),
              RouterMap.MINE_MSG_COMMENT_DETAIL: (context) =>
                  const MsgSingleCommentList(),
              RouterMap.MINE_PAGE: (context) => const MinePage(),
              RouterMap.PUBLISH_POST_PAGE: (context) => const PublishPostPage(),
              RouterMap.SETTING_PAGE: (context) => const SettingPage(),
              RouterMap.SETTING_PERSONAL: (context) => const SettingPersonal(),
              RouterMap.SETTING_PRIVACY: (context) => const SettingPrivacy(),
              RouterMap.SETTING_NETWORK: (context) => const SettingNetwork(),
              RouterMap.SETTING_FONT: (context) => const SettingFont(),
              RouterMap.SETTING_ABOUT: (context) => const SettingAbout(),
              RouterMap.PROFILE_HOME: (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                return PersonalHomePage(userId: args as String? ?? '');
              },
              RouterMap.PROFILE_WATCH: (context) => const WatchPage(),
              RouterMap.PROFILE_FOLLOWER: (context) => const FollowerPage(),
              RouterMap.VIDEO_PLAY_PAGE: (context) => const VideoDetailPage(),
              RouterMap.VIDEO_Live_PAGE: (context) =>
                  const VideoLiveDetailPage(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == RouterMap.PROTOCOL_WEB_VIEW) {
                String content = '';
                String title = '用户协议';
                if (settings.arguments != null) {
                  if (settings.arguments is Map) {
                    Map args = settings.arguments as Map;
                    content = args['content'] ?? '';
                    title = args['title'] ?? '用户协议';
                  } else {
                    content = settings.arguments.toString();
                  }
                }
                if (content.trim().isEmpty) {
                  content =
                      '<html><body><h1>用户协议</h1><p>默认协议内容</p></body></html>';
                }
                return MaterialPageRoute(
                  builder: (context) =>
                      ProtocolWebView(content: content, title: title),
                  settings: settings,
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
