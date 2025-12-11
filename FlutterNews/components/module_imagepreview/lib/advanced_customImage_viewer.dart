import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/params/response/author_response.dart';
import 'package:lib_news_api/constants/constants.dart';
import 'author_card.dart';
export 'Image_preview_page_route.dart';
import 'package:module_imagepreview/constants/constants.dart';

class AdvancedCustomImageViewer extends StatefulWidget {
  final List<String> imageProviders;
  final int initialIndex;
  final String? heroTagPrefix; 

  final bool isLogin; 
  final String? currentUserId; 

  final String? authorId;
  final String? authorIcon; 
  final String? authorNickName; 
  final int? createTime;
  final int commentCount; 
  final int likeCount;
  final bool isLiked;
  final int shareCount; 

  final VoidCallback? onWatchOperation; 
  final VoidCallback? onNewsLike;
  final VoidCallback? onAddComment; 
  final VoidCallback? onShare; 

  const AdvancedCustomImageViewer({
    super.key,
    required this.imageProviders,
    this.initialIndex = 0,
    this.isLogin = false,
    this.currentUserId,
    this.authorId,
    this.authorIcon,
    this.authorNickName,
    this.createTime,
    this.commentCount = 0,
    this.likeCount = 0,
    this.isLiked = false,
    this.shareCount = 0,
    this.heroTagPrefix,
    this.onWatchOperation,
    this.onNewsLike,
    this.onAddComment,
    this.onShare,
  }) : assert(initialIndex >= 0, "初始索引不能为负数");

  @override
  State<AdvancedCustomImageViewer> createState() =>
      _AdvancedCustomImageViewerState();
}

