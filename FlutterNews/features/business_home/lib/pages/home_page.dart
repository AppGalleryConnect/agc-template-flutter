import 'package:business_mine/viewmodels/mine_vm.dart';
import 'package:business_video/models/video_model.dart';
import 'package:business_video/views/video_sheet.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_news_api/params/response/layout_response.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/services/home_service.dart';
import 'package:lib_news_api/services/video_service.dart';
import 'package:module_flutter_channeledit/model/model.dart';
import 'package:module_flutter_channeledit/views/channel_edit.dart';
import 'package:module_newsfeed/components/native_navigation_utils.dart';
import 'package:module_newsfeed/components/news_detail_page.dart';
import '../components/search_button.dart';
import '../items_card/custom_item_card.dart';
import '../commons/constants.dart';
import 'package:lib_account/viewmodels/login_vm.dart' as login_vm;
import 'package:lib_common/services/location_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    getNewsDynamicData('recommend');
    _pageController = PageController(initialPage: currentPageIndex);
    Logger.info(TAG, '-------RouterUtil route:$newsList');
    _sendPushNotice();
    vm.addListener(_refreshUI);
    _listener = () {
      setState(() {});
    };
    settingInfo.addListener(_listener);

    getLocation();
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
    List<TabInfo> selectChannelList =
        channelsList.where((element) => element.selected).toList();
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
                    const Text(
                      '首页',
                      style: TextStyle(
                        fontSize: Constants.homePageTitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryTextColor,
                      ),
                    ),
                    Row(
                      children: [
                        const SearchButton(),
                        const SizedBox(width: Constants.spacingS),
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Constants.homePageIconButtonBackgroundColor),
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
                              Theme.of(context).colorScheme.primary,
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
                  channelsList: channelsList,
                  fontSizeRatio: settingInfo.fontSizeRatio,
                  onChange: (index, item) => {
                    _pageController.jumpToPage(index),
                  },
                  onSave: (List<TabInfo> list) => {
                    setState(() {
                      channelsList = list;
                    })
                  },
                ),
              ),
              Expanded(
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectChannelList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;

                      resource = selectChannelList[index].id;
                      getNewsDynamicData(resource);
                    });
                  },
                  itemBuilder: (BuildContext context, int pageIndex) {
                    final currentChannel = selectChannelList[pageIndex];
                    return EasyRefresh(
                      controller: EasyRefreshController(),
                      header: const MaterialHeader(),
                      onRefresh: () async {
                        await getNewsDynamicData(currentChannel.id);
                      },
                      footer: const MaterialFooter(),
                      onLoad: _onLoad,
                      child: newsList.isNotEmpty
                          ? ListView.builder(
                              key: ValueKey(currentChannel.id),
                              padding: EdgeInsets.zero,
                              itemCount: newsList.length,
                              itemBuilder: (context, index) {
                                if (index < 0 || index >= newsList.length) {
                                  return const SizedBox.shrink();
                                }
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
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom +
                    Constants.homePageBottomPadding,
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
