import 'package:flutter/material.dart';
import 'package:lib_news_api/params/response/layout_response.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import '../commons/constants.dart';
import '../components/vertical_bigImage_card.dart';

/// 热门新闻
class VerticalBigImageItemCard extends StatelessWidget {
  final RequestListData news;
  final Function(NewsResponse newsInfo) onTap;
  final double fontSizeRatio;
  const VerticalBigImageItemCard(
    this.news, {
    super.key,
    required this.onTap,
    this.fontSizeRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.verticalBigImageItemCardHeight,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.verticalBigImageItemCardHorizontalPadding,
        vertical: Constants.verticalBigImageItemCardVerticalPadding,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: news.articles.length,
        itemBuilder: (context, index) {
          final item = news.articles[index];
          return GestureDetector(
            onTap: () {
              onTap.call(item);
            },
            child: VerticalBigImageCard(
              item,
              onTap: (e) {
                onTap.call(item);
              },
              fontSizeRatio: fontSizeRatio,
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: Constants.verticalBigImageItemCardSeparatorWidth,
        ),
      ),
    );
  }
}
