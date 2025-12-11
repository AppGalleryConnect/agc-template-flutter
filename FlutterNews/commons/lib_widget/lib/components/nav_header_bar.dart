import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 通用页面标题栏
class NavHeaderBar extends StatelessWidget {
  final String title;
  final bool showBackBtn;
  final Color bgColor;
  final String backImg;
  final bool isSubTitle;
  final WidgetBuilder? rightPartBuilder;
  final VoidCallback onBack;
  final WindowModel windowModel;
  final bool isCommentInModalDialog;
  final double? customTitleSize;
  final Color? titleColor;
  final Color? backButtonBackgroundColor;
  final Color? backButtonPressedBackgroundColor;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  NavHeaderBar({
    super.key,
    this.title = '',
    this.showBackBtn = false,
    this.bgColor = Colors.transparent,
    this.backImg = CommonConstants.iconBackPath,
    this.isSubTitle = true,
    this.rightPartBuilder,
    required this.windowModel,
    this.isCommentInModalDialog = false,
    this.customTitleSize,
    this.titleColor,
    this.backButtonBackgroundColor,
    this.backButtonPressedBackgroundColor,
    this.leftPadding = 0.0,
    this.rightPadding = 0.0,
    this.topPadding = 0.0,
    this.bottomPadding = 0.0,
    VoidCallback? onBack,
  }) : onBack = onBack ??
            (() {
              try {
                if (GlobalContext.globalKey.currentContext != null) {
                  RouterUtils.of.pop();
                }
              } catch (e) {
                // 忽略异常，防止崩溃
              }
            });

  @override
  Widget build(BuildContext context) {
    double finalTitleSize = customTitleSize ??
        (isSubTitle ? CommonConstants.TITLE_S : CommonConstants.TITLE_XL);
    final double finalTopPadding = topPadding > 0
        ? topPadding
        : (isCommentInModalDialog
            ? CommonConstants.PADDING_S
            : windowModel.windowTopPadding);
    return Container(
      color: bgColor,
      padding: EdgeInsets.only(
        left: leftPadding > 0 ? leftPadding : CommonConstants.PADDING_S,
        right: rightPadding > 0 ? rightPadding : CommonConstants.PADDING_L,
        top: finalTopPadding,
        bottom: bottomPadding,
      ),
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            if (showBackBtn || isSubTitle)
              PressableBackButton(
                backImg: backImg,
                onBack: onBack,
                iconColor: titleColor,
                backgroundColor: backButtonBackgroundColor,
                pressedBackgroundColor: backButtonPressedBackgroundColor,
              ),
            if (title.isNotEmpty)
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: finalTitleSize,
                    color: titleColor ??
                        const Color(CommonConstants.COLOR_FONT_PRIMARY),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            if (rightPartBuilder != null) ...[
              const Spacer(),
              rightPartBuilder!(context),
            ],
          ],
        ),
      ),
    );
  }
}

/// 可按压的返回按钮组件
class PressableBackButton extends StatefulWidget {
  final String backImg;
  final VoidCallback onBack;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? pressedBackgroundColor;
  const PressableBackButton({
    super.key,
    required this.backImg,
    required this.onBack,
    this.iconColor,
    this.backgroundColor,
    this.pressedBackgroundColor,
  });

  @override
  State<PressableBackButton> createState() => _PressableBackButtonState();
}

class _PressableBackButtonState extends State<PressableBackButton> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onPointerUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onBack();
      },
      onPointerCancel: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(right: 12, left: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _isPressed
              ? (widget.pressedBackgroundColor ?? const Color(0x0D000000))
              : (widget.backgroundColor ?? Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Transform.scale(
          scale: _isPressed ? 0.95 : 1.0,
          child: SvgPicture.asset(
            widget.backImg,
            width: 16,
            height: 16,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              widget.iconColor ??
                  const Color(CommonConstants.COLOR_FONT_PRIMARY),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
