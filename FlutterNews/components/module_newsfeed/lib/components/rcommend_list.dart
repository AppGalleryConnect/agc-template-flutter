import 'package:business_home/items_card/custom_item_card.dart';
import 'package:business_video/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_news_api/constants/constants.dart';
import 'package:lib_news_api/params/response/layout_response.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import '../components/news_detail_page.dart';
import 'package:module_newsfeed/constants/constants.dart';

class RecommendList extends StatelessWidget {
  final List<RequestListData> requestListDataList;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double imageWidth;
  final double imageHeight;
  final EdgeInsetsGeometry? padding;
  final double fontSizeRatio;

  const RecommendList({
    super.key,
    required this.requestListDataList,
    this.titleStyle,
    this.subtitleStyle,
    this.imageWidth = 100,
    this.imageHeight = 60,
    this.padding = const EdgeInsets.symmetric(horizontal: Constants.SPACE_16, vertical: Constants.SPACE_8),
    this.fontSizeRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final List<RequestListData> allRequestData = [];
    for (final data in requestListDataList) {
      if (data.navInfo.parsedSetting!.showType! ==
          NewsCardType.leftTextRightImageCard) {
        if (data.articles.isNotEmpty) {
          allRequestData.add(data);
        }
      }
    }

    return Container(
      padding: padding,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '相关推荐',
            style: TextStyle(
                fontSize: Constants.FONT_16 * fontSizeRatio,
                fontWeight: FontWeight.bold),
          ),

          if (allRequestData.isEmpty)
            _buildEmptyState()
          else
            SizedBox(
              height: allRequestData.length * (imageHeight), 
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allRequestData.length,
                itemBuilder: (context, index) {
                  final RequestListData data = allRequestData[index];
                  return CustomItemCard(
                    context,
                    data,
                    onTap: (NewsResponse res) {
                      _pushToNewsDetail(context, res, index);
                    },
                    onWatchClick: (newsId) {},
                    fontSizeRatio: fontSizeRatio,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  _pushToNewsDetail(BuildContext context, NewsResponse res, int index) {
    VideoNewsData videoData = VideoNewsData.fromCommentResponse(res);
    if (res.videoUrl != null) {
      RouterUtils.of
          .pushPathByName(RouterMap.VIDEO_PLAY_PAGE, param: videoData);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewsDetailPage(
                  news: res,
                  fontSizeRatio: fontSizeRatio,
                )),
      );
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Constants.SPACE_20),
      alignment: Alignment.center,
      child: Text(
        '暂无相关推荐',
        style: TextStyle(
            fontSize: Constants.FONT_14 * fontSizeRatio, color: Colors.grey),
      ),
    );
  }
}
