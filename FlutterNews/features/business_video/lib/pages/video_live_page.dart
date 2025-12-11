import 'dart:async';
import 'package:business_video/models/video_model.dart';
import 'package:business_video/services/video_services.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_common/lib_common.dart';
import '../constants/constants.dart';

class VideoLivePage extends StatefulWidget {
  final SettingModel settingInfo;

  const VideoLivePage({
    super.key,
    required this.settingInfo,
  });

  @override
  State<StatefulWidget> createState() => _VideoLivePageState();
}

class _VideoLivePageState extends State<VideoLivePage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _liveScrollController = ScrollController();
  final PageController _pageController = PageController();

  Timer? _timer;
  int current = 0;

  List<VideoNewsData> _liveList = [];
  List<VideoNewsData> _liveHighlightsList = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _liveList = VideoService.queryLiveBannerList();
      _liveHighlightsList = VideoService.queryLiveHighlightsList();
    });

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        if (current >= Constants.livestreamPreviewList.length - 1) {
          current = 1;
          _pageController.jumpToPage(0);
        } else {
          current++;
        }
        _pageController.animateToPage(current,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      });
    });
  }

  @override
  dispose() {
    _timer?.cancel();
    _timer = null;
    _controller.dispose();
    _scrollController.dispose();
    _liveScrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).padding.top + Constants.SPACE_44,
          color: ThemeColors.getBackgroundSecondary(widget.settingInfo.darkSwitch),
        ),
        Expanded(
          child: EasyRefresh(
            controller: _controller,
            header: const MaterialHeader(),
            onRefresh: _onRefresh,
            child: Container(
              color: ThemeColors.getBackgroundSecondary(widget.settingInfo.darkSwitch),
              child: _buildLiveWidget(),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).padding.bottom + Constants.SPACE_59,
        )
      ],
    );
  }

  // 下拉刷新回调
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _liveList.clear();
    _liveHighlightsList.clear();

    setState(() {
      _liveList = VideoService.queryLiveBannerList();
      _liveHighlightsList = VideoService.queryLiveHighlightsList();
    });
    _controller.finishRefresh();
  }

  Widget _buildLiveWidget() {
    return ListView(
      padding: EdgeInsets.zero, 
      controller: _scrollController,
      children: [
        Container(
          height: Constants.SPACE_50,
          decoration: BoxDecoration(
            color: widget.settingInfo.darkSwitch ? Colors.grey[850] : Colors.white, 
            borderRadius: BorderRadius.circular(Constants.SPACE_20), 
          ),
          margin: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
          width: MediaQuery.of(context).size.width,
          child: _buildLivePreviewWidget(),
        ),
        const SizedBox(
          height: Constants.SPACE_10,
        ),
        SizedBox(
          height: Constants.SPACE_260,
          width: MediaQuery.of(context).size.width,
          child: _buildLiveListWidget(),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16), 
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: Constants.SPACE_5,
              ),
              Row(
                children: [
                  Text(
                    '精彩回放',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: Constants.FONT_18,
                      fontWeight: FontWeight.w700,
                      color: widget.settingInfo.darkSwitch ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: Constants.SPACE_20,
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width > Constants.SPACE_400 ? Constants.SPACE_335 : Constants.SPACE_670,
          margin: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16), 
          width: MediaQuery.of(context).size.width,
          child: _buildLiveHighlightsWidget(),
        ),
      ],
    );
  }

  Widget _buildLivePreviewWidget() {
    return Row(
      children: [
        const SizedBox(
          width: Constants.SPACE_10,
        ),
        SvgPicture.asset(
          Constants.icNoticeImage,
          width: Constants.SPACE_20,
          height: Constants.SPACE_15,
          colorFilter: ColorFilter.mode(widget.settingInfo.darkSwitch ? Colors.white : Colors.black, BlendMode.srcIn), 
        ),
        const SizedBox(
          width: Constants.SPACE_10,
        ),
        Expanded(
            child: PageView.builder(
          controller: _pageController,
          itemCount: Constants.livestreamPreviewList.length,
          scrollDirection: Axis.vertical,
          pageSnapping: true,
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                Constants.livestreamPreviewList[index],
                style: TextStyle(
                  fontSize: Constants.FONT_14,
                  color: widget.settingInfo.darkSwitch ? Colors.white : Constants.textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ))
      ],
    );
  }

  Widget _buildLiveListWidget() {
    return ListView.builder(
      itemCount: _liveList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16), 
          width: MediaQuery.of(context).size.width > Constants.SPACE_400 ? (MediaQuery.of(context).size.width * 0.5 - Constants.SPACE_32) : (MediaQuery.of(context).size.width - Constants.SPACE_32),
          child: GestureDetector(
            onTap: () => RouterUtils.of.pushPathByName(
                RouterMap.VIDEO_Live_PAGE,
                param: [_liveList[index], true, widget.settingInfo],),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Constants.SPACE_20),
                      child: SizedBox(
                        height: Constants.SPACE_200,
                        child: Image.network(
                          _liveList[index].coverUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: Constants.SPACE_1,
                      right: Constants.SPACE_1,
                      width: Constants.SPACE_70,
                      height: Constants.SPACE_20,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red, 
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(Constants.SPACE_20),
                            bottomLeft: Radius.circular(Constants.SPACE_20),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: Constants.SPACE_15,
                            ),
                            SvgPicture.asset(
                              Constants.icLiveImage,
                              width: Constants.SPACE_12,
                              height: Constants.SPACE_12,
                            ),
                            const Text(
                              '直播中',
                              style:
                                  TextStyle(color: Colors.white, fontSize: Constants.FONT_10),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: Constants.SPACE_10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width, 
                  child: Text(
                    '【正在直播】${_liveList[index].title}',
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w500, color: widget.settingInfo.darkSwitch ? Colors.white : Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLiveHighlightsWidget() {
    return GridView.count(
      padding: EdgeInsets.zero, 
      crossAxisCount: MediaQuery.of(context).size.width > Constants.SPACE_400 ? 4 : 2, 
      crossAxisSpacing: Constants.SPACE_10, 
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
          _liveHighlightsList.length, 
          (index) => GestureDetector(
                onTap: () => RouterUtils.of.pushPathByName(
                    RouterMap.VIDEO_Live_PAGE,
                    param: [_liveHighlightsList[index], false, widget.settingInfo]),
                child: Container(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Constants.SPACE_20), 
                        child: SizedBox(
                          height: Constants.SPACE_100,
                          child: Image.network(
                            _liveHighlightsList[index].coverUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Constants.SPACE_10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: Constants.SPACE_41,
                        child: Text(
                          _liveHighlightsList[index].title,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: widget.settingInfo.darkSwitch ? Colors.white : Colors.black, fontSize: Constants.FONT_14),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}
