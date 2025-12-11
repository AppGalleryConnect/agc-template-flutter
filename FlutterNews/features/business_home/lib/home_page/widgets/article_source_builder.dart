import 'package:flutter/material.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import '../../commons/constants.dart';

class ArticleSourceBuilder extends StatefulWidget {
  final NewsResponse cardData;
  final double fontSizeRatio;

  const ArticleSourceBuilder(
      {super.key, required this.cardData, this.fontSizeRatio = 1.0});

  @override
  State<ArticleSourceBuilder> createState() => _ArticleSourceBuilderState();
}

class _ArticleSourceBuilderState extends State<ArticleSourceBuilder> {
  @override
  Widget build(BuildContext context) {
    final nativeCardData = widget.cardData;
    final autoerInfo = widget.cardData.extraInfo?["isNeedAuthor"];
    final isNeedAuthor = autoerInfo != null && autoerInfo == true;
    if (isNeedAuthor) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (nativeCardData.articleFrom != null)
          Text(
            nativeCardData.articleFrom!,
            style: TextStyle(
              fontSize:
                  Constants.articleSourceBuilderFontSize * widget.fontSizeRatio,
              color: Constants.secondaryTextColor,
            ),
            textAlign: TextAlign.start,
          ),
        Container(
          margin: const EdgeInsets.only(
            left: Constants.articleSourceBuilderSpacing,
          ),
          child: Text(
            TimeUtils.formatDate(
              nativeCardData.createTime,
            ),
            style: TextStyle(
              fontSize:
                  Constants.articleSourceBuilderFontSize * widget.fontSizeRatio,
              color: Constants.secondaryTextColor,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
