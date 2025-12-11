import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/models/userInfo_model.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';
import 'package:lib_news_api/services/mine_service.dart';
import 'package:lib_news_api/services/author_service.dart';
import 'package:lib_account/services/account_api.dart';
import '../utils/font_scale_utils.dart';
import '../constants/constants.dart';

class FanItem extends StatefulWidget {
  final AuthorModel author;

  const FanItem({
    super.key,
    required this.author,
  });

  @override
  State<FanItem> createState() => _FanItemState();
}

class _FanItemState extends State<FanItem> {
  late UserInfoModel _userInfoModel;

  @override
  void initState() {
    super.initState();
    _userInfoModel = AccountApi.getInstance().userInfoModel;
    _userInfoModel.addListener(_onLoginStateChanged);
  }

  // 登录状态变化处理方法
  void _onLoginStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _userInfoModel.removeListener(_onLoginStateChanged);
    super.dispose();
  }

  bool get isWatchByMe {
    return _userInfoModel.watchers.contains(widget.author.authorId);
  }

  bool get isWatchByHim {
    return widget.author.watchers != null &&
        widget.author.watchers!.contains(_userInfoModel.authorId);
  }

  // 按钮文本
  String get btnLabel {
    if (isWatchByMe && isWatchByHim) {
      return '互相关注';
    }
    if (!isWatchByMe && isWatchByHim) {
      return '回关';
    }
    return '关注';
  }

  // 按钮文字颜色
  Color get isCustomFg {
    if (isWatchByMe) {
      return Theme.of(context).primaryColor;
    }
    return Colors.white;
  }

  // 按钮背景颜色
  Color get isCustomBg {
    if (isWatchByMe) {
      return Colors.grey.shade100;
    }
    return Theme.of(context).primaryColor;
  }

  // 按钮点击处理
  void btnClick() {
    // 检查是否登录
    if (!_userInfoModel.isLogin) {
      RouterUtils.of.pushPathByName(RouterMap.HUAWEI_LOGIN_PAGE);
      return;
    }

    if (isWatchByMe) {
      if (isWatchByHim) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.dialogBorderRadius),
            ),
            elevation: 0,
            backgroundColor: Constants.secondaryButtonColor,
            child: Container(
              padding: const EdgeInsets.all(Constants.dialogPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      '确定不再关注TA？',
                      style: TextStyle(
                        fontSize: Constants.dialogTextSize,
                        fontWeight: Constants.dialogTitleFontWeight,
                      ),
                    ),
                  ),
                  const SizedBox(height: Constants.dialogSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            '取消',
                            style: TextStyle(
                              fontSize: Constants.dialogButtonTextSize,
                              color: Constants.primaryButtonColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: Constants.dialogDividerHeight,
                        color: Constants.dividerColor,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // 取消关注
                            authorServiceApi.unfollowAuthor(
                                _userInfoModel.authorId,
                                widget.author.authorId);

                            // 刷新用户信息
                            refreshUserInfo();
                          },
                          child: const Text(
                            '确定',
                            style: TextStyle(
                              fontSize: Constants.dialogButtonTextSize,
                              color: Constants.primaryButtonColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        // 普通取消关注
        authorServiceApi.unfollowAuthor(
            _userInfoModel.authorId, widget.author.authorId);
        refreshUserInfo();
      }
    } else {
      authorServiceApi.followAuthor(
          _userInfoModel.authorId, widget.author.authorId);
      refreshUserInfo();
    }
  }

  // 刷新用户信息
  void refreshUserInfo() async {
    try {
      if (!_userInfoModel.isLogin) {
        return;
      }
      final authorInfo = MineServiceApi.queryAuthorInfo();
      if (authorInfo!.watchers != null) {
        _userInfoModel.watchers.clear();
        _userInfoModel.watchers.addAll(authorInfo.watchers!);
      } else {
        _userInfoModel.watchers.clear();
      }
      _userInfoModel.watchersCount = authorInfo.watchersCount;
      _userInfoModel.followersCount = authorInfo.followersCount;
      if (mounted) {
        setState(() {});
      } else {}
    } catch (e) {
      // 刷新用户信息失败，静默处理
    }
  }

  // 标记粉丝为已读
  void markFanAsRead() {
    try {} catch (e) {
      // 标记粉丝为已读失败，静默处理
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 先标记为已读
        markFanAsRead();
        // 然后跳转到个人主页
        RouterUtils.of.pushPathByName(
          RouterMap.PROFILE_HOME,
          param: widget.author.authorId,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(CommonConstants.PADDING_L),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: Constants.avatarRadius,
              backgroundImage: widget.author.authorIcon.isNotEmpty
                  ? NetworkImage(widget.author.authorIcon)
                  : null,
              child: widget.author.authorIcon.isEmpty
                  ? Text(
                      widget.author.authorNickName.isNotEmpty
                          ? widget.author.authorNickName[0]
                          : '用户',
                      style: TextStyle(
                          fontSize: Constants.avatarTextSize *
                              FontScaleUtils.fontSizeRatio),
                    )
                  : null,
            ),
            const SizedBox(width: CommonConstants.SPACE_S),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.author.authorNickName,
                    style: TextStyle(
                      fontSize: Constants.textPrimarySize *
                          FontScaleUtils.fontSizeRatio,
                      color: Constants.textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: CommonConstants.SPACE_XXS),
                  Row(
                    children: [
                      Text(
                        '11:06',
                        style: TextStyle(
                          fontSize: Constants.textSecondarySize *
                              FontScaleUtils.fontSizeRatio,
                          color: Constants.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(width: CommonConstants.SPACE_XXS),
                      Text(
                        '关注了你',
                        style: TextStyle(
                          fontSize: Constants.textSecondarySize *
                              FontScaleUtils.fontSizeRatio,
                          color: Constants.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: CommonConstants.SPACE_S),
            Container(
              width: Constants.followButtonWidth,
              height: Constants.followButtonHeight,
              decoration: BoxDecoration(
                color: isWatchByMe
                    ? Constants.secondaryButtonColor
                    : Constants.primaryButtonColor,
                borderRadius:
                    BorderRadius.circular(Constants.followButtonRadius),
              ),
              child: TextButton(
                onPressed: btnClick,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.followButtonRadius),
                  ),
                ),
                child: Text(
                  btnLabel,
                  style: TextStyle(
                    fontSize:
                        Constants.buttonTextSize * FontScaleUtils.fontSizeRatio,
                    color: isWatchByMe
                        ? Constants.primaryButtonColor
                        : Constants.buttonTextColor,
                    fontWeight: Constants.buttonTextFontWeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
