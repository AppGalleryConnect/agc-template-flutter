import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/recommend_model.dart';
import '../utils/utils.dart';
import 'package:module_newsfeed/constants/constants.dart';

class FeedSingleImageSize extends StatefulWidget {
  final PostMedia postImgListItem;
  final FeedCardInfo curFeedCardInfo;
  final List<String> imageList;
  final int index;
  final String componentId;
  final bool isWatch;
  final bool isFeedSelf;
  final double fontSizeRatio;
  final double imageWidth;
  final double imageHeight;
  final VoidCallback onAddWatch;
  final VoidCallback onAddLike;
  final VoidCallback onAddComment;
  final VoidCallback onVideo;
  final bool hasContent;

  const FeedSingleImageSize({
    super.key,
    required this.postImgListItem,
    required this.curFeedCardInfo,
    required this.imageList,
    required this.index,
    required this.componentId,
    this.isWatch = false,
    this.isFeedSelf = false,
    this.fontSizeRatio = 1.0,
    this.imageWidth = 0,
    this.imageHeight = 0,
    required this.onAddWatch,
    required this.onAddLike,
    required this.onAddComment,
    required this.onVideo,
    this.hasContent = true,
  });

  @override
  State<FeedSingleImageSize> createState() => _FeedSingleImageSizeState();
}

