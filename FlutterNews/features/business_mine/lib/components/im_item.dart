import 'package:flutter/material.dart';
import 'package:lib_widget/components/custom_badge.dart';
import 'package:lib_common/lib_common.dart';
import '../common/observed_model.dart';
import 'package:lib_common/utils/time_utils.dart';
import '../utils/font_scale_utils.dart';
import '../constants/constants.dart';

class IMItem extends StatelessWidget {
  final BriefIMModel info;
  final double fontSizeRatio;

  final bool isShowSelect;
  final Function(bool isSelect) onSelect;
  final Function() onDelete;

  const IMItem({
    super.key,
    required this.info,
    this.fontSizeRatio = 1,
    this.isShowSelect = false,
    required this.onSelect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isShowSelect) _leftBuilder(),
        NumberBadge(
          count: info.allUnreadCount,
          maxCount: 99,
          showZero: false,
          child: bodyBuilder(context),
        ),
        const SizedBox(width: CommonConstants.SPACE_M),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                info.chatAuthor.authorNickName.isNotEmpty == true
                    ? info.chatAuthor.authorNickName
                    : '',
                style: TextStyle(
                  fontSize: Constants.textPrimarySize * fontSizeRatio,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontWeight: FontWeight.w500,
                  height: 21 / (Constants.textPrimarySize * fontSizeRatio),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: CommonConstants.SPACE_XS),
              Text(
                info.latestNews.isNotEmpty == true ? info.latestNews : '',
                style: TextStyle(
                  fontSize: Constants.textSecondarySize * fontSizeRatio,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),

        // 消息时间
        Padding(
          padding: const EdgeInsets.only(
              left: CommonConstants.PADDING_XS,
              right: Constants.imItemTimeRightPadding),
          child: Text(
            TimeUtils.handleMsgTimeDiff(info.receiveTime),
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodySmall?.fontSize ?? 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ),
        if (info.isDelete) _rightBuilder(),
      ],
    );
  }

  Widget _leftBuilder() {
    return GestureDetector(
      onTap: () => onSelect(info.isSelect),
      child: SizedBox(
        width: Constants.imItemLeftWidth,
        height: Constants.imItemLeftHeight,
        child: Center(
          child: Image.asset(
            info.isSelect
                ? Constants.icMessageUnselect
                : Constants.icMessageSelect,
            width: Constants.imItemSelectIconSize,
            height: Constants.imItemSelectIconSize,
          ),
        ),
      ),
    );
  }

  Widget _rightBuilder() {
    return GestureDetector(
      onTap: () => onDelete(),
      child: Container(
        color: Constants.imItemDeleteBgColor,
        width: Constants.imItemRightWidth,
        height: Constants.imItemRightHeight,
        child: Center(
          child: Image.asset(
            Constants.icMessageDelete,
            width: Constants.imItemDeleteIconSize,
            height: Constants.imItemDeleteIconSize,
          ),
        ),
      ),
    );
  }

  Widget bodyBuilder(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Constants.imItemAvatarBorderRadius),
      child: Image.network(
        info.chatAuthor.authorIcon.isNotEmpty == true
            ? info.chatAuthor.authorIcon
            : '',
        width: CommonConstants.MEDIUM_IMG_WIDTH,
        height: CommonConstants.MEDIUM_IMG_WIDTH,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: CommonConstants.MEDIUM_IMG_WIDTH,
          height: CommonConstants.MEDIUM_IMG_WIDTH,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius:
                BorderRadius.circular(Constants.imItemAvatarBorderRadius),
          ),
          child: Center(
            child: Text(
              info.chatAuthor.authorNickName.isNotEmpty == true
                  ? info.chatAuthor.authorNickName.substring(0, 1)
                  : '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16 * fontSizeRatio,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NumberBadge extends StatelessWidget {
  final int count;
  final int maxCount;
  final bool showZero;
  final Widget child;
  final Color? backgroundColor;
  final Color? textColor;

  const NumberBadge({
    super.key,
    required this.count,
    this.maxCount = 99,
    this.showZero = false,
    required this.child,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0 && !showZero) {
      return child;
    }

    String displayText = count.toString();
    if (count > maxCount) {
      displayText = '$maxCount+';
    }

    return BadgeWrapper(
      badge: CustomBadge(
        text: displayText,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: CommonConstants.SPACE_S * FontScaleUtils.fontSizeRatio,
        minWidth: 20.0 * FontScaleUtils.fontSizeRatio,
        height: 16.0 * FontScaleUtils.fontSizeRatio,
        horizontalPadding: 4.0,
      ),
      position: BadgePosition.topRight,
      offset: const Offset(4, -4),
      child: child,
    );
  }
}
