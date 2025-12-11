import 'dart:async';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:lib_account/services/account_api.dart';
import 'package:module_swipeplayer/module_swipeplayer.dart';
import 'package:business_video/types/page_type.dart';
import 'package:business_video/services/video_services.dart';
import 'package:business_video/models/video_model.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_news_api/services/mine_service.dart';
import '../constants/constants.dart';

class VideoListPage extends StatefulWidget {
  final PageType type;
  final bool isVideo;
  final SettingModel settingInfo;

  const VideoListPage({
    super.key,
    required this.type,
    required this.settingInfo,
    this.isVideo = true,
  });

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();

  int _currentIndex = 0;
  List<VideoNewsData> _videoList = [];
  final bool _canPlayVideo = true; // 控制是否允许播放视频

  @override
  void initState() {
    super.initState();

    _videoList = VideoService.queryVideoList();
    MineService().addToHistory(_videoList[0].id);
  }

  @override
  dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).padding.top + Constants.SPACE_44,
          color:
              ThemeColors.getBackgroundSecondary(widget.settingInfo.darkSwitch),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification) {
                int currentIndex = 0;
                final currentOffset = _scrollController.offset + 200;
                currentIndex = (currentOffset /
                        (MediaQuery.of(context).size.width > Constants.SPACE_400
                            ? Constants.SPACE_480
                            : Constants.SPACE_290))
                    .floor();
                return true;
              }
              return false;
            },
            child: _buildvideoListWidget(),
          ),
        ),
        const SizedBox(height: Constants.SPACE_40)
      ],
    );
  }

  // 下拉刷新回调
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _videoList = VideoService.queryVideoList();
      _currentIndex = 0;
      MineService().addToHistory(_videoList[_currentIndex].id);
    });
    _controller.finishRefresh();
  }

  // 上拉加载回调
  Future<void> _onLoad() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _videoList += VideoService.queryVideoList();
    });
    _controller.finishLoad();
  }

  Widget _buildvideoListWidget() {
    double height = MediaQuery.of(context).size.width > Constants.SPACE_400
        ? Constants.SPACE_480
        : Constants.SPACE_290;
    return EasyRefresh(
      controller: _controller,
      header: const MaterialHeader(),
      footer: const MaterialFooter(),
      onRefresh: _onRefresh,
      onLoad: _onLoad,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          controller: _scrollController,
          itemCount: _videoList.length,
          cacheExtent: 0,
          itemBuilder: (context, index) {
            return Container(
              height: height,
              color: ThemeColors.getBackgroundSecondary(
                  widget.settingInfo.darkSwitch),
              child: VideoView(
                videoModel: _getVideoModel(index),
                canPlayVideo: index == _currentIndex &&
                    widget.isVideo &&
                    ModalRoute.of(context)!.isCurrent &&
                    _canPlayVideo,
                autoPlayVideo: widget.settingInfo.network.autoPlayTabRecommend,
                isDark: widget.settingInfo.darkSwitch,
                onClick: () => {
                  setState(() {
                    _currentIndex = index;
                    MineService().addToHistory(_videoList[index].id);
                    _scrollController.animateTo(
                      0 + height * index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  })
                },
                onPushDetail: (Duration duration) => {
                  _videoList[index].currentDuration = duration.inMilliseconds,
                  RouterUtils.of.pushPathByName(
                    RouterMap.VIDEO_PLAY_PAGE,
                    param: _videoList[index],
                    onPop: (p0) {
                      if (_currentIndex == index) {
                        setState(() {
                          Duration duration = p0.result as Duration;
                          _videoList[index].currentDuration =
                              duration.inMilliseconds;
                        });
                      }
                    },
                  ),
                },
                onFinish: () => {
                  setState(() {
                    if (widget.settingInfo.network.autoPlayTabRecommend &&
                        widget.settingInfo.network.autoPlayNext &&
                        _currentIndex < _videoList.length) {
                      _currentIndex += 1;
                      _scrollController.animateTo(
                        0 + height * _currentIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  }),
                },
                onClose: () => {
                  setState(() {
                    _videoList.removeAt(index);
                  }),
                },
              ),
            );
          }),
    );
  }

  VideoModel _getVideoModel(int index) {
    VideoModel model = VideoModel.fromJson(_videoList[index].toJson());

    UserInfoModel userModel = AccountApi.getInstance().userInfoModel;
    model.isFollow =
        userModel.watchers.contains(_videoList[index].author!.authorId);
    model.authorIcon = _videoList[index].author!.authorIcon;
    model.author = _videoList[index].author!.authorNickName;
    model.currentDuration = _videoList[index].currentDuration;

    if (model.id == 'video3' || model.id == 'video4') {
      model.videoType = VideoEnum.Ad;
    }

    return model;
  }
}
