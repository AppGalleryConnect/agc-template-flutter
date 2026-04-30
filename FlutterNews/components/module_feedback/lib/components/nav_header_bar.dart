import 'package:flutter_svg/svg.dart';
import 'package:lib_common/lib_common.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';
import '../common/constants.dart';
import 'package:flutter/material.dart';

class NavHeaderBar extends StatelessWidget {
  final String title;
  final bool showBackBtn;
  final bool hasBgColor;
  final bool isSubTitle;
  final Function()? onBackPress;

  const NavHeaderBar({
    super.key,
    this.title = '',
    this.showBackBtn = true,
    this.hasBgColor = false,
    this.isSubTitle = true,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    final settingInfo = SettingModel.getInstance();
    return Container(
      color: hasBgColor
          ? ThemeColors.getBackgroundColor(settingInfo.darkSwitch)
          : Colors.transparent,
      child: SafeArea(
        top: true,
        left: true,
        right: false,
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                if (showBackBtn) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: Constants.SPACE_12),
                    child: InkWell(
                      onTap: onBackPress ?? () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(Constants.SPACE_20),
                      child: Container(
                        width: Constants.SPACE_40,
                        height: Constants.SPACE_40,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          settingInfo.darkSwitch
                              ? CommonConstants.iconBackPathDark
                              : CommonConstants.iconBackPath,
                          width: Constants.SPACE_40,
                          height: Constants.SPACE_40,
                          colorFilter: ColorFilter.mode(
                              ThemeColors.getFontPrimary(
                                  settingInfo.darkSwitch),
                              BlendMode.srcIn),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Constants.SPACE_8),
                ],
                if (title.isNotEmpty) ...[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize:
                          (isSubTitle ? Constants.FONT_18 : Constants.FONT_20) * FontScaleUtils.fontSizeRatio,
                      color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
