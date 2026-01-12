import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:module_swipeplayer/model/video_model.dart';
import 'package:flutter/services.dart';
import 'package:module_swipeplayer/constants/contants.dart';
import 'package:lib_common/models/setting_model.dart';

class VideoPage extends StatefulWidget {
  final VideoModel videoModel;
  final bool canPlayVideo;

  final Function(bool isPlaying) onTap;
  final Function() onClick;
  final Function(bool isFollow) onFollow;
  final Function(bool isLike) onLike;
  final Function(bool isFromBottom) onCommond;
  final Function(bool isCollect) onCollect;
  final Function() onShare;
  final Function() onFinish;
  final Function(Duration duration) onSlider;

  final bool isCommend;
  final Function() onCommendChange;

  const VideoPage({
    super.key,
    required this.videoModel,
    required this.canPlayVideo,
    required this.onTap,
    required this.onClick,
    required this.onFollow,
    required this.onLike,
    required this.onCommond,
    required this.onCollect,
    required this.onShare,
    required this.onFinish,
    required this.onSlider,
    this.isCommend = false,
    required this.onCommendChange,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  bool _isPlaying = false;
  bool _isBuffering = false;
  bool _isInitialized = false;
  bool _isFinsished = false;

  bool _isFullScreen = false;
  bool _isShowUI = true;

  bool _isSpeed = false;
  bool _isLock = false;

  bool _isSliderChange = false;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  bool _isBrightnessChange = false;
  double _brightness = 0.5;
  bool _isVolumeChange = false;
  double _volume = 1.0;

  String videoUrl = '';
  Timer? _timer;
  bool _lastVideoIsPalying = true;
  SettingModel settingInfo = SettingModel.getInstance();

  @override
  void initState() {
    super.initState();

    videoUrl = widget.videoModel.videoUrl;
    settingInfo.initPreferences().then((_) {
      setState(() {
        _volume = settingInfo.volume;
      });
    });
    settingInfo.addListener(_onSettingChanged);
    _onLoadVideo();
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoInfo);
    _controller.dispose();
    _stopTimer();
    settingInfo.removeListener(_onSettingChanged);
    super.dispose();
  }

  void _onSettingChanged() {
    setState(() {
      _volume = settingInfo.volume;
      _controller.setVolume(_volume);
    });
  }

  void _onLoadVideo() {
    if (widget.videoModel.videoUrl.contains('http')) {
      _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoModel.videoUrl))
        ..initialize().then((_) {
          setState(() {
            if (widget.videoModel.currentDuration != 0) {
              _controller.seekTo(
                  Duration(milliseconds: widget.videoModel.currentDuration));
              widget.onSlider(
                  Duration(milliseconds: widget.videoModel.currentDuration));
            }

            // 设置视频音量为全局音量
            _controller.setVolume(_volume);
            if (widget.canPlayVideo) _onPlay();
          });
        }).catchError((e) {});
    } else {
      if (widget.videoModel.videoUrl.length > 8) {
        _controller = VideoPlayerController.file(
          File(
            widget.videoModel.videoUrl.substring(8),
          ),
        )..initialize().then((_) {
            setState(() {
              if (widget.videoModel.currentDuration != 0) {
                _controller.seekTo(
                    Duration(milliseconds: widget.videoModel.currentDuration));
                widget.onSlider(
                    Duration(milliseconds: widget.videoModel.currentDuration));
              }

              // 设置视频音量为全局音量
              _controller.setVolume(_volume);
              if (widget.canPlayVideo) _onPlay();
            });
          }).catchError((e) {});
      }
    }

