import 'package:flutter/material.dart';
import 'package:lib_news_api/params/base/base_model.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import '../commons/constants.dart';

class HotNewsServiceCard extends StatelessWidget {
  final NewsResponse cardData;
  final NavInfo navInfo;
  final int cardIndex;
  final int selectedTabIndex;
  final Function(int) onTabTap;

  const HotNewsServiceCard({
    super.key,
    required this.cardData,
    required this.navInfo,
    required this.cardIndex,
    required this.selectedTabIndex,
    required this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            height: Constants.hotNewsTabContainerHeight,
            margin: const EdgeInsets.only(bottom: Constants.spacingS),
            decoration: BoxDecoration(
              color: Constants.hotNewsTabBackgroundColor,
              borderRadius:
                  BorderRadius.circular(Constants.hotNewsTabBorderRadius),
            ),
            padding: Constants.hotNewsTabPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTabButton(0, context),
                const SizedBox(width: Constants.hotNewsTabSpacing),
                _buildTabButton(1, context),
                const SizedBox(width: Constants.hotNewsTabSpacing),
                _buildTabButton(2, context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(int tabIndex, BuildContext context) {
    final isSelected = selectedTabIndex == tabIndex;
    return SizedBox(
      height: Constants.hotNewsTabButtonHeight,
      width: MediaQuery.of(context).size.width / 3 - 30,
      child: GestureDetector(
        onTap: () => _handleTabTap(tabIndex),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: Constants.hotNewsTabAnimationDuration,
          curve: Curves.easeInOut,
          padding: Constants.hotNewsTabButtonPadding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Constants.whiteColor : Colors.transparent,
            boxShadow: isSelected
                ? [
                    const BoxShadow(
                      color: Constants.blackTransparentColor,
                      blurRadius: Constants.hotNewsTabShadowBlurRadius,
                      spreadRadius: Constants.hotNewsTabShadowSpreadRadius,
                    )
                  ]
                : null,
            borderRadius: BorderRadius.circular(
              Constants.hotNewsTabButtonBorderRadius,
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: Constants.hotNewsTabAnimationDuration,
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: Constants.fontSizeTiny,
              color: isSelected
                  ? Constants.blackColor
                  : Constants.hotNewsTabTextColor,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
            child: Text(
              Constants.tabs[tabIndex],
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  void _handleTabTap(int tabIndex) {
    debugPrint('切换到标签：${Constants.tabs[tabIndex]}（索引：$tabIndex）');
    onTabTap(tabIndex);
  }
}
