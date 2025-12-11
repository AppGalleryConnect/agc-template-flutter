import 'package:flutter/material.dart';
import '../model/recommend_model.dart';
import '../utils/utils.dart';
import 'package:module_newsfeed/constants/constants.dart';

class FeedOperate extends StatelessWidget {
  final FeedCardInfo curFeedCardInfo;
  final bool isNeedOperation;
  final bool isDark;
  final double fontSizeRatio;
  final WidgetBuilder? shareBuilder;
  final VoidCallback onArticle;
  final VoidCallback onLike;

  const FeedOperate({
    super.key,
    required this.curFeedCardInfo,
    this.isNeedOperation = false,
    this.isDark = false,
    this.fontSizeRatio = 1.0,
    this.shareBuilder,
    required this.onArticle,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Theme.of(context).textTheme.bodyMedium?.color;
    final secondaryTextColor = Theme.of(context).hintColor;

    Widget likeIcon() {
      final defaultLikeIcon = isDark
          ? const AssetImage(Constants.likeDarkImage)
          : const AssetImage(Constants.likeImage);
      const activeLikeIcon = AssetImage(Constants.likeActiveImage);

      return Image(
        image: curFeedCardInfo.isLiked ? activeLikeIcon : defaultLikeIcon,
        width: Constants.SPACE_17 * fontSizeRatio,
        height: Constants.SPACE_15 * fontSizeRatio,
        color: primaryTextColor,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.favorite_border, size: Constants.SPACE_17, color: primaryTextColor),
      );
    }

    Widget defaultShareWidget() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Constants.opForwardImage,
            width: Constants.SPACE_16 * fontSizeRatio,
            height: Constants.SPACE_16 * fontSizeRatio,
            color: primaryTextColor,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.share, size: Constants.SPACE_16, color: primaryTextColor),
          ),
          const SizedBox(width: Constants.SPACE_5),
          Text(
            formatToK(curFeedCardInfo.shareCount),
            style: TextStyle(
              fontSize: Constants.FONT_12 * fontSizeRatio,
              color: secondaryTextColor,
            ),
          ),
        ],
      );
    }

    Widget commentWidget() {
      return GestureDetector(
        onTap: onArticle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Constants.opCommentImage,
              width: Constants.SPACE_17 * fontSizeRatio,
              height: Constants.SPACE_16 * fontSizeRatio,
              color: primaryTextColor,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.comment, size: Constants.SPACE_17, color: primaryTextColor),
            ),
            const SizedBox(width: Constants.SPACE_5),
            Text(
              formatToK(curFeedCardInfo.commentCount),
              style: TextStyle(
                fontSize: Constants.FONT_12 * fontSizeRatio,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      );
    }

    Widget likeWidget() {
      return GestureDetector(
        onTap: onLike,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            likeIcon(),
            const SizedBox(width: Constants.SPACE_5),
            Text(
              formatToK(curFeedCardInfo.likeCount),
              style: TextStyle(
                fontSize: Constants.FONT_12 * fontSizeRatio,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: Constants.SPACE_16 * fontSizeRatio),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isNeedOperation
              ? (shareBuilder?.call(context) ?? defaultShareWidget())
              : defaultShareWidget(),
          commentWidget(),
          likeWidget(),
        ],
      ),
    );
  }
}
