import 'package:flutter/material.dart';
import 'package:lib_widget/components/custom_badge.dart';
import 'package:lib_common/lib_common.dart';
import '../constants/constants.dart';
import '../types/types.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';

class MsgMenuItem extends StatelessWidget {
  final MineMsgMenuItem info;
  final double fontSizeRatio;

  const MsgMenuItem({
    super.key,
    required this.info,
    this.fontSizeRatio = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RouterUtils.of.pushPathByName(info.routerName,
            param: null, onPop: (PopInfo? _) => info.routerOnPop?.call());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Constants.messageItemVerticalPadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 带未读消息角标的图标
            BadgeWrapper(
              badge: NumberBadge(
                count: info.allUnreadCount,
                maxCount: 99,
                showZero: false,
              ),
              child: bodyBuilder(context),
            ),
            const SizedBox(
              width: Constants.messageItemHorizontalSpacing,
            ),
            // 标题和最新消息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    info.menuTitle,
                    style: TextStyle(
                      fontSize: Constants.textPrimarySize * fontSizeRatio,
                      color: Constants.textPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: Constants.messageItemTextSpacing,
                  ),
                  Text(
                    info.latestNews,
                    style: TextStyle(
                      fontSize: Constants.textTertiarySize * fontSizeRatio,
                      color: Constants.messageItemTextSecondaryColor,
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
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: Constants.messageItemTimeMaxWidth,
                ),
                child: Text(
                  TimeUtils.handleMsgTimeDiff(info.receiveTime),
                  style: TextStyle(
                    fontSize:
                        (Theme.of(context).textTheme.bodySmall?.fontSize ??
                                Constants.textSecondarySize) *
                            FontScaleUtils.fontSizeRatio,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyBuilder(BuildContext context) {
    return Image.asset(
      info.menuIcon,
      width: Constants.messageItemIconSize,
      height: Constants.messageItemIconSize,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Constants.messageItemIconBgColor,
          borderRadius: BorderRadius.circular(
            Constants.messageItemIconBorderRadius,
          ),
        ),
      ),
    );
  }
}