class _FeedSingleImageSizeState extends State<FeedSingleImageSize>
    with SingleTickerProviderStateMixin {
  bool _isExpand = false;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() => _isExpand = !_isExpand);
    _isExpand ? _expandController.forward() : _expandController.reverse();
  }

  void _autoCollapse() {
    _toggleExpand();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _isExpand) _toggleExpand();
    });
  }

  void _showMultiImagePreview() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => _MultiImageBrowser(
          imageList: widget.imageList,
          initialIndex: widget.index,
          curFeedCardInfo: widget.curFeedCardInfo,
          isWatch: widget.isWatch,
          isFeedSelf: widget.isFeedSelf,
          fontSizeRatio: widget.fontSizeRatio,
          hasContent: widget.hasContent,
          onAddWatch: widget.onAddWatch,
          onAddLike: widget.onAddLike,
          onAddComment: widget.onAddComment,
          onClose: _autoCollapse,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Constants.SPACE_8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Constants.SPACE_12),
        child: SizedBox(
          width: widget.imageWidth,
          height: widget.imageHeight,
          child: Stack(
            children: [
              // 图片/视频封面展示
              Visibility(
                visible: widget.postImgListItem.thumbnailUrl.isEmpty,
                child: GestureDetector(
                  onTap: _showMultiImagePreview,
                  child: Stack(
                    children: [
                      Image.network(
                        widget.postImgListItem.url,
                        width: widget.imageWidth,
                        height: widget.imageHeight,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          Constants.iconsIconDefaultImage,
                          width: widget.imageWidth,
                          height: widget.imageHeight,
                        ),
                      ),
                      // 多图指示器
                      if (widget.imageList.length > 1)
                        Positioned(
                          top: Constants.SPACE_8,
                          right: Constants.SPACE_8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.SPACE_8,
                                vertical: Constants.SPACE_4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius:
                                  BorderRadius.circular(Constants.SPACE_12),
                            ),
                            child: Text(
                              '${widget.index + 1}/${widget.imageList.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: Constants.FONT_12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // 视频封面+播放按钮
              Visibility(
                visible: widget.postImgListItem.thumbnailUrl.isNotEmpty,
                child: GestureDetector(
                  onTap: widget.onVideo,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        widget.postImgListItem.thumbnailUrl,
                        width: widget.imageWidth,
                        height: widget.imageHeight,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          Constants.iconsIconDefaultImage,
                          width: widget.imageWidth,
                          height: widget.imageHeight,
                        ),
                      ),
                      Icon(Icons.play_circle_filled,
                          size: Constants.SPACE_48,
                          color: Colors.white.withOpacity(0.8)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MultiImageBrowser extends StatefulWidget {
  final List<String> imageList;
  final int initialIndex;
  final FeedCardInfo curFeedCardInfo;
  final bool isWatch;
  final bool isFeedSelf;
  final double fontSizeRatio;
  final bool hasContent;
  final VoidCallback onAddWatch;
  final VoidCallback onAddLike;
  final VoidCallback onAddComment;
  final VoidCallback onClose;

  const _MultiImageBrowser({
    required this.imageList,
    required this.initialIndex,
    required this.curFeedCardInfo,
    required this.isWatch,
    required this.isFeedSelf,
    required this.fontSizeRatio,
    required this.hasContent,
    required this.onAddWatch,
    required this.onAddLike,
    required this.onAddComment,
    required this.onClose,
  });

  @override
  State<_MultiImageBrowser> createState() => _MultiImageBrowserState();
}

class _MultiImageBrowserState extends State<_MultiImageBrowser> {
  late PageController _pageController;
  late int _currentIndex;
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _previousOffset = Offset.zero;
  bool _isZoomed = false;
  final bool _showControls = true;
  bool _isAnimating = false;
  bool _isContentExpanded = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleImageTap() {
    if (_isAnimating) return;

    if (_isZoomed || _scale > 1.1) {
      _resetZoom();
    } else {
      _navigateBack();
    }
  }

  void _handleDoubleTap() {
    if (_isAnimating) return;

    if (_scale > 1.5) {
      _resetZoom();
    } else {
      setState(() {
        _scale = 2.0;
        _isZoomed = true;
      });
    }
  }

  void _resetZoom() {
    setState(() {
      _isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
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
    _previousScale = _scale;
    _previousOffset = details.localFocalPoint;
    setState(() {
      _isZoomed = true;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_isAnimating) return;

    setState(() {
      _scale = (_previousScale * details.scale).clamp(0.8, 5.0);
      final Offset currentOffset = details.localFocalPoint;
      final Offset delta = currentOffset - _previousOffset;
      _offset += delta;
      _previousOffset = currentOffset;
    });
  }

  void _navigateBack() {
    Navigator.of(context).pop();
    widget.onClose();
  }

  void _toggleContentExpand() {
    setState(() {
      _isContentExpanded = !_isContentExpanded;
    });
  }

  Widget _buildContentArea() {
    if (!widget.hasContent || widget.curFeedCardInfo.richContent!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 展开/收起按钮
        if (widget.curFeedCardInfo.richContent!.length > 100)
          GestureDetector(
            onTap: _toggleContentExpand,
            child: Row(
              children: [
                Container(
                  width: Constants.SPACE_24,
                  height: Constants.SPACE_24,
                  decoration: BoxDecoration(
                    color: Colors.grey[800]?.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(Constants.SPACE_12),
                  ),
                  child: Center(
                    child: Icon(
                      _isContentExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.white,
                      size: Constants.SPACE_16,
                    ),
                  ),
                ),
                const SizedBox(width: Constants.SPACE_8),
                Text(
                  _isContentExpanded ? '收起' : '展开',
                  style: TextStyle(
                    fontSize: Constants.FONT_14 * widget.fontSizeRatio,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Text(
            widget.curFeedCardInfo.richContent!,
            style: TextStyle(
              fontSize: Constants.FONT_14 * widget.fontSizeRatio,
              color: Colors.white,
              height: Constants.SPACE_1_4,
            ),
            maxLines: _isContentExpanded ? null : 3,
            overflow: _isContentExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // 构建作者信息（根据是否有内容调整布局）
  Widget _buildAuthorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      widget.curFeedCardInfo.author.authorIcon,
                      width: Constants.SPACE_36 * widget.fontSizeRatio,
                      height: Constants.SPACE_36 * widget.fontSizeRatio,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        Constants.iconsIconDefaultImage,
                        width: Constants.SPACE_36 * widget.fontSizeRatio,
                        height: Constants.SPACE_36 * widget.fontSizeRatio,
                      ),
                    ),
                  ),
                  const SizedBox(width: Constants.SPACE_12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.curFeedCardInfo.author.authorNickName,
                          style: TextStyle(
                            fontSize: Constants.FONT_16 * widget.fontSizeRatio,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.curFeedCardInfo.title.isNotEmpty)
                          Text(
                            widget.curFeedCardInfo.title,
                            style: TextStyle(
                              fontSize: 14 * widget.fontSizeRatio,
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!widget.isFeedSelf)
              GestureDetector(
                onTap: widget.onAddWatch,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.SPACE_16,
                      vertical: Constants.SPACE_8),
                  decoration: BoxDecoration(
                    color: widget.isWatch
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Constants.SPACE_16),
                  ),
                  child: Text(
                    widget.isWatch ? '已关注' : '关注',
                    style: TextStyle(
                      fontSize: Constants.FONT_14 * widget.fontSizeRatio,
                      color: widget.isWatch
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (widget.hasContent && widget.curFeedCardInfo.richContent!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: Constants.SPACE_12),
            child: _buildContentArea(),
          ),
      ],
    );
  }

  Widget _buildImagePage(String imageUrl, int index) {
    return GestureDetector(
      onTap: _handleImageTap,
      onDoubleTap: _handleDoubleTap,
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      child: AbsorbPointer(
        absorbing: _isAnimating,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Transform(
            transform: Matrix4.identity()
              ..translate(_offset.dx, _offset.dy)
              ..scale(_scale),
            alignment: Alignment.center,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error,
                        color: Colors.white, size: Constants.SPACE_50),
                    SizedBox(height: Constants.SPACE_10),
                    Text('图片加载失败', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 图片浏览区域
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageList.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _resetZoom();
              });
            },
            itemBuilder: (context, index) {
              return _buildImagePage(widget.imageList[index], index);
            },
          ),

          if (_showControls)
            Positioned(
              top: Constants.SPACE_0,
              left: Constants.SPACE_0,
              right: Constants.SPACE_0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + Constants.SPACE_16,
                  left: Constants.SPACE_16,
                  right: Constants.SPACE_16,
                  bottom: Constants.SPACE_16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: Constants.SPACE_28),
                          onPressed: _navigateBack,
                        ),
                        const Spacer(),
                        Text(
                          '${_currentIndex + 1}/${widget.imageList.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: Constants.FONT_18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: Constants.SPACE_48),
                      ],
                    ),
                    const SizedBox(height: Constants.SPACE_16),
                    _buildAuthorInfo(),
                    if (widget.hasContent)
                      Padding(
                        padding: const EdgeInsets.only(top: Constants.SPACE_16),
                        child: _buildOperationBar(),
                      ),
                  ],
                ),
              ),
            ),

          if (_showControls && widget.imageList.length > 1)
            Positioned(
              bottom:
                  widget.hasContent ? Constants.SPACE_100 : Constants.SPACE_30,
              left: Constants.SPACE_0,
              right: Constants.SPACE_0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageList.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _currentIndex == index
                        ? Constants.SPACE_20
                        : Constants.SPACE_8,
                    height: Constants.SPACE_8,
                    margin: const EdgeInsets.symmetric(
                        horizontal: Constants.SPACE_4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Constants.SPACE_4),
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white54,
                    ),
                  );
                }),
              ),
            ),

          if (_showControls && !widget.hasContent)
            Positioned(
              bottom: Constants.SPACE_80,
              left: Constants.SPACE_0,
              right: Constants.SPACE_0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildHintItem(Icons.zoom_in, '双指缩放'),
                      _buildHintItem(Icons.touch_app, '双击放大'),
                      _buildHintItem(
                          Icons.tap_and_play, _isZoomed ? '单击缩小' : '单击返回'),
                    ],
                  ),
                ],
              ),
            ),

          if (_isZoomed && !_showControls)
            Positioned(
              top: MediaQuery.of(context).padding.top + Constants.SPACE_10,
              left: Constants.SPACE_0,
              right: Constants.SPACE_0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.SPACE_16,
                      vertical: Constants.SPACE_8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(Constants.SPACE_20),
                  ),
                  child: const Text(
                    '单击缩小图片',
                    style: TextStyle(
                        color: Colors.white, fontSize: Constants.FONT_12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOperationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildOperationButton(
              Icons.comment,
              '评论',
              formatToK(widget.curFeedCardInfo.commentCount),
              () {
                _navigateBack();
                widget.onAddComment();
              },
            ),
            const SizedBox(width: Constants.SPACE_20),
            _buildOperationButton(
              widget.curFeedCardInfo.isLiked
                  ? Icons.favorite
                  : Icons.favorite_border,
              '点赞',
              formatToK(widget.curFeedCardInfo.likeCount),
              widget.onAddLike,
            ),
            const SizedBox(width: Constants.SPACE_20),
            _buildOperationButton(
              Icons.share,
              '分享',
              formatToK(widget.curFeedCardInfo.shareCount),
              () {
                final shareInfo = {
                  'id': widget.curFeedCardInfo.id,
                  'title': widget.curFeedCardInfo.title,
                  'imageUrl': widget.imageList[_currentIndex],
                };
                Clipboard.setData(ClipboardData(text: shareInfo.toString()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('图片链接已复制')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOperationButton(
      IconData icon, String text, String count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: Constants.SPACE_24),
          const SizedBox(height: Constants.SPACE_4),
          Text(
            count,
            style: TextStyle(
              fontSize: Constants.FONT_10 * widget.fontSizeRatio,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.white54, size: Constants.SPACE_20),
        const SizedBox(height: Constants.SPACE_4),
        Text(
          text,
          style: const TextStyle(
              color: Colors.white54, fontSize: Constants.FONT_12),
        ),
      ],
    );
  }
}
