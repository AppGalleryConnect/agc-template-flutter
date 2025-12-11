import 'package:flutter/material.dart';
import '../common/common_utils.dart';
import '../common/constants.dart';
import '../services/response_model.dart';
import 'dart:io';

class RecordCard extends StatelessWidget {
  final FeedbackResponseParams record;
  final double fontSizeRatio;

  const RecordCard({super.key, required this.record, this.fontSizeRatio = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Constants.SPACE_16),
      ),
      padding: const EdgeInsets.all(Constants.SPACE_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CommonUtils.handleDateTime(record.createTime),
            style: TextStyle(
              fontSize: Constants.FONT_12 * fontSizeRatio,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: Constants.SPACE_12),
          Text(
            '问题描述',
            style: TextStyle(
              fontSize: Constants.FONT_16 * fontSizeRatio,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: Constants.SPACE_8),
          Text(
            record.problemDesc,
            style: TextStyle(
              fontSize: Constants.FONT_12 * fontSizeRatio,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: Constants.SPACE_12),
          Text(
            '问题截图',
            style: TextStyle(
              fontSize: Constants.FONT_16 * fontSizeRatio,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              height: Constants.SPACE_1, 
            ),
          ),
          const SizedBox(height: Constants.SPACE_8),
          if (record.screenShots.isNotEmpty)
            Wrap(
              spacing: Constants.SPACE_8, 
              runSpacing: Constants.SPACE_8, 
              children: record.screenShots.map((imagePath) {
                final screenWidth =
                    MediaQuery.of(context).size.width - Constants.SPACE_16 * 4;
                final imageSize = (screenWidth - 16) / 3;

                final imageIndex = record.screenShots.indexOf(imagePath);
                return SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  _ImagePreviewScreen(
                            images: record.screenShots,
                            initialIndex: imageIndex,
                            heroTagPrefix: 'feedback_${record.createTime}',
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return child;
                          },
                          opaque: false, 
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'feedback_${record.createTime}_image_$imageIndex',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Constants.SPACE_8),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          else
            Container(
              height: Constants.SPACE_100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(Constants.SPACE_8),
              ),
              child: Center(
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  size: Constants.SPACE_24 * fontSizeRatio,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 自定义图片预览页面，实现平滑过渡效果
class _ImagePreviewScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String heroTagPrefix;

  const _ImagePreviewScreen(
      {required this.images,
      required this.initialIndex,
      required this.heroTagPrefix});

  @override
  State<_ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<_ImagePreviewScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _closePreview() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            Container(
              color: Colors.black,
            ),
            // 图片查看区域
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: _updateCurrentIndex,
              itemBuilder: (context, index) {
                final imagePath = widget.images[index];

                return GestureDetector(
                  onTap: _closePreview,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Hero(
                      tag: '${widget.heroTagPrefix}_image_$index',
                      createRectTween: (begin, end) =>
                          MaterialRectCenterArcTween(begin: begin, end: end),
                      child: InteractiveViewer(
                        constrained: true,
                        panEnabled: true,
                        scaleEnabled: true,
                        minScale: 0.5,
                        maxScale: 5.0,
                        boundaryMargin: EdgeInsets.zero,
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // 顶部关闭按钮
            Positioned(
              top: MediaQuery.of(context).padding.top + Constants.SPACE_20,
              right: Constants.SPACE_20,
              child: GestureDetector(
                onTap: _closePreview,
                child: Container(
                  width: Constants.SPACE_40,
                  height: Constants.SPACE_40,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: Constants.SPACE_24,
                  ),
                ),
              ),
            ),

            // 底部页码指示器
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + Constants.SPACE_30,
              left: Constants.SPACE_0,
              right: Constants.SPACE_0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Constants.SPACE_16, vertical: Constants.SPACE_8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(Constants.SPACE_20),
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${widget.images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: Constants.FONT_14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
