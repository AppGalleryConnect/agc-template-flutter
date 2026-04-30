import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:business_home/business_home.dart';
import 'package:business_video/business_video.dart';
import 'package:business_interaction/business_interaction.dart';
import 'package:lib_common/lib_common.dart';
import 'package:newsflutterstemplate/notifier/fullScreenProvider.dart';
import 'constants/constants.dart';
import 'package:business_mine/business_mine.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart';
import 'package:business_video/models/video_enevtbus.dart';
import 'package:get/get.dart';

class VideoPlayEvent {
  final bool play;
  const VideoPlayEvent(this.play);
}

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<StatefulWidget> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool _hasShownReminder = false;
  late final List<Widget> pages;

  StreamSubscription? _tabbarSub;
  StreamSubscription? _connectivitySubscription;
  bool isShowTabbar = true;
  bool isBlack = true;
  bool isVideo = false;
  bool isComment = false;
  int _firstBackTime = 0;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(
        onCallParentChangeIndex: callParentChangeIndex,
      ),
      const VideoPage(),
      const InteractionPage(),
      const MinePage(),
    ];
    _tabbarSub = eventBus.on().listen((event) {
      setState(() {
        if (event is ShowTabbarEvent) isShowTabbar = event.isShow;
        if (event is VideoIsBlackEvent) isBlack = event.isBlack;
        if (event is IsVideoItemEvent) isVideo = event.isVideo;
        if (event is IsCommendEvent) isComment = event.isCommend;
      });
    });
    ShortcutUtils.addFormCardDataListener(_handleFormCardDataChanged);
    _initializeNetworkListener();
  }

  void callParentChangeIndex() {
    setState(() {
      currentIndex = 2;
    });
    EventHubUtils.getInstance().emit(EventEnum.actionIndexChange, []);
  }

  void _handleFormCardDataChanged(dynamic data) {
    RouterUtils.of.clearStack();
    if (data['pageName'] == 'FollowPage') {
      setState(() {
        currentIndex = 0;
      });
      EventHubUtils.getInstance().emit(EventEnum.homeIndexChange, []);
    } else if (data['pageName'] == 'ActionPage') {
      setState(() {
        currentIndex = 2;
      });
      EventHubUtils.getInstance().emit(EventEnum.actionIndexChange, []);
    }
  }

  @override
  void dispose() {
    _tabbarSub?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void _initializeNetworkListener() {
    _connectivitySubscription?.cancel();
    _checkCurrentNetworkStatus();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
      } else if (result == ConnectivityResult.mobile) {
        if (currentIndex == 1) {
          _handleMobileNetworkPlayback();
        }
      } else {
        // WLAN网络
      }
    });
  }

