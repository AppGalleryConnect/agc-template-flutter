import 'package:flutter/material.dart';
import 'dart:io';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/utils/pop_view_utils.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/models/userInfo_model.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';
import 'package:lib_common/constants/router_map.dart';
import '../common/constants.dart';
import 'dialog_like_num.dart';
import 'watch_button.dart';
import 'package:lib_news_api/services/author_service.dart';

class UserIntro extends StatelessWidget {
  final AuthorModel userInfo;
  final double fontSizeRatio;
  final VoidCallback refreshProfileHomePage;
  final UserInfoModel mineInfo;
  final VoidCallback? onEditPress;

  const UserIntro({
    super.key,
    required this.userInfo,
    this.fontSizeRatio = 1,
    required this.refreshProfileHomePage,
    required this.mineInfo,
    this.onEditPress,
  });

  void _handleWatchStatusChanged() {
    if (userInfo.isWatchByMe) {
      authorServiceApi.unfollowAuthor(mineInfo.authorId, userInfo.authorId);
    } else {
      authorServiceApi.followAuthor(mineInfo.authorId, userInfo.authorId);
    }
    refreshProfileHomePage();
  }

  bool get isMyself {
    bool isSameUser = mineInfo.authorId == userInfo.authorId;
    bool isDefaultUser =
        userInfo.authorId == '001' && mineInfo.authorId.isEmpty;
    return isSameUser || isDefaultUser;
  }

  ImageProvider getAvatarProvider(String iconPath) {
    try {
      if (iconPath.isEmpty) {
        return const AssetImage(Constants.DEFAULT_USER_ICON_PATH);
      }
      if (iconPath.startsWith('http://') || iconPath.startsWith('https://')) {
        return NetworkImage(iconPath);
      }
      String filePath = iconPath;
      if (filePath.startsWith('file://')) {
        filePath = filePath.substring(7);
      }
      final File file = File(filePath);
      if (file.existsSync()) {
        return FileImage(file);
      }
      return const AssetImage(Constants.DEFAULT_USER_ICON_PATH);
    } catch (e) {
      return const AssetImage(Constants.DEFAULT_USER_ICON_PATH);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CommonConstants.PADDING_PAGE,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 用户头像
              CircleAvatar(
                backgroundImage: getAvatarProvider(userInfo.authorIcon),
                radius: Constants.userIconWidth / 2,
              ),
              const SizedBox(width: CommonConstants.SPACE_M),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            userInfo.authorNickName,
                            style: TextStyle(
                              fontSize:
                                  Constants.authorNameFontSize * fontSizeRatio,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        const SizedBox(width: CommonConstants.SPACE_S),
                        if (isMyself)
                          GestureDetector(
                            onTap: onEditPress ??
                                () {
                                  RouterUtils.of.pushPathByName(
                                    RouterMap.SETTING_PERSONAL,
                                    onPop: (_) => refreshProfileHomePage(),
                                  );
                                },
                            child: Image.asset(
                              Constants.BRUSH_ICON_PATH,
                              width: Constants.brushIconSize,
                              height: Constants.brushIconSize,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color ??
                                  Colors.black,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.brush,
                                  size: Constants.ERROR_ICON_SIZE,
                                  color: Constants.PRIMARY_TEXT_COLOR,
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildCountItem(
                          context: context,
                          count: userInfo.watchersCount,
                          label: '关注',
                          onTap: () {
                            RouterUtils.of.pushPathByName(
                              RouterMap.PROFILE_WATCH,
                              param: userInfo.authorId,
                              onPop: (_) => refreshProfileHomePage(),
                            );
                          },
                        ),
                        const SizedBox(width: CommonConstants.SPACE_M),
                        _buildCountItem(
                          context: context,
                          count: userInfo.followersCount,
                          label: '粉丝',
                          onTap: () {
                            RouterUtils.of.pushPathByName(
                              RouterMap.PROFILE_FOLLOWER,
                              param: userInfo.authorId,
                              onPop: (_) => refreshProfileHomePage(),
                            );
                          },
                        ),
                        const SizedBox(width: CommonConstants.SPACE_M),
                        _buildCountItem(
                          context: context,
                          count: userInfo.likeNum,
                          label: '获赞',
                          onTap: () {
                            PopViewUtils.showPopView(
                              contentView: DialogLikeNum(params: userInfo),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isMyself)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    WatchButton(
                      author: userInfo,
                      onWatchStatusChanged: _handleWatchStatusChanged,
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: CommonConstants.SPACE_M),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '简介',
                style: TextStyle(
                  fontSize: Constants.INTRO_TEXT_FONT_SIZE * fontSizeRatio,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                userInfo.authorDesc.isNotEmpty
                    ? userInfo.authorDesc
                    : Constants.DEFAULT_AUTHOR_DESC,
                style: TextStyle(
                  fontSize: Constants.INTRO_TEXT_FONT_SIZE * fontSizeRatio,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountItem({
    required BuildContext context,
    required int count,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: Constants.INTRO_TEXT_FONT_SIZE * fontSizeRatio,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(width: CommonConstants.SPACE_XXS),
          Text(
            label,
            style: TextStyle(
              fontSize: Constants.INTRO_TEXT_FONT_SIZE * fontSizeRatio,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
