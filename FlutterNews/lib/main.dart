import 'package:business_home/components/harmony_qr_scanner.dart';
import 'package:business_interaction/business_interaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:module_feedback/pages/submit_page.dart';
import 'package:module_feedback/pages/feedback_manage_page.dart';
import 'package:module_feedback/pages/record_list_page.dart';
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
import '../pages/splash_page.dart';
import 'package:business_mine/pages/message_single_comment_list.dart';
import 'package:module_setfontsize/module_setfontsize.dart';
import 'constants/constants.dart';

void main() async {
  initializeDateFormatting('zh_CN');
  WidgetsFlutterBinding.ensureInitialized();
  await initSetting();
  runApp(const MyApp());
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

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final settingModel = SettingModel.getInstance();
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
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
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