    _controller.addListener(_onVideoInfo);
  }

  void _onReloadVideo() {
    _isInitialized = false;
    _isPlaying = false;
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
        if (!_isFullScreen && !widget.isCommend) widget.onFinish();
      }

      if (!_isSliderChange) {
        _currentDuration = _controller.value.position;
        _totalDuration = _controller.value.duration;
        widget.onSlider(_currentDuration);
      }
    });
  }

  void _onPlay() async {
    _startTimer();
    if (!_controller.value.isInitialized || _controller.value.isPlaying) return;
    await _controller.play();
    _lastVideoIsPalying = true;
  }

  void _onPause([bool isPause = true]) async {
    _startTimer();
    if (!_controller.value.isInitialized || !_controller.value.isPlaying) {
      return;
    }
    await _controller.pause();
    if (isPause) _lastVideoIsPalying = false;
  }

  void _startTimer() {
    if (!_isFullScreen) return;
    _stopTimer();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _isShowUI = false;
        _stopTimer();
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPlaying && !widget.canPlayVideo && !widget.isCommend) {
      _onPause(false);
    }
    if (_lastVideoIsPalying && widget.canPlayVideo && !_isPlaying) {
      _onPlay();
    }
    if (videoUrl != widget.videoModel.videoUrl && videoUrl != '') {
      videoUrl = widget.videoModel.videoUrl;
      _onReloadVideo();
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          if (_isFullScreen) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
            setState(() {
              _isFullScreen = false;
              _stopTimer();
            });
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          if (widget.isCommend) {
            widget.onCommendChange();
            return;
          }
          if (_isFullScreen) {
            setState(() {
              _isShowUI = !_isShowUI;
              if (_isShowUI) {
                _startTimer();
              } else {
                _stopTimer();
              }
            });
          } else {
            setState(() {
              if (!_isInitialized || _isBuffering) return;

              widget.onTap(!_isPlaying);
              _isPlaying ? _onPause() : _onPlay();
            });
          }
        },
        onLongPress: () {
          setState(() {
            if (!(_isFullScreen && _isLock) && _isPlaying && !_isSpeed) {
              _isShowUI = true;
              _controller.setPlaybackSpeed(2.0);
              _isSpeed = true;
              _stopTimer();
            }
          });
        },
        onLongPressEnd: (details) {
          setState(() {
            _controller.setPlaybackSpeed(1.0);
            _isSpeed = false;
            _startTimer();
          });
        },
        // 只在全屏模式下处理水平手势，非全屏模式下让父组件处理标签切换
        onHorizontalDragStart: _isFullScreen
            ? (details) {
                setState(() {
                  _isSliderChange = true;
                  _stopTimer();
                });
              }
            : null,
        onHorizontalDragUpdate: _isFullScreen
            ? (details) {
                if (!_isLock &&
                    _isInitialized &&
                    _totalDuration.inMilliseconds > 0) {
                  double dragDistance = details.delta.dx;
                  double secondsPer100Pixels = 5.0;
                  double secondsChange =
                      (dragDistance / 100.0) * secondsPer100Pixels;
                  int millisecondsChange = (secondsChange * 1000).toInt();
                  int newPosition =
                      _currentDuration.inMilliseconds + millisecondsChange;
                  newPosition =
                      newPosition.clamp(0, _totalDuration.inMilliseconds);
                  setState(() {
                    _currentDuration = Duration(milliseconds: newPosition);
                  });
                }
              }
            : null,
        onHorizontalDragEnd: _isFullScreen
            ? (details) {
                if (!_isLock && _isInitialized) {
                  setState(() {
                    _controller.seekTo(_currentDuration);
                    _isSliderChange = false;
                    _startTimer();
                  });
                }
              }
            : null,
        // 只在全屏模式下处理垂直手势，非全屏模式下让PageView处理
        onVerticalDragStart: _isFullScreen
            ? (details) {
                if (!_isLock && _isInitialized) {
                  setState(() {
                    _stopTimer();
                    double screenWidth = MediaQuery.of(context).size.width;
                    double touchX = details.localPosition.dx;
                    if (touchX < screenWidth / 2) {
                      _isBrightnessChange = true;
                    } else {
                      _isVolumeChange = true;
                    }
                  });
                }
              }
            : null,
        onVerticalDragUpdate: _isFullScreen
            ? (details) {
                if (!_isLock && _isInitialized) {
                  double dragDistance = details.delta.dy;
                  double changePer50Pixels = 0.1;
                  double valueChange =
                      -(dragDistance / 50.0) * changePer50Pixels;

                  if (_isBrightnessChange) {
                    setState(() {
                      _brightness += valueChange;
                      _brightness = _brightness.clamp(0.0, 1.0);
                    });
                  } else if (_isVolumeChange) {
                    setState(() {
                      _volume += valueChange;
                      _volume = _volume.clamp(0.0, 1.0);
                      _controller.setVolume(_volume);
                      // 保存音量到全局设置
                      settingInfo.volume = _volume;
                    });
                  }
                }
              }
            : null,
        onVerticalDragEnd: _isFullScreen
            ? (details) {
                if (!_isLock && _isInitialized) {
                  setState(() {
                    _isBrightnessChange = false;
                    _isVolumeChange = false;
                    _startTimer();
                  });
                }
              }
            : null,
        child: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _videoBuilder(),
              if (_isBuffering) _buildBufferBuilder(),
              if (_isSpeed && !widget.isCommend) _buildSpeedBuilder(),
              if (_isBrightnessChange && _isFullScreen)
                _buildBrightnessIndicator(),
              if (_isVolumeChange && _isFullScreen) _buildVolumeIndicator(),
              if (!((_isPlaying && !_isFullScreen) ||
                  ((!_isShowUI || _isLock) && _isFullScreen) ||
                  _isBuffering))
                _buildPlayBuilder(),
              if ((!_isFullScreen ||
                      (_isShowUI && !_isLock && _isFullScreen)) &&
                  !widget.isCommend)
                _buildSliderBuilder(),
              if (!_isFullScreen &&
                  _controller.value.aspectRatio > 1 &&
                  !widget.isCommend)
                _buildFullScreenBuilder(),
              if (!_isFullScreen && !widget.isCommend) _buildInfoBuilder(),
              if (!_isFullScreen && !widget.isCommend) _buildSideBarBuilderr(),
              if (!_isFullScreen && !widget.isCommend) _buildCommentBuilder(),
              if (_isShowUI && _isFullScreen) _buildLockBuilder(),
              if (_isShowUI && !_isLock && _isFullScreen) _buildTopBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _liveOrAdBuilder() {
    return Positioned(
      top: Constants.SPACE_20,
      right: Constants.SPACE_20,
      height: Constants.SPACE_20,
      width: Constants.SPACE_40,
      child: widget.videoModel.videoType == VideoEnum.Ad
          ? ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(Constants.SPACE_5),
              ),
              child: Container(
                color: Colors.grey,
                child: const Center(
                  child: Text(
                    '广告',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Constants.FONT_12,
                    ),
                  ),
                ),
              ),
            )
          : ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(Constants.SPACE_5),
              ),
              child: Container(
                color: Colors.red,
                child: const Center(
                  child: Text(
                    '直播',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Constants.FONT_12,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _videoBuilder() {
    return Center(
      child: Padding(
        padding: widget.isCommend
            ? EdgeInsets.only(top: MediaQuery.of(context).padding.top)
            : (_isFullScreen
                ? const EdgeInsets.only(bottom: Constants.SPACE_0)
                : const EdgeInsets.only(bottom: Constants.SPACE_100)),
        child: Stack(
          children: [
            _isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      children: [
                        VideoPlayer(
                          _controller,
                        ),
                        if (_isFullScreen)
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.black.withOpacity(
                                (1.0 - _brightness).clamp(0.0, 0.8)),
                          ),
                      ],
                    ),
                  )
                : (widget.videoModel.coverUrl.contains('http')
                    ? Image.network(widget.videoModel.coverUrl)
                    : Image.file(File(widget.videoModel.coverUrl))),
            if (widget.videoModel.videoType != VideoEnum.Video)
              _liveOrAdBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _buildBufferBuilder() {
    return Positioned(
      top: Constants.SPACE_0,
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      bottom: Constants.SPACE_0,
      child: Padding(
        padding: widget.isCommend
            ? EdgeInsets.only(top: MediaQuery.of(context).padding.top)
            : (_isFullScreen
                ? const EdgeInsets.only(bottom: Constants.SPACE_0)
                : const EdgeInsets.only(
                    bottom: Constants.SPACE_100,
                  )),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildSpeedBuilder() {
    return Positioned(
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      top: _isFullScreen ? Constants.SPACE_100 : Constants.SPACE_200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Constants.icRateImage,
            width: Constants.SPACE_7,
            height: Constants.SPACE_8,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            width: Constants.SPACE_5,
          ),
          const Text(
            '2.0X快进中',
            style: TextStyle(color: Colors.white, fontSize: Constants.FONT_12),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayBuilder() {
    return Positioned(
      top: Constants.SPACE_0,
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      bottom: Constants.SPACE_0,
      child: Padding(
        padding: widget.isCommend
            ? EdgeInsets.only(top: MediaQuery.of(context).padding.top)
            : (_isFullScreen
                ? const EdgeInsets.only(bottom: Constants.SPACE_0)
                : const EdgeInsets.only(bottom: Constants.SPACE_100)),
        child: Center(
          child: GestureDetector(
            onTap: () => {
              setState(() {
                if (widget.isCommend) {
                  widget.onCommendChange();
                  return;
                }

                if (_isFullScreen) {
                  _isShowUI = true;
                  _isPlaying ? _onPause() : _onPlay();
                } else {
                  if (!_isInitialized || _isBuffering) return;
                  widget.onTap(!_isPlaying);
                  _isPlaying ? _onPause() : _onPlay();
                }
              })
            },
            child: SvgPicture.asset(
              _isPlaying
                  ? Constants.icPauseImage
                  : (_isFullScreen
                      ? Constants.icPlayImage
                      : Constants.icPausedImage),
              width: Constants.SPACE_50,
              height: Constants.SPACE_50,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullScreenBuilder() {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 - Constants.SPACE_50,
      width: Constants.SPACE_100,
      bottom: MediaQuery.of(context).size.height / 2 - Constants.SPACE_110,
      height: Constants.SPACE_40,
      child: GestureDetector(
        onTap: () => {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.landscapeLeft]),
          setState(() {
            _isShowUI = true;
            _isFullScreen = true;
            _onPlay();
          }),
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.SPACE_30),
            border: Border.all(
                color: Constants.BORDER_COLOR, width: Constants.SPACE_1),
          ),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Constants.icExpandFullImage,
                width: Constants.SPACE_13,
                height: Constants.SPACE_13,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                width: Constants.SPACE_8,
              ),
              const Text(
                '全屏播放',
                style:
                    TextStyle(fontSize: Constants.FONT_14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideBarBuilderr() {
    return Positioned(
      top: MediaQuery.of(context).size.height / 2 - Constants.SPACE_30,
      right: Constants.SPACE_20,
      width: Constants.SPACE_50,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                    onTap: () {
                      widget.onClick();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Constants.SPACE_20),
                      child: widget.videoModel.authorIcon.contains('http')
                          ? Image.network(
                              widget.videoModel.authorIcon,
                              fit: BoxFit.cover,
                              width: Constants.SPACE_40,
                              height: Constants.SPACE_40,
                            )
                          : Image.file(
                              File(widget.videoModel.authorIcon),
                              fit: BoxFit.cover,
                              width: Constants.SPACE_40,
                              height: Constants.SPACE_40,
                            ),
                    )),
                Positioned(
                  bottom: -Constants.SPACE_8,
                  left: Constants.SPACE_10,
                  right: Constants.SPACE_10,
                  height: Constants.SPACE_20,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.onFollow(!widget.videoModel.isFollow);
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                        Center(
                            child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Constants.SPACE_7),
                            color: Colors.white,
                          ),
                          child: SvgPicture.asset(
                            widget.videoModel.isFollow
                                ? Constants.icFollowImage
                                : Constants.icUnfollowImage,
                            colorFilter: const ColorFilter.mode(
                                Colors.red, BlendMode.srcIn),
                            fit: BoxFit.none,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: Constants.SPACE_20,
            ),
            GestureDetector(
              onTap: () => {
                widget.onLike(!widget.videoModel.isLike),
              },
              child: _buildSideBarItemBuilder(
                  widget.videoModel.isLike
                      ? Constants.icLikeImage
                      : Constants.icUnlikeImage,
                  widget.videoModel.likeCount == 0
                      ? '点赞'
                      : widget.videoModel.likeCount.toString()),
            ),
            const SizedBox(
              height: Constants.SPACE_10,
            ),
            GestureDetector(
              onTap: () => {
                widget.onCommond(false),
              },
              child: _buildSideBarItemBuilder(
                Constants.messageActiveImage,
                widget.videoModel.commentCount == 0
                    ? '评论'
                    : widget.videoModel.commentCount.toString(),
              ),
            ),
            const SizedBox(
              height: Constants.SPACE_10,
            ),
            GestureDetector(
              onTap: () => {
                widget.onCollect(!widget.videoModel.isCollect),
              },
              child: _buildSideBarItemBuilder(
                  widget.videoModel.isCollect
                      ? Constants.icFavoriteImage
                      : Constants.icUnfavoriteImage,
                  widget.videoModel.collectCount == 0
                      ? '收藏'
                      : widget.videoModel.collectCount.toString()),
            ),
            const SizedBox(
              height: Constants.SPACE_10,
            ),
            GestureDetector(
              onTap: () => {
                widget.onShare(),
              },
              child: _buildSideBarItemBuilder(Constants.icShareImage, '分享'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideBarItemBuilder(String imageUrl, String text) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            imageUrl,
            fit: BoxFit.contain,
            width: Constants.SPACE_22,
            height: Constants.SPACE_22,
          ),
          const SizedBox(
            height: Constants.SPACE_3,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: Constants.FONT_10,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBuilder() {
    return Positioned(
      bottom: Constants.SPACE_100,
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '@${widget.videoModel.author}',
              style: const TextStyle(
                fontSize: Constants.FONT_14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              widget.videoModel.title,
              style: const TextStyle(
                fontSize: Constants.FONT_14,
                color: Colors.white,
              ),
              maxLines: 2,
            ),
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      widget.videoModel.createTime)),
              style: const TextStyle(
                fontSize: Constants.FONT_12,
                color: Constants.BORDER_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderBuilder() {
    return Positioned(
      bottom: _isFullScreen ? Constants.SPACE_29 : Constants.SPACE_85,
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isSliderChange)
              Center(
                  child: Text(
                '${_formatDuration(_currentDuration)}  /  ${_formatDuration(_totalDuration)}',
                style: const TextStyle(
                  fontSize: Constants.FONT_20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              )),
            SizedBox(
              height: _isFullScreen ? Constants.SPACE_30 : Constants.SPACE_80,
            ),
            Row(
              children: [
                if (_isFullScreen)
                  Text(
                    _formatDuration(_currentDuration),
                    style: const TextStyle(
                      fontSize: Constants.FONT_10,
                      color: Colors.white,
                    ),
                  ),
                if (_isFullScreen)
                  const SizedBox(
                    width: Constants.SPACE_10,
                  ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: Constants.SPACE_1,
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: Constants.SPACE_5),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 5),
                    ),
                    child: Slider(
                      value: _currentDuration.inMilliseconds.toDouble() >= 0
                          ? _currentDuration.inMilliseconds.toDouble()
                          : 0,
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      thumbColor: Colors.white,
                      onChanged: (value) {
                        setState(
                          () {
                            _isSliderChange = true;
                            _currentDuration =
                                Duration(milliseconds: value.toInt());
                            _stopTimer();
                          },
                        );
                      },
                      onChangeEnd: (value) {
                        setState(
                          () {
                            _controller.seekTo(
                              Duration(
                                milliseconds: value.toInt(),
                              ),
                            );
                            _isSliderChange = false;
                            _startTimer();
                            widget.onSlider(_currentDuration);
                          },
                        );
                      },
                      min: 0,
                      max: _totalDuration.inMilliseconds.toDouble(),
                    ),
                  ),
                ),
                if (_isFullScreen)
                  const SizedBox(
                    width: Constants.SPACE_10,
                  ),
                if (_isFullScreen)
                  Text(
                    _formatDuration(_totalDuration),
                    style: const TextStyle(
                      fontSize: Constants.FONT_10,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            if (_isFullScreen)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        _isPlaying ? _onPause() : _onPlay();
                      })
                    },
                    child: SvgPicture.asset(
                      _isPlaying
                          ? Constants.icPauseImage
                          : Constants.icPlayImage,
                      fit: BoxFit.none,
                      width: Constants.SPACE_24,
                      height: Constants.SPACE_24,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]),
                      setState(() {
                        _isFullScreen = false;
                        _stopTimer();
                      })
                    },
                    child: SvgPicture.asset(
                      Constants.icExitFullScreenImage,
                      fit: BoxFit.none,
                      width: Constants.SPACE_18,
                      height: Constants.SPACE_18,
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  // 亮度调节指示器
  Widget _buildBrightnessIndicator() {
    return Positioned(
      top: MediaQuery.of(context).size.height / 2 - 50,
      left: 50,
      child: Column(
        children: [
          Icon(
            _brightness < 0.5 ? Icons.brightness_low : Icons.brightness_high,
            size: 50,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Text(
            '${(_brightness * 100).toInt()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 音量调节指示器
  Widget _buildVolumeIndicator() {
    return Positioned(
      top: MediaQuery.of(context).size.height / 2 - 50,
      right: 50,
      child: Column(
        children: [
          Icon(
            _volume == 0
                ? Icons.volume_off
                : _volume < 0.5
                    ? Icons.volume_down
                    : Icons.volume_up,
            size: 50,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Text(
            '${(_volume * 100).toInt()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentBuilder() {
    return Positioned(
      bottom: Constants.SPACE_30,
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                widget.onCommond(true);
              },
              child: Container(
                height: Constants.SPACE_40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Constants.SPACE_24),
                  border: Border.all(
                      color: Colors.black12, width: Constants.SPACE_1),
                  color: Constants.BACKGROUND_COLOR,
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: Constants.SPACE_16,
                    ),
                    Text(
                      '发表评论',
                      style: TextStyle(
                        fontSize: Constants.FONT_16,
                        fontWeight: FontWeight.w500,
                        color: Constants.BORDER_COLOR,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopBuilder() {
    final EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
    return Positioned(
      top: safeAreaInsets.top,
      height: Constants.SPACE_20 + safeAreaInsets.top,
      width: MediaQuery.of(context).size.width,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: Constants.SPACE_20 + safeAreaInsets.top,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.transparent,
            ],
          ),
        ),
        padding: EdgeInsets.only(
          left: Constants.SPACE_16,
          right: Constants.SPACE_16,
          top: safeAreaInsets.top,
        ),
        child: Row(
          children: [
            SizedBox(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]),
                      setState(() {
                        _isFullScreen = false;
                        _stopTimer();
                      })
                    },
                    child: Container(
                      color: Colors.transparent,
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
                  const SizedBox(
                    width: Constants.SPACE_5,
                  ),
                  SizedBox(
                    width:
                        MediaQuery.of(context).size.width - Constants.SPACE_200,
                    child: Text(
                      widget.videoModel.title,
                      style: const TextStyle(
                          color: Colors.white, fontSize: Constants.FONT_14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            const Icon(Icons.battery_full, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildLockBuilder() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height / 2 - Constants.SPACE_25,
      left: Constants.SPACE_56,
      child: GestureDetector(
        onTap: () => {
          setState(() {
            _isShowUI = true;
            _isLock = !_isLock;
            _startTimer();
          })
        },
        child: Container(
          width: Constants.SPACE_50,
          height: Constants.SPACE_50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Constants.SPACE_25,
            ),
            color: Colors.black.withOpacity(0.5),
          ),
          child: SvgPicture.asset(
            _isLock ? Constants.icLockImage : Constants.icUnlockImage,
            fit: BoxFit.none,
            width: Constants.SPACE_30,
            height: Constants.SPACE_30,
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
