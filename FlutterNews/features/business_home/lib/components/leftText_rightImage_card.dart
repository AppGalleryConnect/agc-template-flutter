import 'package:business_home/components/topText_bottomImage_card.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:lib_news_api/params/base/base_model.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import '../home_page/widgets/author_builder.dart';
import '../home_page/widgets/base_image.dart';
import '../commons/constants.dart';

class LeftTextRightImageCard extends StatelessWidget {
  final NewsResponse news;
  final Function(String id)? onAuthorTap;
  final String? searchKeyword;
  final double fontSizeRatio;

  const LeftTextRightImageCard(this.news,
      {super.key,
      required this.onAuthorTap,
      this.searchKeyword,
      this.fontSizeRatio = 1.0});

  @override
  Widget build(BuildContext context) {
    return NativeComponent(
      cardData: news,
      onAuthorTap: onAuthorTap,
      fontSizeRatio: fontSizeRatio,
    );
  }
}

class NativeComponent extends StatefulWidget {
  final NewsResponse cardData;
  final VoidCallback? onWatchClick;
  final Function(String id)? onAuthorTap;
  final bool showAuthor;
  final double fontSizeRatio;

  const NativeComponent({
    super.key,
    required this.cardData,
    this.onAuthorTap,
    this.onWatchClick,
    this.showAuthor = true,
    this.fontSizeRatio = 1.0,
  });

  @override
  State<NativeComponent> createState() => _NativeComponentState();
}

class _NativeComponentState extends State<NativeComponent> {
  late NewsResponse itemData;

  @override
  void initState() {
    itemData = widget.cardData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final autoerInfo = widget.cardData.extraInfo?["isNeedAuthor"];
    final isNeedAuthor = autoerInfo != null && autoerInfo == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthorCard(
          cardData: itemData,
          isNeedAuthor: isNeedAuthor,
          avatarBuilder: (id) => widget.onAuthorTap?.call(id),
          watchBuilder: () => widget.onWatchClick?.call(),
          fontSizeRatio: widget.fontSizeRatio,
        ),
        const SizedBox(height: Constants.leftRightCardVerticalSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧文本部分
            Expanded(
              flex: 65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.cardData.extraInfo?['searchKey'] == null)
                    Text(
                      itemData.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: Constants.fontSizeTitle *
                            widget.fontSizeRatio, // * settingInfo.fontSizeRatio
                        fontWeight: FontWeight.w500,
                        color: Constants
                            .primaryTextColor, // $r('sys.color.font_primary')
                      ),
                    )
                  else
                    HighlightText(
                      keywords: [widget.cardData.extraInfo?['searchKey'] ?? ''],
                      sourceString: itemData.title,
                      highlightColor: Constants.highlightColor,
                      textColor: Constants.primaryTextColor,
                      fontSize: Constants.fontSizeTitle * widget.fontSizeRatio,
                    ),
                  const SizedBox(height: Constants.leftRightCardTitleSpacing),
                  if (!(widget.cardData.extraInfo?['isNeedAuthor'] as bool? ??
                      false))
                    Text(
                      '${itemData.author?.authorNickName ?? ''} ${TimeUtils.formatDate(itemData.createTime)}',
                      style: TextStyle(
                        fontSize: Constants.fontSizeTiny *
                            widget.fontSizeRatio, // * settingInfo.fontSizeRatio
                        color: Constants
                            .secondaryTextColor, // $r('sys.color.font_tertiary')
                      ),
                      maxLines: 1, // 强制单行显示
                      overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                      softWrap: false, // 禁止自动换行（可选，默认true）
                    ),
                ],
              ),
            ),

            const SizedBox(
              width: Constants.leftRightCardHorizontalSpacing,
            ),

            // 右侧图片部分
            if (itemData.postImgList != null)
              SizedBox(
                width: Constants.leftRightCardImageWidth,
                child: Column(
                    children: itemData.postImgList!
                        .map((item) => _buildImageItem(item))
                        .toList()),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageItem(PostImgList item) {
    return Container(
      width: Constants.leftRightCardImageWidth,
      height: Constants.leftRightCardImageHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(Constants.leftRightCardImageBorderRadius),
      ),
      child: item.surfaceUrl != ""
          ? Stack(
              children: [
                BaseImage(url: item.surfaceUrl),
                Center(
                  child: Icon(
                    Icons.play_arrow,
                    size: Constants.leftRightCardPlayIconSize,
                    color: Constants.whiteColor.withOpacity(0.8),
                  ),
                ),
              ],
            )
          : BaseImage(url: item.picVideoUrl),
    );
  }
}
