import 'package:business_video/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/utils/format_count.dart';
import 'package:lib_news_api/constants/constants.dart';
import '../home_page/widgets/base_image.dart';
import '../commons/constants.dart';

class VerticalBigImageCard extends StatelessWidget {
  final NewsResponse cardData;
  final Function(String id)? onTap;
  final double fontSizeRatio;

  const VerticalBigImageCard(this.cardData,
      {super.key, required this.onTap, this.fontSizeRatio = 1.0});

  @override
  Widget build(BuildContext context) {
    final surfaceUrl = _getSurface(cardData);
    return GestureDetector(
      onTap: () {
        VideoNewsData videoData = VideoNewsData.fromCommentResponse(cardData);
        RouterUtils.of
            .pushPathByName(RouterMap.VIDEO_PLAY_PAGE, param: videoData);
      },
      child: Container(
        height: Constants.verticalBigImageCardHeight,
        width: Constants.verticalBigImageCardWidth,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(Constants.verticalBigImageCardBorderRadius),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            BaseImage(
              url: surfaceUrl ?? '',
              fit: BoxFit.fill,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.play_arrow,
                            size: Constants.verticalBigImageCardPlayIconSize,
                            color: Colors.white),
                        const SizedBox(
                          width:
                              Constants.verticalBigImageCardHorizontalSpacing,
                        ),
                        Text(
                          '${FormatCount.formatToK(int.tryParse(cardData.playCount ?? '0') ?? 0)}次播放',
                          style: TextStyle(
                            fontSize:
                                Constants.verticalBigImageCardSubtitleFontSize *
                                    fontSizeRatio,
                            color: Constants.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Constants.verticalBigImageCardVerticalSpacing,
                    ),
                    Text(
                      cardData.title,
                      style: TextStyle(
                        fontSize: Constants.verticalBigImageCardTitleFontSize *
                            fontSizeRatio,
                        color: Constants.whiteColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String? _getSurface(NewsResponse cardData) {
    if (cardData.type == NewsEnum.video) {
      return cardData.postImgList?.firstOrNull?.surfaceUrl;
    } else {
      return cardData.postImgList?.firstOrNull?.picVideoUrl;
    }
  }
}
