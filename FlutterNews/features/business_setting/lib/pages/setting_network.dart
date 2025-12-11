import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/lib_widget.dart';
import 'package:get/get.dart';
import '../viewmodels/setting_network_vm.dart';
import 'package:module_setfontsize/module_setfontsize.dart';
import '../utils/setting_text_styles.dart';
import '../constants/constants.dart';

/// 播放与网络设置页面
class SettingNetwork extends StatefulWidget {
  const SettingNetwork({super.key});

  @override
  State<SettingNetwork> createState() => _SettingNetworkState();
}

class _SettingNetworkState extends BaseStatefulWidgetState<SettingNetwork> {
  final controller = Get.put(SettingNetworkVM());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return Scaffold(
            backgroundColor:
                ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
            body: Column(
              children: [
                _buildNavHeaderBar(),
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor:
              ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
          body: Column(
            children: [
              _buildNavHeaderBar(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(Constants.SPACE_16),
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: Constants.SPACE_12),
                      child: Text(
                        '网络设置',
                        style: SettingTextStyles.groupTitle(
                            settingInfo.darkSwitch),
                      ),
                    ),
                    _buildSettingGroup([
                      _buildSelectItem(
                        title: '非WLAN网络流量',
                        value: controller.nonWlanTrafficText,
                        onTap: () => _showTrafficSelectDialog(),
                        isLast: false,
                      ),
                      _buildSelectItem(
                        title: '非WLAN网络播放提醒',
                        value: controller.nonWlanPlayReminderText,
                        onTap: () => _showPlayReminderSelectDialog(),
                        isLast: false,
                      ),
                      Obx(() => _buildSwitchItem(
                            title: '使用移动网络改善内容浏览体验',
                            subtitle: '如Wi-Fi网络质量差，将使用移动网络改善',
                            value: controller
                                .improveExperienceWithMobileData.value,
                            onChanged: controller.toggleImproveExperience,
                            isLast: true,
                          )),
                    ]),
                    const SizedBox(height: Constants.SPACE_16),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: Constants.SPACE_12),
                      child: Text(
                        '视频播放设置',
                        style: SettingTextStyles.groupTitle(
                            settingInfo.darkSwitch),
                      ),
                    ),
                    _buildSettingGroup(
                      [
                        Obx(() => _buildSwitchItem(
                              title: '视频自动下滑',
                              subtitle: '视频观看结束将自动下滑至下一个视频',
                              value: controller.autoSlideDown.value,
                              onChanged: controller.toggleAutoSlideDown,
                              isLast: false,
                            )),
                        Obx(
                          () => _buildSwitchItem(
                            title: '推荐频道自动播放视频',
                            value: controller.autoPlayRecommended.value,
                            onChanged: controller.toggleAutoPlayRecommended,
                            isLast: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavHeaderBar() {
    return NavHeaderBar(
      title: '播放与网络设置',
      windowModel: controller.windowModel,
      bgColor: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
      titleColor: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
      backButtonBackgroundColor: settingInfo.darkSwitch
          ? Constants.backButtonBackgroundDarkColor
          : Constants.backButtonBackgroundColor,
      backButtonPressedBackgroundColor: settingInfo.darkSwitch
          ? Constants.backButtonPressedBackgroundDarkColor
          : Constants.backButtonPressedBackgroundColor,
      customTitleSize: 20 * FontScaleUtils.fontSizeRatio,
    );
  }

  Widget _buildSettingGroup(List<Widget> children) {
    List<Widget> itemsWithDividers = [];

    for (int i = 0; i < children.length; i++) {
      itemsWithDividers.add(children[i]);

      if (i < children.length - 1) {
        itemsWithDividers.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
            height: Constants.SPACE_0_5,
            color: ThemeColors.getDivider(settingInfo.darkSwitch),
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

  Widget _buildSelectItem({
    required String title,
    required String value,
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
            Expanded(
              child: Text(
                title,
                style: SettingTextStyles.listItemTitle(
                  settingInfo.darkSwitch,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: Constants.SPACE_8,
            ),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: SettingTextStyles.rightText(
                        settingInfo.darkSwitch,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
            ),
          ],
        ),
      ),
    );
  }

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
              inactiveTrackColor:
                  ThemeColors.getBackgroundTertiary(settingInfo.darkSwitch),
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

  void _showTrafficSelectDialog() {
    final options = ['最佳效果（下载大图）', '较省流量（智能下载）', '极省流量（不下载图）'];
    final currentIndex = controller.settingInfo.network.downloadWithoutWlan;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.getCardBackground(
          settingInfo.darkSwitch,
        ),
        title: Text(
          '非WLAN网络流量',
          style: TextStyle(
            fontSize: Constants.FONT_18 * FontScaleUtils.fontSizeRatio,
            fontWeight: FontWeight.w600,
            color: ThemeColors.getFontPrimary(
              settingInfo.darkSwitch,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: Constants.SPACE_8,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(options.length, (index) {
            return RadioListTile<int>(
              title: Text(
                options[index],
                style: TextStyle(
                  fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                  color: ThemeColors.getFontPrimary(
                    settingInfo.darkSwitch,
                  ),
                ),
              ),
              value: index,
              groupValue: currentIndex,
              activeColor: ThemeColors.appTheme,
              onChanged: (value) {
                if (value != null) {
                  controller.selectNonWlanTrafficOption(
                    value,
                  );
                  RouterUtils.of.pop();
                }
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(
              context,
            ),
            child: Text(
              '取消',
              style: TextStyle(
                fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                color: ThemeColors.getFontSecondary(
                  settingInfo.darkSwitch,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPlayReminderSelectDialog() {
    final options = ['提醒一次', '每次提醒'];
    final currentIndex = controller.settingInfo.network.remindWithoutWlan;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.getCardBackground(
          settingInfo.darkSwitch,
        ),
        title: Text(
          '非WLAN网络播放提醒',
          style: TextStyle(
            fontSize: Constants.FONT_18 * FontScaleUtils.fontSizeRatio,
            fontWeight: FontWeight.w600,
            color: ThemeColors.getFontPrimary(
              settingInfo.darkSwitch,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: Constants.SPACE_8,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            options.length,
            (
              index,
            ) {
              return RadioListTile<int>(
                title: Text(
                  options[index],
                  style: TextStyle(
                    fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                    color: ThemeColors.getFontPrimary(
                      settingInfo.darkSwitch,
                    ),
                  ),
                ),
                value: index,
                groupValue: currentIndex,
                activeColor: ThemeColors.appTheme,
                onChanged: (
                  value,
                ) {
                  if (value != null) {
                    controller.selectNonWlanPlayReminderOption(
                      value,
                    );
                    Navigator.pop(
                      context,
                    );
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(
              context,
            ),
            child: Text(
              '取消',
              style: TextStyle(
                fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                color: ThemeColors.getFontSecondary(
                  settingInfo.darkSwitch,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<SettingNetworkVM>();
    super.dispose();
  }
}
