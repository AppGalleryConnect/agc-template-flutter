import 'dart:async';

import 'package:get/get.dart';
import 'package:business_mine/viewmodels/mine_vm.dart';
import 'package:business_video/models/video_model.dart';
import 'package:business_video/views/video_sheet.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_news_api/params/response/layout_response.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/services/home_service.dart';
import 'package:lib_news_api/services/video_service.dart';
import 'package:module_flutter_channeledit/model/model.dart';
import 'package:module_flutter_channeledit/views/channel_edit.dart';
import 'package:module_newsfeed/components/native_navigation_utils.dart';
import 'package:module_newsfeed/components/news_detail_page.dart';
import 'package:lib_account/viewmodels/login_vm.dart' as login_vm;
import 'package:lib_common/services/location_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../components/search_button.dart';
import '../items_card/custom_item_card.dart';
import '../commons/constants.dart';

class HomePage extends StatefulWidget {
  final Function() onCallParentChangeIndex;
  const HomePage({
    super.key,
    required this.onCallParentChangeIndex,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RequestListData> newsList = [];
  late var resource = 'recommend';

  List<TabInfo> channelsList = [
    TabInfo(id: 'follow', text: '关注', selected: true, order: 1, disabled: true),
    TabInfo(
        id: 'recommend', text: '推荐', selected: true, order: 2, disabled: true),
    TabInfo(
        id: 'hotService', text: '热榜', selected: true, order: 3, disabled: true),
    TabInfo(
        id: 'location', text: '南京', selected: true, order: 4, disabled: false),
    TabInfo(id: 'finance', text: '金融', selected: true, order: 5),
    TabInfo(id: 'sports', text: '体育', selected: true, order: 6),
    TabInfo(id: 'people', text: '民生', selected: false, order: 6),
    TabInfo(id: 'science', text: '科普', selected: false, order: 6),
    TabInfo(id: 'fun', text: '娱乐', selected: false, order: 6),
    TabInfo(id: 'read', text: '夜读', selected: false, order: 6),
    TabInfo(id: 'car', text: '汽车', selected: false, order: 6),
    TabInfo(id: 'view', text: 'V观', selected: false, order: 6),
  ];

  List<TabInfo> _filteredChannelsList = [];
  List<TabInfo> _selectChannelList = [];
  int currentIndex = 1;
  int topBack = 0;
  final EasyRefreshController _controller = EasyRefreshController();
  final loginVM = login_vm.LoginVM.getInstance();
  final MineViewModel vm = MineViewModel();
  final settingInfo = SettingModel.getInstance();
  late final VoidCallback _listener;
  late PageController _pageController;

  int currentPageIndex = 1;
  @override
  void initState() {
    super.initState();
    _getPreloadData();
    _pageController = PageController(initialPage: currentPageIndex);
    Logger.info(TAG, '-------RouterUtil route:$newsList');
    _sendPushNotice();
    vm.addListener(_refreshUI);
    _updateFilteredChannels();

    _listener = () {
      setState(() {
        _updateFilteredChannels();
        if (_selectChannelList.isNotEmpty) {
          if (currentIndex >= _selectChannelList.length) {
            currentIndex = 0;
            resource = _selectChannelList[0].id;
          } else {
            final currentChannel = _selectChannelList[currentIndex];
            resource = currentChannel.id;
          }

          _pageController.jumpToPage(currentIndex);
          getNewsDynamicData(resource);
        }
      });
    };
    settingInfo.addListener(_listener);
    EventHubUtils.getInstance().on(EventEnum.homeIndexChange, (args) {
      if (mounted) {
        _pageController.jumpToPage(0);
      }
    });
    getLocation();
    // 获取原生侧卡片数据，应用失活状态
    FormCardUtils.callFormCardData().then((isFormCard) {
      if (isFormCard.isValid) {
        final newModel = VideoServiceApi.queryVideoById(isFormCard.newsId);
        Navigator.push(
          GlobalContext.context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              news: newModel as NewsResponse,
            ),
          ),
        );
      }
    });
    // 获取原生侧AppLinking数据，应用失活状态
    FormCardUtils.callFormAppLinkingData().then((isFormCard) {
      if (isFormCard.isValid) {
        final newModel = VideoServiceApi.queryVideoById(isFormCard.newsId);
        if (newModel == null) {
          CommonToastDialog.show(ToastDialogParams(message: '暂无此新闻详情！'));
          return;
        }
        if (isFormCard.newsType == 0) {
          Navigator.push(
            GlobalContext.context,
            MaterialPageRoute(
              builder: (context) => NewsDetailPage(
                news: newModel as NewsResponse,
              ),
            ),
          );
        } else {
          final res = VideoService().queryVideoById(isFormCard.newsId);
          VideoNewsData videoData = VideoNewsData.fromCommentResponse(res!);
          RouterUtils.of
              .pushPathByName(RouterMap.VIDEO_PLAY_PAGE, param: videoData);
        }
      }
    });
    // 获取原生侧快捷方式数据，应用失活状态
    ShortcutUtils.callShortcutData().then((shortcutData) {
      if (shortcutData.pageName == 'FollowPage') {
        _pageController.jumpToPage(0);
      } else if (shortcutData.pageName == 'ActionPage') {
        widget.onCallParentChangeIndex();
      }
    });
  }

