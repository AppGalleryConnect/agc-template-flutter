import 'package:flutter/material.dart';
import '../commons/constants.dart';

class FeedSingleImageSize extends StatefulWidget {
  final String componentId;
  final dynamic curFeedCardInfo;
  final dynamic postImgListItem;
  final bool isLast;
  final int truncatedCount;
  final VoidCallback onVideo;
  final VoidCallback onImageClick;
  const FeedSingleImageSize({
    super.key,
    required this.componentId,
    required this.curFeedCardInfo,
    required this.postImgListItem,
    this.isLast = false,
    this.truncatedCount = 0,
    this.onVideo = defaultCallback,
    this.onImageClick = defaultCallback,
  });
  static void defaultCallback() {}

  @override
  State<FeedSingleImageSize> createState() => _FeedSingleImageSizeState();
}

class _FeedSingleImageSizeState extends State<FeedSingleImageSize> {
  dynamic modifier;

  @override
  void initState() {
    super.initState();
  }

  bool get getImageRestPosition {
    return widget.truncatedCount > 0 && widget.isLast;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(Constants.feedSingleImageBorderRadius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // 图片显示部分
              Visibility(
                visible: (widget.postImgListItem?.surfaceUrl ?? '').isEmpty,
                child: Expanded(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: widget.onImageClick,
                        child: Image.network(
                          widget.postImgListItem?.picVideoUrl ?? '',
                          fit: BoxFit.cover,
                          width: constraints.maxWidth,
                          height: constraints.maxWidth,
                        ),
                      ),
                      Visibility(
                        visible: getImageRestPosition,
                        child: Container(
                          margin: const EdgeInsets.only(
                            right: Constants.feedSingleImageTruncatedTextMargin,
                            bottom:
                                Constants.feedSingleImageTruncatedTextMargin,
                          ),
                          child: Text(
                            '+ ${widget.truncatedCount}',
                            style: const TextStyle(
                              fontSize: Constants
                                  .feedSingleImageTruncatedTextFontSize,
                              fontWeight: FontWeight.bold,
                              color: Constants.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: (widget.postImgListItem?.surfaceUrl ?? '').isNotEmpty,
                child: Expanded(
                  child: GestureDetector(
                    onTap: widget.onVideo,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: constraints.maxWidth,
                          height: Constants.feedSingleImageVideoContainerHeight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.postImgListItem?.surfaceUrl ?? '',
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(
                              Constants.feedSingleImageBorderRadius,
                            ),
                          ),
                        ),
                        // 播放按钮
                        Container(
                          width: Constants.feedSingleImagePlayButtonWidth,
                          height: Constants.feedSingleImagePlayButtonHeight,
                          decoration: const BoxDecoration(
                            color: Constants.whiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Constants.blackColor,
                            size: Constants.feedSingleImagePlayIconSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
