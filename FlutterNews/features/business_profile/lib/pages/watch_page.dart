import 'package:flutter/material.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import '../components/base_follow_watch_page.dart';
import '../viewmodels/watch_page_vm.dart';
import 'dart:async';
import 'package:module_setfontsize/utils/font_scale_utils.dart';

class WatchPage extends StatefulWidget {
  const WatchPage({super.key});

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  late final WatchPageViewModel vm;
  Timer? _statusCheckTimer;
  VoidCallback? _listener;

  @override
  void initState() {
    super.initState();
    vm = WatchPageViewModel();
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
          vm.title = '我的关注';
          vm.userId = vm.userInfoModel.authorId;
        }
      } catch (e) {
        vm.title = '我的关注';
        vm.userId = vm.userInfoModel.authorId;
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
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && vm.userInfoModel.isLogin) {
        vm.handleWatchStatusChanged();
      }
    });
  }

  void stopStatusCheckTimer() {
    if (_statusCheckTimer != null) {
      _statusCheckTimer?.cancel();
      _statusCheckTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          NavHeaderBar(
            title: (!vm.userInfoModel.isLogin ||
                    vm.userId.isEmpty ||
                    vm.userId == vm.userInfoModel.authorId)
                ? '我的关注'
                : '他的关注',
            showBackBtn: true,
            onBack: vm.customBack,
            windowModel: vm.windowModel,
            backButtonBackgroundColor: const Color(0xFFF0F0F0),
            backButtonPressedBackgroundColor: const Color(0xFFE0E0E0),
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

Widget watchPageBuilder() {
  return const WatchPage();
}
