import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:module_swipeplayer/model/video_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:module_swipeplayer/constants/contants.dart';

class VideoView extends StatefulWidget {
  final VideoModel videoModel;
  final bool canPlayVideo;
  final bool autoPlayVideo;
  final bool isDark;
  final Function() onClick;
  final Function(Duration duration) onPushDetail;
  final Function() onFinish;
  final Function() onClose;

  const VideoView({
    super.key,
    required this.videoModel,
    required this.canPlayVideo,
    this.autoPlayVideo = true,
    required this.onClick,
    required this.onPushDetail,
    required this.onFinish,
    required this.onClose,
    this.isDark = false,
  });

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _controller;

  bool _isPlaying = false;
  bool _isBuffering = false;
  bool _isInitialized = false;
  bool _isFinsished = false;

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  String videoUrl = '';

  @override
  void initState() {
    super.initState();

    videoUrl = widget.videoModel.videoUrl;
    _onLoadVideo();
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoInfo);
    _controller.dispose();
    super.dispose();
  }

  void _onLoadVideo() {
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoModel.videoUrl))
          ..initialize().then((_) {
            setState(() {
              if (widget.canPlayVideo && widget.autoPlayVideo) _onPlay();
            });
          }).catchError((e) {});
    _controller.addListener(_onVideoInfo);
  }

  void _onReloadVideo() {
    _isInitialized = false;
    _isBuffering = false;
    _currentDuration = Duration.zero;
    _controller.removeListener(_onVideoInfo);
    _controller.dispose().then((_) {
      setState(() {
        _onLoadVideo();
      });
    });
  }

  void _onVideoInfo() {
    setState(() {
      _isPlaying = _controller.value.isPlaying;
      _isBuffering = _controller.value.isBuffering;
      _isInitialized = _controller.value.isInitialized;
      _isFinsished = _isInitialized &&
          _controller.value.duration == _controller.value.position &&
          _controller.value.position != Duration.zero;
      if (_isFinsished && widget.canPlayVideo) {
        _isFinsished = false;
        _controller.seekTo(Duration.zero);
        _onPlay();
        widget.onFinish();
      }

      _currentDuration = _controller.value.position;
      _totalDuration = _controller.value.duration;
    });
  }

  void _onPlay() async {
    if (!_controller.value.isInitialized || _controller.value.isPlaying) return;
    await _controller.play();
  }

  void _onPause() async {
    if (!_controller.value.isInitialized || !_controller.value.isPlaying) {
      return;
    }
    await _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    if (_isPlaying && !widget.canPlayVideo) {
      _onPause();
    }
    if (widget.canPlayVideo && !_isPlaying && widget.autoPlayVideo) {
      _onPlay();
      if (widget.videoModel.currentDuration > 0) {
        _controller
            .seekTo(Duration(milliseconds: widget.videoModel.currentDuration));
        widget.videoModel.currentDuration = 0;
      }
    }

    if (videoUrl != widget.videoModel.videoUrl && videoUrl != '') {
      videoUrl = widget.videoModel.videoUrl;
      _onReloadVideo();
    }

    return GestureDetector(
      onTap: () {
        _onPause();
        widget.onPushDetail(_currentDuration);
      },
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Stack(children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_isPlaying) {
                      _onPause();
                      widget.onPushDetail(_currentDuration);
                    } else {
                      _onPlay();
                      widget.onClick();
                    }
                  });
                },
                child: _isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(
                          _controller,
                        ),
                      )
                    : Image.network(widget.videoModel.coverUrl),
              ),
              if (!_isPlaying && _isInitialized) _buildPlayBuilder(),
              if (!_isPlaying && _isInitialized) _buildTimeBuilder(),
              if (_isInitialized && _isBuffering && widget.canPlayVideo)
                _buildBufferBuilder(),
              if (_isPlaying) _buildSliderBuilder(),
              if (widget.videoModel.videoType == VideoEnum.Ad) _adBuilder(),
              if (widget.videoModel.videoType == VideoEnum.Ad) _closeBuilder(),
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: Constants.SPACE_16,
                    right: Constants.SPACE_16,
                    top: Constants.SPACE_10),
                child: Text(
                  widget.videoModel.title,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Constants.FONT_16,
                      color: widget.isDark ? Colors.white : Colors.black),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Constants.SPACE_16,
                  right: Constants.SPACE_16,
                  bottom: Constants.SPACE_10,
                ),
                child: Row(
                  children: [
                    Text(
                      '${widget.videoModel.author} ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.videoModel.createTime))}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: Constants.FONT_12,
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _adBuilder() {
    return Positioned(
      top: Constants.SPACE_0,
      right: Constants.SPACE_0,
      height: Constants.SPACE_20,
      width: Constants.SPACE_40,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(Constants.SPACE_5),
        ),
        child: Container(
          color: Colors.grey,
          child: const Center(
            child: Text(
              '广告',
              style:
                  TextStyle(color: Colors.white, fontSize: Constants.FONT_12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _closeBuilder() {
    return Positioned(
      bottom: Constants.SPACE_0,
      right: Constants.SPACE_0,
      height: Constants.SPACE_40,
      width: Constants.SPACE_40,
      child: Container(
        width: Constants.SPACE_40,
        height: Constants.SPACE_40,
        decoration: BoxDecoration(
          color: Constants.CLOSE_BAAKGROUND_COLOR,
          borderRadius: BorderRadius.circular(Constants.SPACE_25),
          border: Border.all(color: Colors.black12, width: 1),
        ),
        child: IconButton(
          padding: const EdgeInsets.all(Constants.SPACE_12),
          icon: SvgPicture.asset(
            Constants.deleteImage,
            width: Constants.SPACE_15,
            height: Constants.SPACE_15,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
            fit: BoxFit.contain,
          ),
          onPressed: () {
            widget.onClose();
          },
        ),
      ),
    );
  }

  Widget _buildSliderBuilder() {
    return Positioned(
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      bottom: Constants.SPACE_0,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: Constants.SPACE_1,
          thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: Constants.SPACE_1,
          ),
          overlayShape: const RoundSliderOverlayShape(
            overlayRadius: Constants.SPACE_1,
          ),
        ),
        child: Slider(
          value: _currentDuration.inMilliseconds.toDouble() >= 0
              ? _currentDuration.inMilliseconds.toDouble()
              : 0,
          activeColor: Colors.blue,
          inactiveColor: Colors.black,
          thumbColor: Colors.blue,
          min: 0,
          max: _totalDuration.inMilliseconds.toDouble(),
          onChanged: (double value) {},
        ),
      ),
    );
  }

  Widget _buildPlayBuilder() {
    return Positioned(
      top: Constants.SPACE_0,
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      bottom: Constants.SPACE_0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            _onPlay();
            widget.onClick();
          },
          child: SvgPicture.asset(
            Constants.icPlayImage,
            width: Constants.SPACE_50,
            height: Constants.SPACE_50,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBuilder() {
    return Positioned(
      right: Constants.SPACE_12,
      bottom: Constants.SPACE_10,
      child: Container(
        padding: const EdgeInsets.all(
          Constants.SPACE_5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            Constants.SPACE_10,
          ),
          color: Colors.black.withOpacity(0.5),
        ),
        child: Text(
          _formatDuration(
            widget.videoModel.videoDuration,
          ),
          style: const TextStyle(
            fontSize: Constants.FONT_12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBufferBuilder() {
    return const Positioned(
      top: Constants.SPACE_0,
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      bottom: Constants.SPACE_0,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  String _formatDuration(int duration) {
    double time = duration / 1000;
    int hours = time ~/ 3600;
    double remainingSeconds = time % 3600;
    int minutes = remainingSeconds ~/ 60;
    double seconds = remainingSeconds % 60;

    String hourStr = hours.toString().padLeft(2, '0');
    String minuteStr = minutes.toString().padLeft(2, '0');
    String secondStr = seconds.ceil().toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hourStr:$minuteStr:$secondStr';
    }
    return '$minuteStr:$secondStr';
  }
}