  void _updateFilteredChannels() {
    _filteredChannelsList = [];
    for (var channel in channelsList) {
      if (channel.id == 'recommend') {
        if (settingInfo.personalizedPush) {
          _filteredChannelsList.add(channel);
        }
      } else {
        _filteredChannelsList.add(channel);
      }
    }

    _selectChannelList =
        _filteredChannelsList.where((element) => element.selected).toList();
  }

  getLocation() async {
    try {
      String? location = await LocationService.getLocation();
      bool updated = LocationService.updateLocationInTabList(channelsList,
          locationId: 'location', location: location);
      if (updated && mounted) {
        setState(() {});
      }
    } catch (e) {
      try {
        bool updated = LocationService.updateLocationInTabList(channelsList,
            locationId: 'location',
            location: LocationService.getErrorLocation());
        if (updated && mounted) {
          setState(() {});
        }
      } catch (innerError) {
        // 处理更新默认位置标签失败的情况
      }
    }
  }

  void _refreshUI() {
    if (mounted) {
      setState(() {
        getNewsDynamicData(resource);
      });
    }
  }

  // 获取预加载数据
  Future<void> _getPreloadData() async {
    try {
      final recommendList = await PreloadUtils.getPreloadData();
      if (recommendList.isNotEmpty) {
        setState(() {
          newsList = recommendList;
        });
      } else {
        final resource =
            settingInfo.personalizedPush ? 'recommend' : 'hotService';
        getNewsDynamicData(resource);
      }
    } catch (e) {
      final resource =
          settingInfo.personalizedPush ? 'recommend' : 'hotService';
      getNewsDynamicData(resource);
    }
  }

  /// 发送推送通知
  Future<void> _sendPushNotice() async {
    try {
      final settingInfo = StorageUtils.connect(
        create: () => SettingModel(),
        type: StorageType.persistence,
      );
      final articleList =
          await HomeServiceApi.queryHomeRecommendList('recommend');
      final List<Map<String, dynamic>> articles = [];
      for (var requestData in articleList) {
        for (var newsItem in requestData.articles) {
          articles.add(
            {
              'id': newsItem.id,
              'title': newsItem.title,
              'authorId': newsItem.author?.authorId ?? '',
              'type': newsItem.type.toString(),
              'postImgList': newsItem.postImgList
                      ?.map((img) => {'picVideoUrl': img.picVideoUrl})
                      .toList() ??
                  [],
            },
          );
        }
      }
      await PushUtils.sendPushNotice(
        settingInfo: settingInfo,
        articleList: articles,
      );
    } catch (e) {
      // 发送推送通知失败时，不抛出异常
    }
  }

