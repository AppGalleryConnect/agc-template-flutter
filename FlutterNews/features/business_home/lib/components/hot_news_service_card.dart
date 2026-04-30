import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_news_api/params/base/base_model.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:module_setfontsize/module_setfontsize.dart';
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
    final settingInfo = SettingModel.getInstance();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            height: Constants.hotNewsTabContainerHeight,
            margin: const EdgeInsets.only(bottom: Constants.spacingS),
            decoration: BoxDecoration(
              color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
              borderRadius:
                  BorderRadius.circular(Constants.hotNewsTabBorderRadius),
            ),
            padding: Constants.hotNewsTabPadding,
            child: Row(
              children: [
                Expanded(child: _buildTabButton(0, context)),
                Expanded(child: _buildTabButton(1, context)),
                Expanded(child: _buildTabButton(2, context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(int tabIndex, BuildContext context) {
    final isSelected = selectedTabIndex == tabIndex;
    final settingInfo = SettingModel.getInstance();

    return SizedBox(
      height: Constants.hotNewsTabButtonHeight,
      width: double.infinity,
      child: GestureDetector(
        onTap: () => _handleTabTap(tabIndex),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: Constants.hotNewsTabButtonPadding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? ThemeColors.getBackgroundTertiary(settingInfo.darkSwitch)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
              Constants.hotNewsTabButtonBorderRadius,
            ),
          ),
          child: Text(
            Constants.tabs[tabIndex],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Constants.fontSizeTiny,
              color: isSelected
                  ? ThemeColors.getFontPrimary(settingInfo.darkSwitch)
                  : Constants.hotNewsTabTextColor,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
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
