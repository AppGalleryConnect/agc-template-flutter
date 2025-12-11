import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_news_api/observedmodels/news_model.dart';
import 'package:lib_news_api/constants/constants.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';
import '../constants/constants.dart' as MineConstants;

class UniformNewsStyle {
  final double? bodyFg;
  final Color? bodyFgColor;
  final double? imgRatio;

  // 将构造函数标记为const
  const UniformNewsStyle({
    this.bodyFg,
    this.bodyFgColor,
    this.imgRatio,
  });
}

class UniformNewsCard extends StatelessWidget {
  final NewsModel newsInfo;
  final bool showAuthorInfoTop;
  final bool showAuthorInfoBottom;
  final UniformNewsStyle customStyle;
  final Widget Function() operateBuilder;

  const UniformNewsCard({
    super.key,
    required this.newsInfo,
    this.showAuthorInfoTop = false,
    this.showAuthorInfoBottom = true,
    UniformNewsStyle? customStyle,
    required this.operateBuilder,
  }) : customStyle = customStyle ??
            const UniformNewsStyle(
              bodyFg: MineConstants.Constants.textPrimarySize,
              bodyFgColor: MineConstants.Constants.newsCardTextPrimaryColor,
              imgRatio: 1.0,
            );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsInfo.title,
                    style: TextStyle(
                      fontSize: (customStyle.bodyFg ??
                              MineConstants.Constants.textPrimarySize) *
                          FontScaleUtils.fontSizeRatio,
                      color: customStyle.bodyFgColor ??
                          MineConstants.Constants.newsCardTextPrimaryColor,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Visibility(
                    visible: showAuthorInfoTop,
                    child: authorInfo(),
                  ),
                ],
              ),
            ),
            if (videoUrl.isNotEmpty || imgUrl.isNotEmpty) ...[
              const SizedBox(width: CommonConstants.SPACE_S),
              Align(
                alignment: Alignment.topRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.4,
                  ),
                  child: videoUrl.isNotEmpty
                      ? _buildVideoThumbnail()
                      : _buildImageThumbnail(),
                ),
              ),
            ],
          ],
        ),
        Visibility(
          visible: showAuthorInfoBottom,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              authorInfo(),
              operateBuilder(),
            ],
          ),
        ),
      ],
    );
  }

  Widget authorInfo() {
    return Row(
      children: [
        Text(
          newsInfo.author?.authorNickName ?? '',
          style: TextStyle(
            fontSize: MineConstants.Constants.textTertiarySize *
                FontScaleUtils.fontSizeRatio,
            color: MineConstants.Constants.newsCardTextSecondaryColor,
          ),
        ),
        const SizedBox(width: CommonConstants.PADDING_S),
        Text(
          TimeUtils.getDateDiff(newsInfo.createTime),
          style: TextStyle(
            fontSize: MineConstants.Constants.textTertiarySize *
                FontScaleUtils.fontSizeRatio,
            color: MineConstants.Constants.newsCardTextSecondaryColor,
          ),
        ),
      ],
    );
  }

  String get imgUrl {
    if (newsInfo.postImgList != null && newsInfo.postImgList!.isNotEmpty) {
      return newsInfo.postImgList![0].picVideoUrl;
    }
    return '';
  }

  String get videoUrl {
    if (newsInfo.postImgList != null && newsInfo.postImgList!.isNotEmpty) {
      final videoItem = newsInfo.postImgList!.firstWhere(
        (item) => item.surfaceUrl.isNotEmpty == true,
        orElse: () => newsInfo.postImgList![0],
      );
      if (videoItem.surfaceUrl.isNotEmpty == true) {
        return videoItem.surfaceUrl;
      }
    }
    if (newsInfo.type == NewsEnum.video && newsInfo.videoUrl != null) {
      return newsInfo.videoUrl!;
    }
    return '';
  }

  Widget _buildVideoThumbnail() {
    final imgRatio = customStyle.imgRatio ?? 1;
    final width = MineConstants.Constants.newsImageWidth / imgRatio;
    final height = MineConstants.Constants.newsImageHeight / imgRatio;
    if (videoUrl.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: MineConstants.Constants.newsCardPlaceholderBgColor,
            borderRadius: BorderRadius.circular(
                MineConstants.Constants.newsCardBorderRadius),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.video_library,
                size: MineConstants.Constants.newsCardVideoIconSize,
                color: MineConstants.Constants.newsCardPlaceholderIconColor,
              ),
              Positioned(
                bottom: MineConstants.Constants.newsCardPositionOffset,
                right: MineConstants.Constants.newsCardPositionOffset,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CommonConstants.PADDING_XS,
                    vertical: CommonConstants.PADDING_XXS,
                  ),
                  decoration: BoxDecoration(
                    color: MineConstants.Constants.newsCardBlackOverlayColor,
                    borderRadius: BorderRadius.circular(
                        MineConstants.Constants.newsCardBorderRadius / 2),
                  ),
                  child: Text(
                    TimeUtils.handleDuration(newsInfo.videoDuration),
                    style: TextStyle(
                      fontSize: MineConstants.Constants.textQuaternarySize *
                          FontScaleUtils.fontSizeRatio,
                      color: MineConstants.Constants.newsCardWhiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
                MineConstants.Constants.newsCardBorderRadius),
            child: videoUrl.startsWith('file://')
                ? Image.file(
                    File(videoUrl.substring(7)),
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildVideoPlaceholder();
                    },
                  )
                : Image.network(
                    videoUrl,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildVideoPlaceholder();
                    },
                  ),
          ),
          Image.asset(
            MineConstants.Constants.icPublicVideoPlay,
            width: MineConstants.Constants.newsCardPlayIconSize,
            height: MineConstants.Constants.newsCardPlayIconSize,
          ),
          Positioned(
            bottom: MineConstants.Constants.newsCardPositionOffset,
            right: MineConstants.Constants.newsCardPositionOffset,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: CommonConstants.PADDING_XS,
                vertical: CommonConstants.PADDING_XXS,
              ),
              decoration: BoxDecoration(
                color: MineConstants.Constants.newsCardBlackOverlayColor,
                borderRadius: BorderRadius.circular(
                    MineConstants.Constants.newsCardBorderRadius / 2),
              ),
              child: Text(
                TimeUtils.handleDuration(newsInfo.videoDuration),
                style: TextStyle(
                  fontSize: MineConstants.Constants.textQuaternarySize *
                      FontScaleUtils.fontSizeRatio,
                  color: MineConstants.Constants.newsCardWhiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建视频占位符
  Widget _buildVideoPlaceholder() {
    return Container(
      color: MineConstants.Constants.newsCardPlaceholderBgColor,
      child: const Center(
        child: Icon(
          Icons.video_library,
          size: MineConstants.Constants.newsCardVideoIconSize,
          color: MineConstants.Constants.newsCardPlaceholderIconColor,
        ),
      ),
    );
  }

  Widget _buildImageThumbnail() {
    final imgRatio = customStyle.imgRatio ?? 1;
    final width = MineConstants.Constants.newsImageWidth / imgRatio;
    final height = MineConstants.Constants.newsImageHeight / imgRatio;

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(MineConstants.Constants.newsCardBorderRadius),
      child: Image.network(
        imgUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