  onBackPress() {
    topBack = topBack + 1;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '再点击一次退出app',
        ),
      ),
    );
    if (topBack > 1) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    vm.removeListener(_refreshUI);
    settingInfo.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final breakpointCtrl = Get.find<BreakpointController>();
    return Container(
      color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
      width: double.infinity,
      height: screenSize.height,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: statusBarHeight + 10),
              Padding(
                padding: Constants.homePageHeaderPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '首页',
                      style: TextStyle(
                        fontSize: Constants.homePageTitleFontSize,
                        fontWeight: FontWeight.bold,
                        color:
                            ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                      ),
                    ),
                    Row(
                      children: [
                        SearchButton(
                            backgroundColor: ThemeColors.getBackgroundColor(
                                settingInfo.darkSwitch)),
                        const SizedBox(width: Constants.spacingS),
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                ThemeColors.getBackgroundColor(
                                    settingInfo.darkSwitch)),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.homePageIconButtonBorderRadius),
                              ),
                            ),
                            padding: WidgetStateProperty.all(
                                Constants.homePageIconButtonPadding),
                          ),
                          icon: SvgPicture.asset(
                            Constants.homePageScanIconPath,
                            width: Constants.homePageIconSize,
                            height: Constants.homePageIconSize,
                            colorFilter: ColorFilter.mode(
                              ThemeColors.getFontPrimary(
                                  settingInfo.darkSwitch),
                              BlendMode.srcIn,
                            ),
                            fit: BoxFit.contain,
                          ),
                          onPressed: () async {
                            getLocation();
                            try {
                              String result =
                                  await NativeNavigationUtils.pushToScan();
                              final res =
                                  VideoServiceApi.queryVideoById(result);
                              if (res != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsDetailPage(
                                      news: res,
                                      newsList: newsList,
                                      fontSizeRatio: settingInfo.fontSizeRatio,
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              // 错误处理
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: Constants.spacingS),
              Padding(
                padding: EdgeInsets.zero,
                child: ChannelEdit(
                  currentIndex: currentIndex,
                  channelsList: _filteredChannelsList,
                  fontColor: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                  backgroundColor:
                      ThemeColors.getBackgroundColor(settingInfo.darkSwitch),
                  backgroundColorTertiary:
                      ThemeColors.getBackgroundTertiary(settingInfo.darkSwitch),
                  fontSizeRatio: settingInfo.fontSizeRatio,
                  isDark: settingInfo.darkSwitch,
                  onChange: (index, item) => {
                    _pageController.jumpToPage(index),
                  },
                  onSave: (List<TabInfo> list) => {
                    setState(() {
                      channelsList = list;
                      _updateFilteredChannels();
                    })
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final breakpointCtrl = Get.find<BreakpointController>();
                  final currentLanes = breakpointCtrl.lanes.value;

                  return PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectChannelList.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                        resource = _selectChannelList[index].id;
                        getNewsDynamicData(resource);
                      });
                    },
                    itemBuilder: (BuildContext context, int pageIndex) {
                      final currentChannel = _selectChannelList[pageIndex];
                      return EasyRefresh(
                        controller: EasyRefreshController(),
                        header: const MaterialHeader(),
                        onRefresh: () async {
                          await getNewsDynamicData(currentChannel.id);
                        },
                        footer: const MaterialFooter(),
                        onLoad: _onLoad,
                        child: newsList.isNotEmpty
                            ? MasonryGridView.count(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                crossAxisCount:
                                    _filteredChannelsList[currentIndex].id ==
                                            'hotService'
                                        ? 1
                                        : currentLanes,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                itemCount: newsList.length,
                                padding: const EdgeInsets.only(top: 0),
                                itemBuilder: (context, index) {
                                  final news = newsList[index];
                                  return CustomItemCard(
                                    context,
                                    news,
                                    onTap: (NewsResponse res) {
                                      _pushToNewsDetail(context, res, index);
                                    },
                                    onWatchClick: (newsId) {},
                                    fontSizeRatio: settingInfo.fontSizeRatio,
                                  );
                                },
                              )
                            : noDataWidget(),
                      );
                    },
                  );
                }),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom +
                    (breakpointCtrl.isTabVertical
                        ? 0
                        : Constants.homePageBottomPadding),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onLoad() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _controller.finishRefresh();
    } catch (e) {
      _controller.finishRefresh();
    }
  }

  Widget noDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          resource == "follow" && !vm.userInfoModel.isLogin
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Constants.homePageNoLoginImageSize,
                      height: Constants.homePageNoLoginImageSize,
                      child: Image.asset(
                        Constants.homePageNoLoginImagePath,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "暂未登录，登录后查看更多精彩内容",
                      style: TextStyle(
                        fontSize: Constants.homePageSubtitleFontSize,
                        color: Constants.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Constants.homePageButtonColor),
                        ),
                        onPressed: () {
                          VideoSheet.showLoginSheet(context);
                        },
                        child: const Text(
                          "登录",
                          style: TextStyle(
                              fontSize: Constants.homePageSubtitleFontSize,
                              color: Constants.homePageButtonTextColor),
                        ))
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("没有数据"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          getNewsDynamicData(resource);
                        },
                        child: const Text("点击刷新"))
                  ],
                ),
        ],
      ),
    );
  }

  _pushToNewsDetail(BuildContext context, NewsResponse res, int index) {
    VideoNewsData videoData = VideoNewsData.fromCommentResponse(res);
    if (res.videoUrl != null) {
      RouterUtils.of
          .pushPathByName(RouterMap.VIDEO_PLAY_PAGE, param: videoData);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailPage(
            news: res,
            newsList: newsList,
            fontSizeRatio: settingInfo.fontSizeRatio,
          ),
        ),
      );
    }
  }

  Future<void> getNewsDynamicData(String resource) async {
    List<RequestListData> newNewsList = [];
    try {
      if (resource == 'follow') {
        if (login_vm.LoginVM.getInstance()
            .accountInstance
            .userInfoModel
            .isLogin) {
          newNewsList = await HomeServiceApi.queryNextPageData("follow", 10, 1);
        }
      } else {
        newNewsList = await HomeServiceApi.queryHomeRecommendList(resource);
      }
      setState(() {
        newsList = newNewsList;
      });
    } catch (e) {
      Logger.error(TAG, '获取数据失败: $e');
      setState(() => newsList = []);
    }
  }

  void showBasicAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("已触发上层悬浮按钮！"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("确认"),
            ),
          ],
        );
      },
    );
  }
}
