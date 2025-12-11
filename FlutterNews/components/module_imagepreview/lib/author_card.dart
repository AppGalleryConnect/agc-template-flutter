import 'package:flutter/material.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/models/userInfo_model.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/utils/theme_colors.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/services/home_service.dart';
import 'package:lib_account/services/account_api.dart';
import 'package:business_video/views/video_sheet.dart';
import 'package:module_imagepreview/constants/constants.dart';

class AuthorCard extends StatefulWidget {
  final NewsResponse cardData;
  final bool isNeedAuthor;
  final bool getWatch;
  final bool? isShowBigImage;

  final bool isFeedSelf;
  final VoidCallback? watchBuilder;
  final Function(String id)? avatarBuilder;
  const AuthorCard({
    super.key,
    required this.cardData,
    this.isFeedSelf = false,
    this.isNeedAuthor = false,
    this.getWatch = false,
    this.watchBuilder,
    this.avatarBuilder,
    this.isShowBigImage,
  });

  @override
  State<AuthorCard> createState() => _AuthorCardState();
}

class _AuthorCardState extends State<AuthorCard> {
  late final UserInfoModel userInfoModel;

  @override
  void initState() {
    super.initState();
    userInfoModel = AccountApi.getInstance().userInfoModel;
    userInfoModel.addListener(_onUserInfoChanged);
  }

  void _onUserInfoChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    userInfoModel.removeListener(_onUserInfoChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeRatio = HomeService().fontSizeRatio;

    return Visibility(
      visible: widget.isNeedAuthor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      String? authorId = widget.cardData.author?.authorId;

                      if ((authorId?.isNotEmpty ?? false) &&
                          widget.avatarBuilder != null) {
                        widget.avatarBuilder!(authorId!);
                      } else if (authorId?.isNotEmpty ?? false) {
                        _defaultAvatarTap(authorId!);
                      }
                    },
                    child: CircleAvatar(
                      radius: Constants.SPACE_20,
                      backgroundImage:
                          widget.cardData.author?.authorIcon != null
                              ? NetworkImage(widget.cardData.author!.authorIcon)
                              : const AssetImage(Constants.iconDefaultImage)
                                  as ImageProvider,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Constants.SPACE_8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: widget.isShowBigImage == true
                        ? const EdgeInsets.only(top: Constants.SPACE_13)
                        : EdgeInsets.zero,
                    child: Text(
                      widget.cardData.author?.authorNickName ?? "未知作者",
                      style: TextStyle(
                        fontSize: Constants.FONT_15 * fontSizeRatio,
                        color: widget.isShowBigImage == true
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: Constants.SPACE_5),
                  if (widget.isShowBigImage == false)
                    Text(
                      TimeUtils.formatDate(widget.cardData.createTime),
                      style: TextStyle(
                        fontSize: Constants.SPACE_12 * fontSizeRatio,
                        color: widget.isShowBigImage == true
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (widget.isShowBigImage == true)
            const SizedBox(width: Constants.SPACE_20),
          if (widget.watchBuilder != null)
            _watchBuilder(widget.cardData, widget.isFeedSelf),
        ],
      ),
    );
  }

  void _defaultAvatarTap(String authorId) {
    RouterUtils.of.pushPathByName(
      RouterMap.PROFILE_HOME,
      param: authorId,
    );
  }

  void showInputAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("确定不在关注他？"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                if (widget.watchBuilder != null) {
                  widget.watchBuilder?.call();
                } else {
                  if (widget.cardData.author?.authorId != null) {
                    userInfoModel
                        .removeWatcher(widget.cardData.author!.authorId);
                  }
                }
                Navigator.pop(context);
              },
              child: const Text("确认"),
            ),
          ],
        );
      },
    );
  }

  Widget _watchBuilder(NewsResponse settingInfo, bool isFeedSelf) {
    if (isFeedSelf) {
      return Container();
    }

    final authorId = widget.cardData.author?.authorId ?? '';
    final isLogin = userInfoModel.isLogin;
    final watchers = userInfoModel.watchers;
    final getWatch = isLogin && watchers.contains(authorId);

    final backgroundColor = getWatch
        ? ThemeColors.getBackgroundTertiary(false)
        : ThemeColors.appTheme;
    final textColor = getWatch ? ThemeColors.appTheme : Colors.white;

    return GestureDetector(
      onTap: () {
        if (!userInfoModel.isLogin) {
          VideoSheet.showLoginSheet(context);
          return;
        }

        if (widget.watchBuilder != null) {
          widget.watchBuilder?.call();
        } else {
          if (widget.cardData.author?.authorId != null) {
            if (userInfoModel.watchers.contains(authorId)) {
              showInputAlert(context);
            } else {
              userInfoModel.addWatcher(authorId);
            }
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.SPACE_12, vertical: Constants.SPACE_6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Constants.SPACE_14),
        ),
        child: Text(
          getWatch ? '已关注' : '关注',
          style: TextStyle(
            fontSize: Constants.FONT_14,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
