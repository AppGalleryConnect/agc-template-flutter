import 'package:flutter/material.dart';
import 'package:module_swipeplayer/views/video_page.dart';
import 'package:module_swipeplayer/model/video_model.dart';

class VideoSliderPage extends StatefulWidget {
  final List<VideoModel> videoList;

  const VideoSliderPage({
    super.key,
    required this.videoList,
  });

  @override
  State<VideoSliderPage> createState() => _VideoSliderPageState();
}

class _VideoSliderPageState extends State<VideoSliderPage> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.videoList.length,
        controller: _pageController,
        onPageChanged: (index) => {
          setState(() {
            _currentIndex = index;
          }),
        },
        itemBuilder: (context, index) => VideoPage(
          videoModel: widget.videoList[index],
          canPlayVideo: _currentIndex == index,
          onTap: (isPlaying) => {
            print('点击了视频 $isPlaying'),
          },
          onClick: () => {
            print('点击了跳转'),
          },
          onFollow: (isFollow) => {
            print('点击了关注'),
          },
          onLike: (isLike) => {
            print('点击了点赞'),
          },
          onCommond: (isCommond) => {
            print('点击了评论'),
          },
          onCollect: (isCollect) => {
            print('点击了收藏'),
          },
          onShare: () => {
            print('点击了分享'),
          },
          onFinish: () => {},
          onSlider: (duration) => {},
          onCommendChange: () => {},
        )
      ),
    );
  }
}
