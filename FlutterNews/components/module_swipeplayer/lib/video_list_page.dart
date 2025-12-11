import 'package:flutter/material.dart';
import 'package:module_swipeplayer/views/video_view.dart';
import 'package:module_swipeplayer/model/video_model.dart';

class VideoListPage extends StatefulWidget {
  final List<VideoModel> videoList;

  const VideoListPage({
    super.key,
    required this.videoList,
  });

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.videoList.length,
        itemBuilder: (context, index) {
          return VideoView(
            videoModel: widget.videoList[index],
            canPlayVideo: _currentIndex == index,
            autoPlayVideo: true,
            onClick: () => {
              setState(() {
                _currentIndex = index;
              })
            },
            onPushDetail: (Duration duration) => {
              setState(() {
                _currentIndex = -1;
              })
            },
            onFinish: () => {},
            onClose: () => {
              setState(() {
                _currentIndex = -1;
              })
            },
          );
        }
      )
    );
  }
}
