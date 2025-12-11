import 'package:flutter/material.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import '../commons/constants.dart';
import '../home_page/widgets/article_source_builder.dart';
import '../home_page/widgets/author_builder.dart';
import '../home_page/widgets/base_image.dart';

class TopTextBottomImageCard extends StatelessWidget {
  final NewsResponse cardData;
  final Function(int index)? onImageClick;
  final Function(String id)? onAvthorTap;
  final VoidCallback? onWatchClick;
  final double fontSizeRatio;

  const TopTextBottomImageCard(this.cardData,
      {super.key,
      this.onImageClick,
      this.onWatchClick,
      required this.onAvthorTap,
      this.fontSizeRatio = 1.0});

  @override
  Widget build(BuildContext context) {
    final autoerInfo = cardData.extraInfo?["isNeedAuthor"];
    final isNeedAuthor = autoerInfo != null && autoerInfo == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 作者信息卡片
        AuthorCard(
          cardData: cardData,
          isNeedAuthor: isNeedAuthor,
          avatarBuilder: (id) => onAvthorTap?.call(id),
          watchBuilder: () => onWatchClick?.call(),
          fontSizeRatio: fontSizeRatio,
        ),

        if (cardData.extraInfo?["searchKey"] != null)
          HighlightText(
            keywords: [cardData.extraInfo!["searchKey"].toString()],
            sourceString: cardData.title,
            highlightColor: Constants.highlightColor,
            textColor: Constants.primaryTextColor,
            fontSize:
                Constants.topBottomImageCardHighlightFontSize * fontSizeRatio,
          )
        else
          Text(
            cardData.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Constants.primaryTextColor,
              fontSize:
                  Constants.topBottomImageCardTitleFontSize * fontSizeRatio,
            ),
          ),
        LayoutBuilder(
          builder: (context, constraints) {
            final imageCount = cardData.postImgList?.length ?? 0;
            if (imageCount == 0) return const SizedBox.shrink();

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                top: Constants.topBottomImageCardGridTopPadding,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: imageCount,
                crossAxisSpacing: Constants.topBottomImageCardGridSpacing,
              ),
              itemCount: imageCount,
              itemBuilder: (context, index) {
                final item = cardData.postImgList?[index];
                return GestureDetector(
                  onTap: () => onImageClick?.call(index),
                  child: BaseImage(
                    url: item?.picVideoUrl ?? '',
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(
          height: Constants.topBottomImageCardVerticalSpacing,
        ),
        ArticleSourceBuilder(
          cardData: cardData,
          fontSizeRatio: fontSizeRatio,
        ),
      ],
    );
  }
}

class HighlightText extends StatelessWidget {
  final List<String> keywords;
  final String sourceString;
  final Color highlightColor;
  final Color textColor;
  final double fontSize;
  final int? maxLines;
  final TextOverflow overflow;

  const HighlightText({
    super.key,
    required this.keywords,
    required this.sourceString,
    required this.highlightColor,
    required this.textColor,
    required this.fontSize,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    if (keywords.isEmpty || keywords.first.isEmpty) {
      return Text(
        sourceString,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final List<TextSpan> children = [];
    final keyword = keywords.first;

    final escapedKeyword = keyword.replaceAllMapped(
      RegExp(r'[.*+?^${}()|[\]\\]'),
      (match) => '\\${match.group(0)}',
    );

    final regex = RegExp(escapedKeyword);
    int lastIndex = 0;
    final matches = regex.allMatches(sourceString);
    for (final match in matches) {
      if (match.start > lastIndex) {
        children.add(TextSpan(
          text: sourceString.substring(lastIndex, match.start),
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ));
      }
      children.add(TextSpan(
        text: sourceString.substring(match.start, match.end),
        style: TextStyle(
          color: highlightColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ));

      lastIndex = match.end;
    }
    if (lastIndex < sourceString.length) {
      children.add(TextSpan(
        text: sourceString.substring(lastIndex),
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ));
    }
    if (children.isEmpty) {
      children.add(TextSpan(
        text: sourceString,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ));
    }
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
        ),
        children: children,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
