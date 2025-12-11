import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lib_common/lib_common.dart';
import '../commons/constants.dart';

///搜索按钮组件
class SearchButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double iconSize;
  final EdgeInsets padding;
  final double borderRadius;
  const SearchButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.iconSize = Constants.searchButtonIconSize,
    this.padding = Constants.searchButtonPadding,
    this.borderRadius = Constants.searchButtonRadius,
  });

  @override
  Widget build(BuildContext context) {
    void defaultOnPressed() {
      Navigator.of(context).pushNamed(
        RouterMap.NEWS_SEARCH_PAGE,
      );
    }

    return IconButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          backgroundColor ?? Constants.searchButtonBackgroundColor,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
          ),
        ),
        padding: WidgetStateProperty.all(padding),
      ),
      icon: SvgPicture.asset(
        Constants.searchIconPath,
        width: Constants.searchButtonIconWidth,
        height: Constants.searchButtonIconHeight,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
      ),
      onPressed: onPressed ?? defaultOnPressed,
    );
  }
}
