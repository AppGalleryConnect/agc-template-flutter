import 'package:flutter/material.dart';
import 'package:module_imagepreview/constants/constants.dart';

class Imagepreviewbrower extends StatefulWidget {
  final List<ImageProvider> imageProviders;
  final int initialIndex;

  const Imagepreviewbrower({
    super.key,
    required this.imageProviders,
    this.initialIndex = 0,
  });

  @override
  _CustomImageViewerState createState() => _CustomImageViewerState();
}

class _CustomImageViewerState extends State<Imagepreviewbrower> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showControls = true;

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

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 图片浏览区域
          GestureDetector(
            onTap: _toggleControls,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageProviders.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.1,
                  maxScale: 5.0,
                  panEnabled: true,
                  scaleEnabled: true,
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  child: Image(
                    image: widget.imageProviders[index],
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),

          // 顶部控制栏
          if (_showControls) _buildAppBar(),

          // 底部指示器
          if (_showControls && widget.imageProviders.length > 1)
            _buildIndicator(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: Constants.SPACE_0,
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      child: Container(
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
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
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Row(
            children: [
              IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: Constants.SPACE_28),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${_currentIndex + 1}/${widget.imageProviders.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: Constants.FONT_18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info, color: Colors.white, size: Constants.SPACE_28),
                onPressed: _showInfo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: Constants.SPACE_20,
      left: Constants.SPACE_0,
      right: Constants.SPACE_0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.imageProviders.length, (index) {
          return Container(
            width: _currentIndex == index ? Constants.SPACE_20 : Constants.SPACE_8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: Constants.SPACE_4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.SPACE_4),
              color: _currentIndex == index ? Colors.white : Colors.white54,
            ),
          );
        }),
      ),
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('图片信息'),
        content: Text('当前图片: ${_currentIndex + 1}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
