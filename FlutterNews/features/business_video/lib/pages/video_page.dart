import 'package:business_video/types/page_type.dart';
import 'package:flutter/material.dart';
import 'package:lib_account/services/account_api.dart';
import 'package:module_flutter_channeledit/module_channeledit.dart';
import 'package:business_video/pages/video_list_page.dart';
import 'package:business_video/pages/video_slider_page.dart';
import 'package:business_video/pages/video_live_page.dart';
import 'package:lib_common/lib_common.dart';
import 'package:business_video/pages/video_nodata.dart';
import 'package:business_video/models/video_enevtbus.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_news_api/services/mine_service.dart';
import '../constants/constants.dart';
import 'package:lib_common/services/location_service.dart';

class VideoPlayEvent {
  final bool play;
  const VideoPlayEvent(this.play);
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> implements MarkLikeObserver {
  int currentPageIndex = 1;
  double fontSizeRatio = 1.0;
  PageController pageController = PageController(initialPage: 1);

  StreamSubscription? _tabbarSub;
  bool isHideBack = true;
  bool isVideo = false;

  late final VoidCallback _listener;
  UserInfoModel userInfoModel = AccountApi.getInstance().userInfoModel;

  late SettingModel settingInfo = SettingModel.getInstance();

  bool isCommending = false;

  List<TabInfo> _dynamicChannelsList = [];

  @override
  void initState() {
    super.initState();
    _tabbarSub = eventBus.on().listen((event) {
      setState(() {
        if (event is ShowTabbarEvent) isHideBack = event.isShow;
        if (event is IsVideoItemEvent) isVideo = event.isVideo;
        // 处理视频播放事件
        if (event is VideoPlayEvent && event.play) {
          _handleStartPlayVideo();
        }
      });
    });
    _listener = () {
      setState(() {});
    };
    userInfoModel.addListener(_listener);
    settingInfo.addListener(_listener);

    MineServiceApi.addObserver(this);

    _dynamicChannelsList = List.from(Constants.videoChannelsList);
    _updateLocationInfo();
  }

  Future<void> _updateLocationInfo() async {
    try {
      String? location = await LocationService.getLocation();
      if (location != null && location.isNotEmpty) {
        bool updated = LocationService.updateLocationInTabList(
            _dynamicChannelsList,
            locationId: 'citymsg',
            location: location);

        if (updated && mounted) {
          setState(() {});
        }
      } else {
        String defaultLocation = location == null
            ? LocationService.getErrorLocation()
            : LocationService.getDefaultLocation();
        LocationService.updateLocationInTabList(_dynamicChannelsList,
            locationId: 'citymsg', location: defaultLocation);
      }
    } catch (e) {
      LocationService.updateLocationInTabList(_dynamicChannelsList,
          locationId: 'citymsg', location: LocationService.getErrorLocation());
    }
  }

  @override
  void dispose() {
    _tabbarSub?.cancel();
    userInfoModel.removeListener(_listener);
    settingInfo.removeListener(_listener);

    MineServiceApi.removeObserver(this);
    super.dispose();
  }

  void _handleStartPlayVideo() {
    setState(() {
      isVideo = true;
    });
  }

  @override
  void onMarkLikeUpdated(MarkLikeUpdateType type) {
    // 当点赞或收藏状态更新时，刷新页面状态
    if (type == MarkLikeUpdateType.Like ||
        type == MarkLikeUpdateType.Mark ||
        type == MarkLikeUpdateType.All) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.portrait;

    return Stack(children: [
      PageView(
        physics: isLandscape && !isCommending
            ? const ScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        allowImplicitScrolling: true,
        controller: pageController,
        onPageChanged: (index) => {
          setState(() {
            currentPageIndex = index;
            eventBus.fire(ShowTabbarEvent(true));
            eventBus.fire(VideoIsBlackEvent(index < 3));
          })
        },
        children: [
          userInfoModel.isLogin
              ? VideoSliderPage(
                  isVideo: isVideo && currentPageIndex == 0,
                  type: PageType.FOLLOW,
                  settingInfo: settingInfo,
                  isCommend: isCommending,
                  onCommend: (isCommend) =>
                      setState(() => isCommending = isCommend),
                )
              : const VideoNodata(),
          VideoSliderPage(
            isVideo: isVideo && currentPageIndex == 1,
            type: PageType.FEATURED,
            settingInfo: settingInfo,
            isCommend: isCommending,
            onCommend: (isCommend) => setState(() => isCommending = isCommend),
          ),
          VideoSliderPage(
            isVideo: isVideo && currentPageIndex == 2,
            type: PageType.LOCATION,
            settingInfo: settingInfo,
            isCommend: isCommending,
            onCommend: (isCommend) => setState(() => isCommending = isCommend),
          ),
          VideoListPage(
            isVideo: isVideo && currentPageIndex == 3,
            type: PageType.RECOMMEND,
            settingInfo: settingInfo,
          ),
          VideoLivePage(settingInfo: settingInfo),
        ],
      ),
      if (isLandscape && !isCommending)
        Positioned(
          left: Constants.SPACE_0,
          right: Constants.SPACE_0,
          top: Constants.SPACE_0,
          child: SizedBox(
            height: MediaQuery.of(context).padding.top + Constants.SPACE_44,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top,
                ),
                SizedBox(
                  height: Constants.SPACE_40,
                  child: Row(
                    children: [
                      if (!isHideBack)
                        GestureDetector(
                          onTap: () => {
                            eventBus.fire(ShowTabbarEvent(true)),
                          },
                          child: SizedBox(
                            width: Constants.SPACE_40,
                            height: Constants.SPACE_40,
                            child: SvgPicture.asset(
                              Constants.icLeftArrowImage,
                              fit: BoxFit.none,
                              width: Constants.SPACE_9,
                              height: Constants.SPACE_16,
                            ),
                          ),
                        ),
                      const SizedBox(width: Constants.SPACE_1),
                      Expanded(
                        child: ChannelEdit(
                          fontSizeRatio: fontSizeRatio,
                          channelsList: _dynamicChannelsList,
                          currentIndex: currentPageIndex,
                          isShowEdit: false,
                          index: 3,
                          isDark: settingInfo.darkSwitch,
                          onSave: (channelsList) => {
                            RouterUtils.of.push(RouterMap.NEWS_SEARCH_PAGE),
                          },
                          onChange: (index, item) => {
                            if (currentPageIndex != index)
                              {
                                pageController.jumpToPage(index),
                              }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    ]);
  }
}
