import 'package:flutter/material.dart';
import 'package:lib_common/models/userInfo_model.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/services/mockdata/mock_user.dart';
import 'package:module_flutter_highlight/views/high_light.dart';
import '../commons/constants.dart';
import '../home_page/widgets/author_builder.dart';
import '../home_page/widgets/base_image.dart';

class TopTextBottomVideoCard extends StatelessWidget {
  final NewsResponse cardData;
  final Function(String id)? onAvthorTap;
  final VoidCallback? onWatchClick;
  final double fontSizeRatio;

  const TopTextBottomVideoCard(this.cardData,
      {super.key,
      this.onWatchClick,
      required this.onAvthorTap,
      this.fontSizeRatio = 1.0});

  @override
  Widget build(BuildContext context) {
    return TopTextBottomVideo(
      cardData: cardData,
      onWatchClick: onWatchClick,
      onAvthorTap: onAvthorTap,
      fontSizeRatio: fontSizeRatio,
    );
  }
}

class TopTextBottomVideo extends StatefulWidget {
  final NewsResponse cardData;
  final VoidCallback? onWatchClick;
  final Function(String id)? onAvthorTap;
  final double fontSizeRatio;

  const TopTextBottomVideo(
      {super.key,
      required this.cardData,
      this.onWatchClick,
      required this.onAvthorTap,
      this.fontSizeRatio = 1.0});

  @override
  State<TopTextBottomVideo> createState() => _TopTextBottomVideoState();
}

class _TopTextBottomVideoState extends State<TopTextBottomVideo> {
  double coverImgHeight = Constants.topBottomVideoCardCoverHeight;
  late UserInfoModel userInfoModel = UserInfoModel();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool getWatch =
        MockUser.myself.watchers.contains(widget.cardData.author?.authorId);
    final bool isFeedSelf =
        MockUser.myself.authorId == widget.cardData.author?.authorId;
    return Column(
      children: [
        AuthorCard(
          cardData: widget.cardData,
          isFeedSelf: isFeedSelf,
          getWatch: getWatch,
          isNeedAuthor: widget.cardData.extraInfo?["isNeedAuthor"] ?? true,
          avatarBuilder: (id) => widget.onAvthorTap?.call(id),
          watchBuilder: () => widget.onWatchClick?.call(),
          fontSizeRatio: widget.fontSizeRatio,
        ),
        const SizedBox(height: Constants.topBottomVideoCardVerticalSpacing),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.cardData.extraInfo?["searchKey"] != null)
                  Highlight(
                    keywords: [
                      widget.cardData.extraInfo!["searchKey"].toString()
                    ],
                    sourceString: widget.cardData.title,
                    highLightColor: Constants.highlightColor,
                    textColor: Constants.primaryTextColor,
                    highLightFontSize:
                        Constants.topBottomVideoCardHighlightFontSize *
                            widget.fontSizeRatio,
                    textFontSize: Constants.topBottomVideoCardTitleFontSize *
                        widget.fontSizeRatio,
                    textFontWeight: FontWeight.w500,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    fontSizeRatio: widget.fontSizeRatio,
                  )
                else
                  Text(
                    widget.cardData.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Constants.topBottomVideoCardTitleFontSize *
                          widget.fontSizeRatio,
                      fontWeight: FontWeight.w500,
                      color: Constants.primaryTextColor,
                    ),
                  ),
                const SizedBox(
                    height: Constants.topBottomVideoCardVerticalSpacing),
              ],
            ),
            ClipRRect(
              child: Container(
                child: _buildVideoContent(widget.cardData),
              ),
            ),
            const SizedBox(height: Constants.topBottomVideoCardVerticalSpacing),
          ],
        ),
      ],
    );
  }
}

Widget _buildVideoContent(NewsResponse settingInfo) {
  if (settingInfo.postImgList?.isNotEmpty == true) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BaseImage(
          url: settingInfo.postImgList!.first.surfaceUrl,
          downloadWithoutWlan: 0,
        ),
        Image.asset(
          Constants.topBottomVideoCardPauseIconPath,
          width: Constants.topBottomVideoCardPauseIconSize,
          height: Constants.topBottomVideoCardPauseIconSize,
        ),
      ],
    );
  }
  return const SizedBox();
}
