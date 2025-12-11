import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/lib_widget.dart';
import 'package:get/get.dart';
import '../viewmodels/setting_privacy_vm.dart';
import 'package:module_setfontsize/module_setfontsize.dart';
import '../utils/setting_text_styles.dart';
import '../constants/constants.dart';

class SettingPrivacy extends StatefulWidget {
  const SettingPrivacy({super.key});

  @override
  State<SettingPrivacy> createState() => _SettingPrivacyState();
}

class _SettingPrivacyState extends BaseStatefulWidgetState<SettingPrivacy> {
  final controller = Get.put(
    SettingPrivacyVM(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.getBackgroundSecondary(
        settingInfo.darkSwitch,
      ),
      body: Column(
        children: [
          _buildNavHeaderBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(
                Constants.SPACE_16,
              ),
              children: [
                _buildSettingGroup(
                  [
                    Obx(
                      () => _buildSwitchItem(
                        title: '个性化推荐',
                        subtitle: '推荐符合我的个性化内容',
                        value:
                            controller.personalizedRecommendationEnabled.value,
                        onChanged: controller.togglePersonalizedRecommendation,
                        isLast: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: Constants.SPACE_16,
                ),

                // 第二组：协议和政策
                _buildSettingGroup([
                  _buildNormalItem(
                    title: '用户协议',
                    onTap: controller.openUserAgreement,
                    isLast: false,
                  ),
                  _buildNormalItem(
                    title: '隐私政策',
                    onTap: controller.openPrivacyPolicy,
                    isLast: true,
                  ),
                ]),

                const SizedBox(
                  height: Constants.SPACE_16,
                ),

                // 第三组：信息清单
                _buildSettingGroup(
                  [
                    _buildNormalItem(
                      title: '第三方信息共享清单',
                      onTap: controller.openThirdPartyInfo,
                      isLast: false,
                    ),
                    _buildNormalItem(
                      title: '个人信息收集清单',
                      onTap: controller.openPersonalInfoCollection,
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建 NavHeaderBar
  Widget _buildNavHeaderBar() {
    return NavHeaderBar(
      title: '隐私设置',
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
      customTitleSize: Constants.SPACE_20 * FontScaleUtils.fontSizeRatio,
    );
  }

  /// 构建设置组
  Widget _buildSettingGroup(List<Widget> children) {
    List<Widget> itemsWithDividers = [];

    for (int i = 0; i < children.length; i++) {
      itemsWithDividers.add(
        children[i],
      );

      if (i < children.length - 1) {
        itemsWithDividers.add(
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: Constants.SPACE_16,
            ),
            height: Constants.SPACE_0_5,
            color: ThemeColors.getDivider(
              settingInfo.darkSwitch,
            ),
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(
          settingInfo.darkSwitch,
        ),
        borderRadius: BorderRadius.circular(
          Constants.SPACE_12,
        ),
      ),
      child: Column(
        children: itemsWithDividers,
      ),
    );
  }

  /// 构建带switch的设置项
  Widget _buildSwitchItem({
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(
        Constants.SPACE_16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: SettingTextStyles.listItemTitle(
                    settingInfo.darkSwitch,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(
                    height: Constants.SPACE_4,
                  ),
                  Text(
                    subtitle,
                    style: SettingTextStyles.description(
                      settingInfo.darkSwitch,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Constants.activeTrackColor,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: ThemeColors.getBackgroundTertiary(
                settingInfo.darkSwitch,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              trackOutlineColor: WidgetStateProperty.all(
                Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建普通设置项
  Widget _buildNormalItem({
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.SPACE_16,
          vertical: Constants.SPACE_14,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: SettingTextStyles.listItemTitle(
                settingInfo.darkSwitch,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: Constants.SPACE_14,
              color: ThemeColors.getArrowIcon(
                settingInfo.darkSwitch,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<SettingPrivacyVM>();
    super.dispose();
  }
}
