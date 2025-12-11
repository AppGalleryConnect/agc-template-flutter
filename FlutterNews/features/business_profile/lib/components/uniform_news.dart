import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_news_api/constants/constants.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/observedmodels/news_model.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:business_mine/utils/content_navigation_utils.dart';
import '../common/constants.dart';

class UniformNews extends StatelessWidget {
  final NewsResponse newsInfo;
  final double fontSizeRatio;

  const UniformNews({
    super.key,
    required this.newsInfo,
    this.fontSizeRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newsInfo.title,
                  style: TextStyle(
                    fontSize: 16 * fontSizeRatio,
                    color: Theme.of(context).textTheme.bodyLarge?.color ??
                        const Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  TimeUtils.getDateDiff(newsInfo.createTime),
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.bodySmall?.fontSize ?? 12.0,
                    color: Theme.of(context).textTheme.bodySmall?.color ??
                        const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: CommonConstants.SPACE_M),
          _buildMediaContent(context),
        ],
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context) {
    if (videoUrl.isNotEmpty) {
      return SizedBox(
        width: 96,
        height: 72,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                videoUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                ),
              ),
            ),
            Center(
              child: SvgPicture.asset(
                Constants.VIDEO_PLAY_ICON_PATH,
                width: Constants.videoPlayIconSize,
                height: Constants.videoPlayIconSize,
                color: Colors.white,
                placeholderBuilder: (context) => const Icon(Icons.play_arrow,
                    size: Constants.videoPlayIconSize, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  CommonConstants.PADDING_XS,
                  CommonConstants.PADDING_XXS,
                  CommonConstants.PADDING_XS,
                  CommonConstants.PADDING_XXS,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  TimeUtils.handleDuration(newsInfo.videoDuration),
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.labelSmall?.fontSize ??
                            10.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (imgUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          imgUrl,
          width: 96,
          height: 72,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
          ),
        ),
      );
    }
    return const SizedBox();
  }

  void _handleTap(BuildContext context) {
    final NewsModel newsModel = NewsModel.fromNewsResponse(newsInfo);
    ContentNavigationUtils.navigateToDetailFromAnySource(newsModel,
        source: 'profile');
  }

  String get imgUrl {
    if (newsInfo.postImgList != null && newsInfo.postImgList!.isNotEmpty) {
      return newsInfo.postImgList![0].picVideoUrl;
    }
    return '';
  }

  String get videoUrl {
    if (newsInfo.type == NewsEnum.video) {
      return newsInfo.coverUrl ?? '';
    }
    if (newsInfo.postImgList != null && newsInfo.postImgList!.isNotEmpty) {
      return newsInfo.postImgList![0].surfaceUrl;
    }
    return '';
  }
}
