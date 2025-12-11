import 'package:flutter/material.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:module_flutter_highlight/views/high_light.dart';
import '../commons/constants.dart';
import '../home_page/widgets/article_source_builder.dart';
import '../home_page/widgets/author_builder.dart';

class TopTextBottomBigImageCard extends StatelessWidget {
  final NewsResponse cardData;
  final Function(String id)? onAuthorTap;
  final double fontSizeRatio;

  const TopTextBottomBigImageCard(this.cardData,
      {super.key, this.onAuthorTap, this.fontSizeRatio = 1.0});

  @override
  Widget build(BuildContext context) {
    return NativeComponent(
      cardData: cardData,
      onAuthorTap: onAuthorTap,
      fontSizeRatio: fontSizeRatio,
    );
  }
}

class NativeComponent extends StatefulWidget {
  final Function(String id)? onAuthorTap;
  final VoidCallback? onWatchClick;
  final NewsResponse cardData;
  final double fontSizeRatio;

  const NativeComponent(
      {super.key,
      required this.cardData,
      this.onWatchClick,
      this.onAuthorTap,
      this.fontSizeRatio = 1.0});

  @override
  State<NativeComponent> createState() => _NativeComponentState();
}

class _NativeComponentState extends State<NativeComponent> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final autoerInfo = widget.cardData.extraInfo?["isNeedAuthor"];
    final isNeedAuthor = autoerInfo != null && autoerInfo == true;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthorCard(
            cardData: widget.cardData,
            isNeedAuthor: isNeedAuthor,
            avatarBuilder: (id) => widget.onAuthorTap?.call(id),
            watchBuilder: () => widget.onWatchClick?.call(),
            fontSizeRatio: widget.fontSizeRatio,
          ),
          const SizedBox(height: Constants.topBottomCardVerticalSpacing),
          if (widget.cardData.extraInfo?["searchKey"] != null)
            Highlight(
              keywords: [widget.cardData.extraInfo!["searchKey"].toString()],
              sourceString: widget.cardData.title,
              highLightColor: Constants.highlightColor,
              textColor: Constants.primaryTextColor,
              highLightFontSize: Constants.fontSizeTitle * widget.fontSizeRatio,
              textFontSize: Constants.fontSizeTitle * widget.fontSizeRatio,
              fontSizeRatio: widget.fontSizeRatio,
            )
          else
            Text(
              widget.cardData.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Constants.primaryTextColor,
                fontSize: Constants.fontSizeTitle * widget.fontSizeRatio,
              ),
            ),
          const SizedBox(height: 8.0),
          if (widget.cardData.postImgList != null &&
              widget.cardData.postImgList!.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: double.infinity,
                  height: Constants.topBottomCardImageHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    itemCount: widget.cardData.postImgList!.length,
                    itemBuilder: (context, index) {
                      final item = widget.cardData.postImgList![index];
                      return Container(
                        width: MediaQuery.of(context).size.width -
                            Constants.topBottomCardContentMargin * 2,
                        margin: const EdgeInsets.only(
                          right: Constants.topBottomCardHorizontalSpacing,
                        ),
                        child: Column(
                          children: [
                            if (item.surfaceUrl != "" &&
                                item.surfaceUrl.isNotEmpty)
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Constants
                                            .topBottomCardImageBorderRadius),
                                    child: _buildNetworkImage(
                                      url: item.surfaceUrl,
                                      borderRadius: Constants
                                          .topBottomCardImageBorderRadius,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: Container(
                                        width:
                                            Constants.leftRightCardPlayIconSize,
                                        height:
                                            Constants.leftRightCardPlayIconSize,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else if (item.picVideoUrl != "" &&
                                item.picVideoUrl.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Constants.topBottomCardImageBorderRadius,
                                ),
                                child: _buildNetworkImage(
                                  url: item.picVideoUrl,
                                  borderRadius:
                                      Constants.topBottomCardImageBorderRadius,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      width: Constants.topBottomCardHorizontalSpacing,
                    ),
                  ),
                );
              },
            ),
          const SizedBox(
            height: Constants.topBottomCardVerticalSpacing,
          ),
          ArticleSourceBuilder(
            cardData: widget.cardData,
            fontSizeRatio: widget.fontSizeRatio,
          ),
          const SizedBox(
            height: Constants.topBottomCardVerticalSpacing,
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkImage({
    required String url,
    required double borderRadius,
  }) {
    return Stack(
      children: [
        const Center(
          child: SizedBox(
            width: Constants.topBottomCardLoadingIndicatorSize,
            height: Constants.topBottomCardLoadingIndicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: Constants.topBottomCardLoadingIndicatorStrokeWidth,
              valueColor: AlwaysStoppedAnimation(
                Constants.mediumGrayColor,
              ),
            ),
          ),
        ),
        Image.network(
          url,
          width: double.infinity,
          height: Constants.topBottomCardImageHeight,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox();
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: Constants.topBottomCardImageHeight,
              color: Constants.lightGrayBackgroundColor,
              child: const Icon(
                Icons.image_not_supported,
                color: Constants.mediumGrayColor,
                size: Constants.topBottomCardErrorIconSize,
              ),
            );
          },
        ),
      ],
    );
  }
}
