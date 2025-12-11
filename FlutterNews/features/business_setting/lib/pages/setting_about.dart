import 'package:business_setting/constants/constants.dart';
import 'package:business_setting/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/lib_widget.dart';
import 'package:get/get.dart';
import '../viewmodels/setting_about_vm.dart';
import 'package:module_setfontsize/module_setfontsize.dart';

class SettingAbout extends StatefulWidget {
  const SettingAbout({super.key});

  @override
  State<SettingAbout> createState() => _SettingAboutState();
}

class _SettingAboutState extends BaseStatefulWidgetState<SettingAbout> {
  final controller = Get.put(
    SettingAboutVM(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.getBackgroundSecondary(
        settingInfo.darkSwitch,
      ),
      body: Column(
        children: [
          NavHeaderBar(
            title: '关于',
            windowModel: controller.windowModel,
            bgColor: ThemeColors.getBackgroundSecondary(
              settingInfo.darkSwitch,
            ),
            titleColor: ThemeColors.getFontPrimary(
              settingInfo.darkSwitch,
            ),
            backButtonBackgroundColor: settingInfo.darkSwitch
                ? Constants.backButtonBackgroundDarkColor
                : Constants.backButtonBackgroundColor,
            backButtonPressedBackgroundColor: settingInfo.darkSwitch
                ? Constants.backButtonPressedBackgroundDarkColor
                : Constants.backButtonPressedBackgroundColor,
            customTitleSize: Constants.FONT_20 * FontScaleUtils.fontSizeRatio,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.SPACE_16,
              ),
              children: [
                _buildAppInfo(),
                _buildCardInfo(context),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: Constants.SPACE_16,
              right: Constants.SPACE_16,
              bottom: controller.windowModel.windowBottomPadding +
                  Constants.SPACE_16,
            ),
            child: _buildBottomInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Container(
      height: Constants.SPACE_224,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Constants.SPACE_12,
            ),
            child: Image.asset(
              Assets.assetsAppIcon,
              package: Constants.packageName,
              width: Constants.SPACE_72,
              height: Constants.SPACE_72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: Constants.SPACE_8,
          ),
          Obx(
            () => Text(
              controller.appName.value,
              style: TextStyle(
                fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                fontWeight: FontWeight.w500,
                color: ThemeColors.getFontPrimary(
                  settingInfo.darkSwitch,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.SPACE_16,
        vertical: Constants.SPACE_20,
      ),
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(
          settingInfo.darkSwitch,
        ),
        borderRadius: BorderRadius.circular(
          Constants.SPACE_12,
        ),
      ),
      child: Column(
        children: [
          // 版本信息
          GestureDetector(
            onTap: controller.checkForUpdate,
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '版本信息',
                            style: TextStyle(
                              fontSize: Constants.FONT_16 *
                                  FontScaleUtils.fontSizeRatio,
                              fontWeight: FontWeight.w500,
                              color: ThemeColors.getFontPrimary(
                                  settingInfo.darkSwitch),
                            ),
                          ),
                          const SizedBox(
                            width: Constants.SPACE_8,
                          ),
                          Obx(
                            () => controller.hasNewVersion.value
                                ? Container(
                                    width: Constants.SPACE_6,
                                    height: Constants.SPACE_6,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: CommonConstants.SPACE_XS,
                      ),
                      Obx(
                        () => Text(
                          controller.appVersionName.value,
                          style: TextStyle(
                            fontSize: Constants.FONT_14 *
                                FontScaleUtils.fontSizeRatio,
                            color: ThemeColors.getFontSecondary(
                              settingInfo.darkSwitch,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Obx(() => controller.isCheckingUpdate
                        ? SizedBox(
                            width: Constants.SPACE_24,
                            height: Constants.SPACE_24,
                            child: CircularProgressIndicator(
                              strokeWidth: Constants.SPACE_2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ThemeColors.getFontSecondary(
                                  settingInfo.darkSwitch,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            controller.updateLabel.value,
                            style: TextStyle(
                              fontSize: Constants.FONT_14 *
                                  FontScaleUtils.fontSizeRatio,
                              color: ThemeColors.getFontSecondary(
                                settingInfo.darkSwitch,
                              ),
                            ),
                          )),
                    const SizedBox(
                      width: Constants.SPACE_8,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: Constants.FONT_14,
                      color: ThemeColors.getArrowIcon(
                        settingInfo.darkSwitch,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 分割线
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: Constants.SPACE_16,
            ),
            height: Constants.SPACE_0_5,
            color: ThemeColors.getDivider(
              settingInfo.darkSwitch,
            ),
          ),

          // 客服电话
          GestureDetector(
            onTap: controller.makePhoneCall,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '客服电话',
                        style: TextStyle(
                          fontSize:
                              Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                          fontWeight: FontWeight.w500,
                          color: ThemeColors.getFontPrimary(
                              settingInfo.darkSwitch),
                        ),
                      ),
                      const SizedBox(
                        height: Constants.SPACE_4,
                      ),
                      Text(
                        controller.hotline.value,
                        style: TextStyle(
                          fontSize:
                              Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
                          color: ThemeColors.getFontSecondary(
                              settingInfo.darkSwitch),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部信息（版权等）
  Widget _buildBottomInfo() {
    return Column(
      children: [
        // 备案号（可点击）
        GestureDetector(
          onTap: controller.goWebsite,
          child: Text(
            '苏ICP备17040376号-135A',
            style: TextStyle(
              fontSize: Constants.FONT_12 * FontScaleUtils.fontSizeRatio,
              color: ThemeColors.appTheme,
            ),
          ),
        ),
        const SizedBox(
          height: Constants.SPACE_4,
        ),
        // 版权信息
        Text(
          '华为xx 版权所有 © 2019-2025',
          style: TextStyle(
            fontSize: Constants.FONT_12 * FontScaleUtils.fontSizeRatio,
            fontWeight: FontWeight.w400,
            color: ThemeColors.getFontSecondary(
              settingInfo.darkSwitch,
            ),
          ),
        ),
        const SizedBox(
          height: Constants.SPACE_4,
        ),
        // 技术支持
        Text(
          '技术支持：xxxxxxxx',
          style: TextStyle(
            fontSize: Constants.FONT_12 * FontScaleUtils.fontSizeRatio,
            fontWeight: FontWeight.w400,
            color: ThemeColors.getFontSecondary(
              settingInfo.darkSwitch,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    Get.delete<SettingAboutVM>();
    super.dispose();
  }
}
