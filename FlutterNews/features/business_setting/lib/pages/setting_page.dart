import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/lib_widget.dart';
import '../viewmodels/setting_vm.dart';
import '../components/setting_card.dart';
import 'package:module_setfontsize/module_setfontsize.dart';
import '../utils/setting_text_styles.dart';
import '../types/types.dart';
import '../constants/constants.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends BaseStatefulWidgetState<SettingPage> {
  final controller = Get.put(SettingViewModel());

  static const double _borderRadius = Constants.SPACE_12;
  static const double _normalItemVerticalPadding = Constants.SPACE_14;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: ThemeColors.getBackgroundSecondary(
        settingInfo.darkSwitch,
      ),
      body: Column(
        children: [
          NavHeaderBar(
            title: '设置',
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
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(
                Constants.SPACE_16,
              ),
              children: [
                // 第一组：个人信息、隐私设置
                _buildSettingGroupFromList(
                  controller.list1,
                ),
                const SizedBox(
                  height: Constants.SPACE_16,
                ),

                // 第二组：通知开关、播放与网络设置、清理缓存
                _buildSettingGroupFromList(
                  controller.list2,
                ),
                const SizedBox(
                  height: Constants.SPACE_16,
                ),

                // 第三组：夜间模式、字体大小
                _buildSettingGroupFromList(
                  controller.list3,
                ),
                const SizedBox(
                  height: Constants.SPACE_16,
                ),

                // 第四组：检测版本、关于我们
                _buildSettingGroupFromList(
                  controller.list4,
                ),
              ],
            ),
          ),
          Obx(
            () => controller.isUserLoggedIn.value
                ? _buildLogoutButton(
                    context,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// 构建设置组（从 SettingItem 列表）
  Widget _buildSettingGroupFromList(RxList<SettingItem> items) {
    List<Widget> itemWidgets = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;

      if (item.typeSwitch == true) {
        bool switchValue;
        if (item.tag == SettingItemTag.notification) {
          switchValue = controller.pushSettingItem.value.switchV ?? false;
        } else if (item.tag == SettingItemTag.darkMode) {
          switchValue = controller.colorSettingItem.value.switchV ?? false;
        } else {
          switchValue = item.switchV ?? false;
        }

        itemWidgets.add(SettingCard(
          title: item.label,
          value: switchValue,
          onChanged: (
            value,
          ) =>
              item.onClick?.call(
            value,
          ),
          isLast: isLast,
        ));
      } else {
        itemWidgets.add(_buildNormalItem(
          item: item,
          isLast: isLast,
        ));
      }

      if (!isLast) {
        itemWidgets.add(
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
          _borderRadius,
        ),
      ),
      child: Column(
        children: itemWidgets,
      ),
    );
  }

  Widget _buildNormalItem({
    required SettingItem item,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: () => item.onClick?.call(
        null,
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.SPACE_16,
          vertical: _normalItemVerticalPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.label,
              style: SettingTextStyles.listItemTitle(
                settingInfo.darkSwitch,
              ),
            ),
            Row(
              children: [
                if (item.extraLabel != null && item.extraLabel!.isNotEmpty)
                  Text(
                    item.extraLabel!,
                    style: SettingTextStyles.rightText(
                      settingInfo.darkSwitch,
                    ),
                  ),
                if (item.extraLabel != null && item.extraLabel!.isNotEmpty)
                  const SizedBox(
                    width: Constants.SPACE_4,
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
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Constants.SPACE_16,
        right: Constants.SPACE_16,
        top: Constants.SPACE_8,
        bottom: controller.windowModel.windowBottomPadding + Constants.SPACE_8,
      ),
      child: Obx(
        () => Container(
          width: double.infinity,
          height: Constants.SPACE_40,
          decoration: BoxDecoration(
            color: ThemeColors.getBackgroundTertiary(
              settingInfo.darkSwitch,
            ),
            borderRadius: BorderRadius.circular(
              Constants.SPACE_20,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: controller.isLoggingOut.value
                  ? null
                  : () => controller.logout(context),
              borderRadius: BorderRadius.circular(
                Constants.SPACE_8,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.isLoggingOut.value) ...[
                      SizedBox(
                        width: Constants.SPACE_16,
                        height: Constants.SPACE_16,
                        child: CircularProgressIndicator(
                          strokeWidth: Constants.SPACE_2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ThemeColors.getFontPrimary(
                              settingInfo.darkSwitch,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: Constants.SPACE_8,
                      ),
                    ],
                    Text(
                      controller.logoutButtonLabel,
                      style: TextStyle(
                        fontSize:
                            Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                        fontWeight: FontWeight.w500,
                        color:
                            ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
