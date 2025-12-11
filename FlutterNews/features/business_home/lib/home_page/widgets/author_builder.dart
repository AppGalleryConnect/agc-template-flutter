import 'dart:io';
import 'package:business_home/components/widget_extent.dart';
import 'package:business_home/commons/constants.dart';
import 'package:business_video/views/video_sheet.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/services/author_service.dart';
import 'package:lib_news_api/services/mockdata/mock_user.dart';
import 'package:lib_account/viewmodels/login_vm.dart' as login_vm;
import 'package:module_newsfeed/components/delete_commentDialog.dart';

class AuthorCard extends StatefulWidget {
  final NewsResponse cardData;
  final bool isNeedAuthor;
  final bool getWatch;
  final bool? isShowBigImage;
  final double fontSizeRatio;
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
    this.isShowBigImage = false,
    this.fontSizeRatio = 1.0,
  });

  @override
  State<AuthorCard> createState() => _AuthorCardState();
}

class _AuthorCardState extends State<AuthorCard> {
  final loginVM = login_vm.LoginVM.getInstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      if (authorId?.isEmpty ?? true) {}
                      if (authorId?.isNotEmpty ?? false) {
                        RouterUtils.of.pushPathByName(RouterMap.PROFILE_HOME,
                            param: authorId);
                      } else if (authorId?.isNotEmpty ?? false) {
                        _defaultAvatarTap(authorId!);
                      } else {}
                    },
                    child: CircleAvatar(
                      radius: Constants.authorCardAvatarRadius,
                      backgroundImage:
                          widget.cardData.author!.authorIcon.isNotEmpty
                              ? (widget.cardData.author!.authorIcon
                                      .startsWith('http')
                                  ? NetworkImage(
                                      widget.cardData.author!.authorIcon,
                                    )
                                  : FileImage(
                                      File(
                                        widget.cardData.author!.authorIcon,
                                      ),
                                    ))
                              : const AssetImage(
                                  Constants.authorCardDefaultAvatarPath,
                                ) as ImageProvider,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Constants.authorCardHorizontalSpacing),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: widget.isShowBigImage == true
                        ? const EdgeInsets.only(
                            top: Constants.authorCardAvatarPadding)
                        : EdgeInsets.zero,
                    child: Text(
                      widget.cardData.author?.authorNickName ?? "未知作者",
                      style: TextStyle(
                        fontSize: Constants.authorCardAuthorNameFontSize *
                            widget.fontSizeRatio,
                        color: widget.isShowBigImage == true
                            ? Constants.whiteColor
                            : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: Constants.authorCardVerticalSpacing,
                  ),
                  if (widget.isShowBigImage == false)
                    Text(
                      TimeUtils.formatDate(
                        widget.cardData.createTime,
                      ),
                      style: TextStyle(
                        fontSize: Constants.authorCardDateFontSize *
                            widget.fontSizeRatio,
                        color: widget.isShowBigImage == true
                            ? Constants.whiteColor
                            : Colors.black54,
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (widget.isShowBigImage == true)
            const SizedBox(
              width: Constants.authorCardRightSpacing,
            ),
          if (widget.watchBuilder != null)
            _watchBuilder(
              widget.cardData,
              widget.isFeedSelf,
            ),
        ],
      ),
    );
  }

  void _defaultAvatarTap(String authorId) {
    try {
      final authorInfo = authorServiceApi.queryAuthorInfo(authorId);
      if (authorInfo != null) {
      } else {}
    } catch (e) {
      // 处理异常，例如显示错误提示
    }
  }

  void showInputAlert(BuildContext context) {
    DeleteCommentDialog.show(
      title: "确定不在关注他？",
      context,
      onDelete: () {
        setState(() {
          setState(() {
            if (widget.cardData.author?.authorId != null) {
              MockUser.myself.watchers.remove(
                widget.cardData.author!.authorId,
              );
            }
          });
          Navigator.pop(context);
        });
      },
      onCancel: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _watchBuilder(NewsResponse settingInfo, bool isFeedSelf) {
    var getWatch = MockUser.myself.watchers.contains(
      widget.cardData.author!.authorId,
    );
    final loginVM = login_vm.LoginVM.getInstance();
    if (!loginVM.accountInstance.userInfoModel.isLogin) {
      getWatch = false;
    }
    return Visibility(
      visible: (loginVM.accountInstance.userInfoModel.authorId
              .contains(widget.cardData.author!.authorId))
          ? false
          : true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.authorCardButtonPaddingHorizontal,
          vertical: Constants.authorCardButtonPaddingVertical,
        ),
        decoration: BoxDecoration(
          color: getWatch
              ? Constants.authorCardButtonFollowedColor
              : Constants.authorCardButtonUnfollowedColor,
          borderRadius: BorderRadius.circular(
            Constants.authorCardButtonBorderRadius,
          ),
        ),
        child: Text(
          getWatch ? '已关注' : '关注',
          style: TextStyle(
            fontSize: Constants.authorCardButtonFontSize * widget.fontSizeRatio,
            color: getWatch
                ? Constants.authorCardButtonTextFollowedColor
                : Constants.whiteColor,
          ),
        ),
      ).clickable(
        () {
          setState(
            () {
              if (!loginVM.accountInstance.userInfoModel.isLogin) {
                VideoSheet.showLoginSheet(context);
                return;
              }
              if (widget.cardData.author?.authorId != null) {
                if (MockUser.myself.watchers.contains(
                  widget.cardData.author!.authorId,
                )) {
                  showInputAlert(context);
                } else {
                  MockUser.myself.watchers.add(
                    widget.cardData.author!.authorId,
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