class _AdvancedCustomImageViewerState extends State<AdvancedCustomImageViewer>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;

  NewsResponse _createNewsResponseForAuthor() {
    final author = AuthorResponse(
      authorId: widget.authorId ?? '',
      authorNickName: widget.authorNickName ?? '未知作者',
      authorIcon: widget.authorIcon ?? '',
      authorDesc: '',
      authorIp: '',
      watchersCount: 0,
      followersCount: 0,
      likeNum: 0,
    );
    return NewsResponse(
      id: '',
      type: NewsEnum.post, 
      title: '',
      author: author,
      createTime: widget.createTime ?? DateTime.now().millisecondsSinceEpoch,
      comments: [],
      commentCount: widget.commentCount,
      markCount: 0,
      likeCount: widget.likeCount,
      shareCount: widget.shareCount,
      isLiked: widget.isLiked,
      isMarked: false,
    );
  }

  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _previousOffset = Offset.zero;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _offsetAnimation;

  bool _isZoomed = false;
  bool _isAnimating = false;
  final bool _showControls = true;
  bool _isDragging = false;
  bool _isExpand = false; 

  late bool _localIsLiked;
  late int _localLikeCount;

  Size? _imageSize;

  bool _isLongImage = false;
  final double _longImageRatio = 2.6;

  NavigatorState? _navigator;

  @override
  void initState() {
    super.initState();
    _currentIndex =
        widget.initialIndex.clamp(0, widget.imageProviders.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), 
      vsync: this,
    );

    _localIsLiked = widget.isLiked;
    _localLikeCount = widget.likeCount;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigator = Navigator.of(context);
  }

  @override
  void didUpdateWidget(AdvancedCustomImageViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLiked != widget.isLiked) {
      _localIsLiked = widget.isLiked;
    }
    if (oldWidget.likeCount != widget.likeCount) {
      _localLikeCount = widget.likeCount;
    }
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));

    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleImageTap() {
    if (_isAnimating || !mounted) return;

    if (_isZoomed || _scale > 1.1) {
      _resetZoom(); 
    } else {
      _animateExit();
    }
  }

  void _animateExit() {
    if (!mounted) return;

    _navigator?.pop();
  }

  void _handleDoubleTap() {
    if (_isAnimating || !mounted) return;

    _isZoomed ? _resetZoom() : _zoomToPoint(2.0);
  }

  void _handleLongPress() {
    return;
  }

  void _zoomToPoint(double targetScale) {
    if (!mounted) return;

    setState(() => _isAnimating = true);

    _scaleAnimation = Tween<double>(begin: _scale, end: targetScale).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _offsetAnimation = Tween<Offset>(begin: _offset, end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.reset();
    _animationController.forward().then((_) {
      if (mounted) {
        setState(() {
          _scale = targetScale;
          _offset = Offset.zero;
          _isZoomed = true;
          _isAnimating = false;
        });
      }
    });
  }

  void _resetZoom() {
    if (!mounted) return;

    setState(() => _isAnimating = true);

    _scaleAnimation = Tween<double>(begin: _scale, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _offsetAnimation = Tween<Offset>(begin: _offset, end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.reset();
    _animationController.forward().then((_) {
      if (mounted) {
        setState(() {
          _scale = 1.0;
          _offset = Offset.zero;
          _isZoomed = false;
          _isAnimating = false;
        });
      }
    });
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (!mounted) return;

    _previousScale = _scale;
    _previousOffset = details.localFocalPoint;
    setState(() {
      _isZoomed = true;
      _isDragging = true;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_isAnimating || !mounted) return;

    setState(() {
      _scale = (_previousScale * details.scale).clamp(0.5, 5.0);

      if ((_scale > 1.0 || _isLongImage) && _isDragging) {
        final Offset delta = details.localFocalPoint - _previousOffset;
        _offset += delta;
        _previousOffset = details.localFocalPoint;
      }
    });
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (_scale <= 1.0) {
      if (!_isLongImage) {
        _resetZoom(); 
      }
      return;
    }

    if (_imageSize == null) return;

    final screenSize = MediaQuery.of(context).size;
    final imageWidth = _imageSize!.width * _scale;
    final imageHeight = _imageSize!.height * _scale;

    final maxOffsetX = (imageWidth - screenSize.width) / 2;
    final maxOffsetY = (imageHeight - screenSize.height) / 2;

    final clampedX = _offset.dx.clamp(-maxOffsetX, maxOffsetX);
    final clampedY = _offset.dy.clamp(-maxOffsetY, maxOffsetY);

    if (clampedX != _offset.dx || clampedY != _offset.dy) {
      _animateToOffset(Offset(clampedX, clampedY));
    } else {
      setState(() => _isDragging = false);
    }
  }

  void _animateToOffset(Offset targetOffset) {
    if (!mounted) return;

    setState(() => _isAnimating = true);

    _offsetAnimation = Tween<Offset>(begin: _offset, end: targetOffset).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.reset();
    _animationController.forward().then((_) {
      if (mounted) {
        setState(() {
          _offset = targetOffset;
          _isAnimating = false;
          _isDragging = false;
        });
      }
    });
  }

  void _loadImageSize(String url) {
    if (!mounted) return;

    final ImageProvider imageProvider = _getImageProvider(url);
    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    imageStream.addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        if (!mounted) return;

        final imageSize = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );

        setState(() {
          _imageSize = imageSize;

          final screenSize = MediaQuery.of(context).size;
          final imageRatio = imageSize.height / imageSize.width;
          final screenRatio = screenSize.height / screenSize.width;

          _isLongImage =
              imageRatio > screenRatio && imageRatio >= _longImageRatio;

          debugPrint('图片尺寸: ${imageSize.width}x${imageSize.height}, '
              '宽高比: ${imageRatio.toStringAsFixed(2)}, '
              '是否长图: $_isLongImage');
        });
      }),
    );
  }

  ImageProvider _getImageProvider(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return NetworkImage(url);
    } else if (url.startsWith('file://')) {
      final filePath = url.substring(7);
      return FileImage(File(filePath));
    } else {
      return FileImage(File(url));
    }
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(
        url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.white, size: Constants.SPACE_50),
              SizedBox(height: Constants.SPACE_10),
              Text('图片加载失败', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    } else {
      final filePath = url.startsWith('file://') ? url.substring(7) : url;
      return Image.file(
        File(filePath),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.white, size: Constants.SPACE_50),
              const SizedBox(height: Constants.SPACE_10),
              const Text('图片加载失败', style: TextStyle(color: Colors.white)),
              const SizedBox(height: Constants.SPACE_5),
              Text('路径: $filePath',
                  style: const TextStyle(color: Colors.white54, fontSize: Constants.FONT_10)),
            ],
          ),
        ),
      );
    }
  }

  void _onPageChanged(int index) {
    if (!mounted) return;

    setState(() {
      _currentIndex = index;
      _resetZoom(); 
      _imageSize = null; 
      _isLongImage = false; 
      _loadImageSize(widget.imageProviders[index]);
    });
  }

  Widget _buildActionButton({
    required String svgPath,
    required String label,
    required VoidCallback onTap,
    double iconWidth = Constants.SPACE_20,
    double iconHeight = Constants.SPACE_20,
    bool keepOriginalColor = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgPath,
            package: 'module_imagepreview',
            width: iconWidth,
            height: iconHeight,
            colorFilter: keepOriginalColor
                ? null 
                : const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
          ),
          const SizedBox(height: Constants.SPACE_5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: Constants.SPACE_10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex == widget.initialIndex && _imageSize == null) {
      _loadImageSize(widget.imageProviders[_currentIndex]);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 图片浏览区域
          AbsorbPointer(
            absorbing: _isAnimating,
            child: GestureDetector(
              onTap: _handleImageTap,
              onDoubleTap: _handleDoubleTap,
              onLongPress: _handleLongPress, 
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onScaleEnd: _handleScaleEnd,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imageProviders.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final imageWidget =
                          _buildImage(widget.imageProviders[index]);

                      final transformedWidget = Transform(
                        transform: Matrix4.identity()
                          ..translate(
                            _isAnimating
                                ? _offsetAnimation.value.dx
                                : _offset.dx,
                            _isAnimating
                                ? _offsetAnimation.value.dy
                                : _offset.dy,
                          )
                          ..scale(
                              _isAnimating ? _scaleAnimation.value : _scale),
                        alignment: Alignment.center,
                        child: imageWidget,
                      );

                      if (index == _currentIndex &&
                          widget.heroTagPrefix != null) {
                        return Hero(
                          tag: '${widget.heroTagPrefix}_$index',
                          child: transformedWidget,
                        );
                      }
                      return transformedWidget;
                    },
                  );
                },
              ),
            ),
          ),

          // 顶部控制栏
          if (_showControls && !_isExpand)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: Constants.SPACE_0,
              left: Constants.SPACE_0,
              right: Constants.SPACE_0,
              child: Container(
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 左侧：作者信息
                      if (widget.authorId != null &&
                          widget.authorNickName != null)
                        Padding(
                          padding: const EdgeInsets.only(left: Constants.SPACE_18, top: Constants.SPACE_10),
                          child: AuthorCard(
                              cardData: _createNewsResponseForAuthor(),
                              isNeedAuthor: true,
                              isShowBigImage: true,
                              isFeedSelf: widget.isLogin &&
                                  widget.authorId == widget.currentUserId,
                              watchBuilder: () {
                                widget.onWatchOperation?.call();
                                setState(() {});
                              }),
                        ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),

          // 右侧：页码指示器
          Positioned(
            top: Constants.SPACE_15 + MediaQuery.of(context).padding.top,
            right: Constants.SPACE_18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_12, vertical: Constants.SPACE_6),
              constraints: const BoxConstraints(minWidth: Constants.SPACE_50),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.9), 
                borderRadius: BorderRadius.circular(Constants.SPACE_16),
              ),
              child: Text(
                '${_currentIndex + 1} / ${widget.imageProviders.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Constants.Text_COLOR, 
                  fontSize: Constants.FONT_12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          // 底部操作栏 - 只有当有作者信息时才显示
          if (_showControls && widget.authorId != null)
            Positioned(
              bottom: Constants.SPACE_28,
              left: Constants.SPACE_20,
              right: Constants.SPACE_20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 左侧：展开/收起按钮
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpand = !_isExpand;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 圆形图标按钮
                        Container(
                          width: Constants.SPACE_24,
                          height: Constants.SPACE_24,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(Constants.SPACE_12),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              _isExpand ? Constants.downImage : Constants.upImage,
                              package: 'module_imagepreview',
                              width: Constants.SPACE_17,
                              height: Constants.SPACE_9,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _isExpand ? '收起' : '展开',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: Constants.FONT_16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 右侧：评论、点赞、分享按钮（仅在未展开时显示）
                  if (!_isExpand)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton(
                          svgPath: Constants.imageCommentImage,
                          label: widget.commentCount.toString(),
                          onTap: () {
                            if (_navigator != null) {
                              _navigator!.pop();
                            } else {
                              Navigator.of(context).pop();
                            }
                            widget.onAddComment?.call();
                          },
                          iconWidth: Constants.SPACE_20,
                          iconHeight: Constants.SPACE_20,
                        ),
                        const SizedBox(width: Constants.SPACE_25),

                        _buildActionButton(
                          svgPath: _localIsLiked
                              ? Constants.likeActiveImage
                              : Constants.previewLikeImage,
                          label: _localLikeCount.toString(),
                          onTap: () {
                            final newIsLiked = !_localIsLiked;
                            final newLikeCount = newIsLiked
                                ? _localLikeCount + 1
                                : (_localLikeCount > 0
                                    ? _localLikeCount - 1
                                    : 0);

                            setState(() {
                              _localIsLiked = newIsLiked;
                              _localLikeCount = newLikeCount;
                            });

                            widget.onNewsLike?.call();
                          },
                          iconWidth: Constants.SPACE_23,
                          iconHeight: Constants.SPACE_20,
                          keepOriginalColor: true, 
                        ),
                        const SizedBox(width: Constants.SPACE_25),

                        GestureDetector(
                          onTap: () {
                            if (!mounted) return;
                            widget.onShare?.call();
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                Constants.imageForwardImage,
                                package: 'module_imagepreview',
                                width: Constants.SPACE_21,
                                height: Constants.SPACE_21,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(height: Constants.SPACE_5),
                              Text(
                                widget.shareCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: Constants.FONT_10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

          if (_isZoomed)
            Positioned(
              right: Constants.SPACE_20,
              bottom: Constants.SPACE_100,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.black54,
                onPressed: _resetZoom,
                child: const Icon(Icons.zoom_out_map, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
