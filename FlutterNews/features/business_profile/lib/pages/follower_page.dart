import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';
import '../components/base_follow_watch_page.dart';
import '../viewmodels/follower_page_vm.dart';
import 'dart:async';

class FollowerPage extends StatefulWidget {
  const FollowerPage({super.key});

  @override
  State<FollowerPage> createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage> {
  late final FollowerPageViewModel vm;
  Timer? _statusCheckTimer;
  VoidCallback? _listener;

  @override
  void initState() {
    super.initState();
    vm = FollowerPageViewModel();
    vm.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final route = ModalRoute.of(context);
        if (route != null && route.settings.arguments != null) {
          if (route.settings.arguments is String) {
            final userId = route.settings.arguments as String;
            if (userId.isNotEmpty) {
              vm.setUserId(userId);
            }
          } else {}
        } else {
          vm.title = '我的粉丝';
          vm.userId = vm.userInfoModel.authorId;
        }
      } catch (e) {
        if (vm.userId.isEmpty) {
          vm.title = '我的粉丝';
          vm.userId = vm.userInfoModel.authorId;
        }
      }
    });

    _listener = () {
      if (mounted) {
        setState(() {});
      }
    };
    vm.addListener(_listener!);
    startStatusCheckTimer();
  }

  @override
  void dispose() {
    stopStatusCheckTimer();
    if (_listener != null) {
      vm.removeListener(_listener!);
    }
    super.dispose();
  }

  void startStatusCheckTimer() {
    stopStatusCheckTimer();
    _statusCheckTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (mounted && vm.userInfoModel.isLogin) {
          vm.handleWatchStatusChanged();
        }
      },
    );
  }

  void stopStatusCheckTimer() {
    if (_statusCheckTimer != null) {
      _statusCheckTimer?.cancel();
      _statusCheckTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingInfo = SettingModel.getInstance();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          NavHeaderBar(
            title: (!vm.userInfoModel.isLogin ||
                    vm.userId.isEmpty ||
                    vm.userId == vm.userInfoModel.authorId)
                ? '我的粉丝'
                : '他的粉丝',
            showBackBtn: true,
            onBack: vm.customBack,
            windowModel: vm.windowModel,
            bgColor: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
            titleColor: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
            backButtonBackgroundColor:
                ThemeColors.getBackgroundTertiary(settingInfo.darkSwitch),
            customTitleSize: 20 * FontScaleUtils.fontSizeRatio,
          ),
          Expanded(
            child: BaseFollowWatchPage(
              vm: vm,
            ),
          ),
        ],
      ),
    );
  }
}

Widget followerPageBuilder() {
  return const FollowerPage();
}
