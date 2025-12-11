import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:module_swipeplayer/model/video_model.dart';
import 'package:flutter/services.dart';
import 'package:module_swipeplayer/constants/contants.dart';

class LiveView extends StatefulWidget {
  final VideoModel videoModel;
  final bool isFullScreen;
  final Function(bool isFullScreen) onFullScreen;

  const LiveView({
    super.key,
    required this.videoModel,
    this.isFullScreen = false,
    required this.onFullScreen,
  });

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
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

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _onLoadVideo();
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoInfo);
    _controller.dispose();
    _stopTimer();
    super.dispose();
  }

  void _onLoadVideo() {
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoModel.videoUrl))
          ..initialize().then((_) {}).catchError((e) {
            
          });
    _controller.addListener(_onVideoInfo);
  }

  void _onVideoInfo() {
    setState(() {
      _isPlaying = _controller.value.isPlaying;
      _isBuffering = _controller.value.isBuffering;
      _isInitialized = _controller.value.isInitialized;
      _isFinsished = _isInitialized &&
          _controller.value.duration == _controller.value.position &&
          _controller.value.position != Duration.zero;

      if (!_isSliderChange) {
        _currentDuration = _controller.value.position;
        _totalDuration = _controller.value.duration;
      }
    });
  }

  void _onPlay() async {
    _startTimer();
    if (!_controller.value.isInitialized || _controller.value.isPlaying) return;
    await _controller.play();
  }

  void _onPause() async {
    _startTimer();
    if (!_controller.value.isInitialized || !_controller.value.isPlaying) {
      return;
    }
    await _controller.pause();
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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          if (_isFullScreen) {
            setState(() {
              _isFullScreen = false;
              _stopTimer();
              widget.onFullScreen(_isFullScreen);
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
            });
          }else {
            Navigator.of(context).pop();
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          if (_isFullScreen) {
            setState(() {
              _isShowUI = !_isShowUI;
              if (_isShowUI) {
                _startTimer();
              }else {
                _stopTimer();
              }
            });
          }else {
            setState(() {
              if (!_isInitialized || _isBuffering) return;
              if (!_isPlaying) _onPlay();
            });
          }
        },
        onDoubleTap: () {
          if (!_isInitialized || _isBuffering) return;
          _isPlaying ? _onPause() : _onPlay();
        },
        onLongPress: () {
          setState(() {
            if (!_isLock && _isFullScreen && _isPlaying && !_isSpeed) {
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
        child: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _videoBuilder(),
              if (_isBuffering) _buildBufferBuilder(),
              if (_isSpeed) _buildSpeedBuilder(),

              if (!((_isPlaying && !_isFullScreen) || ((!_isShowUI || _isLock) && _isFullScreen) || _isBuffering) && !_isFinsished)   _buildPlayBuilder(),
              if (_isFinsished && !_isBuffering) _buildFinishBuilder(),

              if (!_isFullScreen || (_isShowUI && !_isLock && _isFullScreen)) _buildSliderBuilder(),

              if (_isShowUI && _isFullScreen)  _buildLockBuilder(),
              if (_isShowUI && !_isLock && _isFullScreen) _buildTopBuilder(),
            ],
            
          ),
        )
      )
    );
  }

  Widget _videoBuilder() {
    return Center(
      child: _isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(
                _controller,
              ),
            )
          : Image.network(widget.videoModel.coverUrl),
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

  Widget _buildFinishBuilder() {
    return Positioned(
        top: Constants.SPACE_0,
        left: Constants.SPACE_0,
        right: Constants.SPACE_0,
        bottom: Constants.SPACE_0,
        child: Center(
          child: GestureDetector(
            onTap: () => {
              setState(() {
                _isFinsished = false;
                _controller.seekTo(Duration.zero);
                _onPlay();
              })
            },
            child: Container(
              width: Constants.SPACE_100,
              height: Constants.SPACE_40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constants.SPACE_25), 
                color: Colors.black.withOpacity(0.5),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: Constants.SPACE_10,
                  ),
                  SvgPicture.asset(
                    Constants.icReplayImage,
                    width: Constants.SPACE_12,
                    height: Constants.SPACE_12,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: Constants.SPACE_5,
                  ),
                  const Text(
                    '重新播放',
                    style: TextStyle(color: Colors.white, fontSize: Constants.FONT_14),
                  )
                ],
              ),
            ),
          ),
        ));
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
        ));
  }

  Widget _buildPlayBuilder() {
    return Positioned(
        top: Constants.SPACE_0,
        left: Constants.SPACE_0,
        right: Constants.SPACE_0,
        bottom: Constants.SPACE_0,
        child: Center(
          child: GestureDetector(
            onTap: () => {
              setState(() {
                if (_isFullScreen) {
                  _isShowUI = true;
                  _isPlaying ? _onPause() : _onPlay();
                } else {
                  if (!_isInitialized || _isBuffering) return;
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
        ));
  }

  Widget _buildSliderBuilder() {
    return Positioned(
      bottom: _isFullScreen ? Constants.SPACE_29 : Constants.SPACE_0,
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isSliderChange && _isFullScreen)
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
                const SizedBox(
                  width: Constants.SPACE_30,
                ),
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
                const SizedBox(
                  width: Constants.SPACE_10,
                ),
                Text(
                  _formatDuration(_currentDuration),
                  style: const TextStyle(
                    fontSize: Constants.FONT_10,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: Constants.SPACE_10,
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: Constants.SPACE_1, 
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: Constants.SPACE_3),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: Constants.SPACE_3), 
                    ),
                    child: Slider(
                      value: _currentDuration.inMilliseconds.toDouble() >= 0
                          ? _currentDuration.inMilliseconds.toDouble()
                          : 0,
                      activeColor: Colors.white, 
                      inactiveColor: Colors.grey, 
                      thumbColor: Colors.white, 
                      onChanged: (value) {
                        setState(() {
                          _isSliderChange = true;
                          _currentDuration =
                              Duration(milliseconds: value.toInt());
                          _stopTimer();
                        });
                      },
                      onChangeEnd: (value) {
                        setState(() {
                          _controller
                              .seekTo(Duration(milliseconds: value.toInt()));
                          _isSliderChange = false;
                          _startTimer();
                        });
                      },
                      min: 0,
                      max: _totalDuration.inMilliseconds.toDouble(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Constants.SPACE_10,
                ),
                Text(
                  _formatDuration(_totalDuration),
                  style: const TextStyle(
                    fontSize: Constants.FONT_10,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: Constants.SPACE_10,
                ),
                GestureDetector(
                  onTap: () => {
                      setState(() {
                        _isFullScreen = !_isFullScreen;
                        widget.onFullScreen(_isFullScreen);         
                        if (_isFullScreen) {
                          _startTimer();
                          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                        }else {
                          _stopTimer();
                          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                        }     
                      })
                  },
                  child: SvgPicture.asset(
                    _isFullScreen ? Constants.icExitFullScreenImage : Constants.icExpandFullScreenImage,
                    fit: BoxFit.none,
                    width: Constants.SPACE_18,
                    height: Constants.SPACE_18,
                  ),
                ),
                const SizedBox(
                  width: Constants.SPACE_30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBuilder() {
    return Positioned(
      top: Constants.SPACE_0,
      height: Constants.SPACE_64,
      width: MediaQuery.of(context).size.width,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: Constants.SPACE_64,
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
        padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16), 
        child: Row(
          children: [
            SizedBox(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        _isFullScreen = false;
                        _stopTimer();
                        widget.onFullScreen(_isFullScreen);    
                        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
                    width: MediaQuery.of(context).size.width - Constants.SPACE_200,
                    child: Text(
                      widget.videoModel.title,
                      style: const TextStyle(color: Colors.white, fontSize: Constants.FONT_14),
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
            borderRadius: BorderRadius.circular(Constants.SPACE_25), 
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
