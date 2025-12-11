import 'package:flutter/material.dart';
import 'package:lib_account/utils/login_sheet_utils.dart';
import 'package:lib_common/dialogs/common_confirm_dialog.dart';
import 'package:lib_common/models/userInfo_model.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';
import 'package:lib_account/services/account_api.dart';
import '../common/constants.dart';

class WatchButton extends StatefulWidget {
  final AuthorModel author;
  final Function()? onWatchStatusChanged;
  final String? pageType;

  const WatchButton({
    super.key,
    required this.author,
    this.onWatchStatusChanged,
    this.pageType,
  });

  @override
  State<WatchButton> createState() => _WatchButtonState();
}

class _WatchButtonState extends State<WatchButton> {
  late final UserInfoModel userInfoModel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    userInfoModel = AccountApi.getInstance().userInfoModel;

    userInfoModel.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    userInfoModel.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Constants.WATCH_BUTTON_PRIMARY_COLOR;
    Color textColor = Constants.WATCH_BUTTON_TEXT_PRIMARY_COLOR;

    if (isMutualFollow) {
      backgroundColor = Constants.WATCH_BUTTON_SECONDARY_COLOR;
      textColor = Constants.WATCH_BUTTON_TEXT_SECONDARY_COLOR;
    } else if (isWatchByMe && !isMutualFollow) {
      backgroundColor = Constants.WATCH_BUTTON_SECONDARY_COLOR;
      textColor = Constants.WATCH_BUTTON_TEXT_SECONDARY_COLOR;
    } else if (isWatchByHim && !isWatchByMe) {
      backgroundColor = Constants.WATCH_BUTTON_PRIMARY_COLOR;
      textColor = Constants.WATCH_BUTTON_TEXT_PRIMARY_COLOR;
    }

    return ElevatedButton(
      onPressed: _isLoading ? null : () => _btnClick(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.WATCH_BUTTON_PADDING_HORIZONTAL,
          vertical: Constants.WATCH_BUTTON_PADDING_VERTICAL,
        ),
        minimumSize: const Size(
          Constants.WATCH_BUTTON_MIN_WIDTH,
          Constants.WATCH_BUTTON_MIN_HEIGHT,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Constants.WATCH_BUTTON_BORDER_RADIUS,
          ),
        ),
        textStyle: const TextStyle(
          fontSize: Constants.WATCH_BUTTON_FONT_SIZE,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      child: _isLoading
          ? const SizedBox(
              width: Constants.LOADING_INDICATOR_SIZE,
              height: Constants.LOADING_INDICATOR_SIZE,
              child: CircularProgressIndicator(
                strokeWidth: Constants.LOADING_INDICATOR_STROKE_WIDTH,
                color: Constants.WATCH_BUTTON_TEXT_PRIMARY_COLOR,
              ),
            )
          : Text(btnLabel),
    );
  }

  void _btnClick(BuildContext context) {
    if (!userInfoModel.isLogin) {
      LoginSheetUtils.open(context);
      return;
    }
    if (widget.author.authorId == userInfoModel.authorId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('不能关注自己'),
        ),
      );
      return;
    }
    if (isMutualFollow || isWatchByMe) {
      CommonConfirmDialog.show(
        context,
        IConfirmDialogParams(
          primaryTitle: '取消关注',
          content: '确定要取消关注该用户吗？',
          confirm: () {
            _handleWatchStatusChanged();
          },
        ),
      );
    } else {
      _handleWatchStatusChanged();
    }
  }

  void _handleWatchStatusChanged() {
    if (widget.onWatchStatusChanged != null) {
      setState(
        () {
          _isLoading = true;
        },
      );
      widget.onWatchStatusChanged!();
      Future.delayed(
        const Duration(
          milliseconds: Constants.LOADING_DELAY_MILLISECONDS,
        ),
        () {
          if (mounted) {
            setState(
              () {
                _isLoading = false;
              },
            );
          }
        },
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '操作失败，请稍后重试',
            ),
          ),
        );
      }
    }
  }

  bool get isWatchByMe {
    return widget.author.isWatchByMe;
  }

  bool get isWatchByHim {
    return widget.author.isWatchByHim;
  }

  bool get isMutualFollow {
    return widget.author.isMutualFollow;
  }

  String get btnLabel {
    if (!userInfoModel.isLogin) {
      return '关注';
    }
    if (widget.pageType == 'follower') {
      if (widget.author.isMutualFollow) {
        return '互相关注';
      } else if (widget.author.isWatchByMe) {
        return '已关注';
      } else if (widget.author.isWatchByHim) {
        return '回关';
      } else {
        return '关注';
      }
    }
    if (widget.pageType == 'watch') {
      if (widget.author.isMutualFollow) {
        return '互相关注';
      } else if (widget.author.isWatchByMe) {
        return '已关注';
      } else {
        return '关注';
      }
    }
    final statusText = widget.author.followStatusText;
    return statusText;
  }
}