// 检查当前网络状态
  Future<void> _checkCurrentNetworkStatus() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile &&
          currentIndex == 1) {
        _handleMobileNetworkPlayback();
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // WiFi网络不需要特殊处理
      }
    } catch (e) {
      // 处理异常
    }
  }

  void _handleMobileNetworkPlayback() {
    eventBus.fire(const VideoPlayEvent(true));
    if (!_hasShownReminder) {
      Timer.run(
        () {
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.1),
            useRootNavigator: true,
            builder: (BuildContext dialogContext) {
              Timer(const Duration(seconds: 1), () {
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              });
              return Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CommonConstants.SPACE_L,
                    vertical: CommonConstants.PADDING_M,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(CommonConstants.SPACE_XL),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    '正在使用流量播放',
                    style: TextStyle(
                      fontSize: CommonConstants.TITLE_XS,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          );
          _hasShownReminder = true;
        },
      );
    }
  }

  bool _onBackPressed() {
    if (currentIndex == 1) {
      if (!isShowTabbar) {
        final fullScreen = FullScreenProvider().isFullScreen;
        if (!fullScreen) {
          setState(() {
            isShowTabbar = true;
          });
          eventBus.fire(ShowTabbarEvent(true));
          return true;
        }
      }
    }

    final nowTime = DateTime.now().millisecondsSinceEpoch;
    if (nowTime - _firstBackTime < 1500) {
      return false;
    } else {
      _firstBackTime = nowTime;
      CommonToastDialog.show(ToastDialogParams(
        message: '再按一次退出',
        duration: const Duration(seconds: 1),
      ));
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isSpecialVideo = isVideo && isBlack;
    final backgroundColor = isSpecialVideo
        ? Colors.black
        : (isDarkMode ? AppConstants.scaffoldBackgroundColor : Colors.white);
    final selectedItemColor = isSpecialVideo
        ? Colors.white
        : (isDarkMode ? Colors.white : AppConstants.tabSelectedColor);
    final unselectedItemColor = isSpecialVideo
        ? AppConstants.unselectedItemVideoColor
        : (isDarkMode
            ? AppConstants.unselectedItemDarkColor
            : AppConstants.unselectedItemColor);

    final breakpointCtrl = Get.find<BreakpointController>();

    return ListenableBuilder(
      listenable: FullScreenProvider(),
      builder: (context, child) {
        final fullScreen = FullScreenProvider().isFullScreen;

        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (!didPop) {
              final shouldExit = !_onBackPressed();
              if (shouldExit) {
                SystemNavigator.pop();
              }
            }
          },
          child: Scaffold(
            body: Obx(() {
              final bool isVertical = breakpointCtrl.isTabVertical;
              final double leftNavWidth =
                  (isShowTabbar && !fullScreen && !isComment) && isVertical
                      ? 70
                      : 0;

              return Stack(
              children: [
                  AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.only(left: leftNavWidth),
                    child: IndexedStack(index: currentIndex, children: pages),
                  ),

                if (isShowTabbar && !fullScreen && !isComment)
                    isVertical
                        ? Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: leftNavWidth,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              color: backgroundColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  AppConstants.tabTitles.length,
                                  (index) => InkWell(
                                    onTap: () => _onTabTapped(index),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 18),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          currentIndex == index
                                              ? _buildTabItem(index).activeIcon
                                              : _buildTabItem(index).icon,
                                          const SizedBox(height: 6),
                                          Text(
                                            AppConstants.tabTitles[index],
                                            style: TextStyle(
                                              color: currentIndex == index
                                                  ? selectedItemColor
                                                  : unselectedItemColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              child: BottomNavigationBar(
                                backgroundColor: backgroundColor,
                                selectedItemColor: selectedItemColor,
                                unselectedItemColor: unselectedItemColor,
                                selectedFontSize: 12,
                                type: BottomNavigationBarType.fixed,
                                currentIndex: currentIndex,
                                onTap: _onTabTapped,
                                items: List.generate(
                                  AppConstants.tabTitles.length,
                                  (index) => _buildTabItem(index),
                                ),
                              ),
                            ),
                          ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  void _onTabTapped(int index) {
    if (currentIndex != index) {
      setState(() {
        currentIndex = index;
        eventBus.fire(IsVideoItemEvent(index == 1));
      });
      if (index == 1) {
        _checkCurrentNetworkStatus();
      } else if (currentIndex == 1 && index != 1) {
        // 离开视频页面
      }
    }
  }

  FFBottomNavigationBarItem _buildTabItem(int index) {
    final iconPath = AppConstants.tabIconPaths[index];
    return FFBottomNavigationBarItem(
      icon: _buildTabIcon(iconPath, isSelected: false),
      activeIcon: _buildTabIcon(iconPath, isSelected: true),
      label: AppConstants.tabTitles[index],
    );
  }

  Widget _buildTabIcon(String iconPath, {required bool isSelected}) {
    return Image.asset(
      iconPath,
      width: AppConstants.tabIconSize,
      height: AppConstants.tabIconSize,
      color: isSelected
          ? AppConstants.tabSelectedColor
          : AppConstants.tabUnselectedColor,
    );
  }
}

class FFBottomNavigationBarItem extends BottomNavigationBarItem {
  FFBottomNavigationBarItem({
    required Widget icon,
    super.label,
    Widget? activeIcon,
    super.backgroundColor,
    super.tooltip,
    Widget Function(Widget icon)? iconWrapper,
  }) : super(
          icon: iconWrapper?.call(icon) ?? icon,
          activeIcon:
              iconWrapper?.call(activeIcon ?? icon) ?? activeIcon ?? icon,
        );
}
