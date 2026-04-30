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
                Obx(() {
                  return _buildSettingGroupFromList(controller.list1);
                }),
                const SizedBox(
                  height: Constants.SPACE_16,
                ),

                // 第二组：通知开关、播放与网络设置、清理缓存
                Obx(() {
                  return _buildSettingGroupFromList(controller.list2);
                }),
                const SizedBox(
                  height: Constants.SPACE_16,
                ),

                // 第三组：夜间模式、字体大小
                Obx(() {
                  return _buildSettingGroupFromList(controller.list3);
                }),
                const SizedBox(
                  height: Constants.SPACE_16,
                ),

                // 第四组：检测版本、关于我们
                Obx(() {
                  return _buildSettingGroupFromList(controller.list4);
                }),
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
      } else if (item.typeSelect == true &&
          item.tag == SettingItemTag.darkMode) {
        itemWidgets.add(_buildMenuSelect());
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

  Widget _buildMenuSelect() {
    final settingInfo = SettingModel.getInstance();

    final List<Map<String, dynamic>> themeOptions = [
      {'label': '跟随系统', 'value': 0},
      {'label': '普通模式', 'value': 1},
      {'label': '夜间模式', 'value': 2},
    ];
    String getCurrentThemeLabel() {
      return themeOptions.firstWhere(
        (option) => option['value'] == settingInfo.currentThemeMode,
        orElse: () => {'label': '跟随系统'},
      )['label'];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '夜间模式',
            style: TextStyle(
              fontSize: 16,
              color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
              fontWeight: FontWeight.w500,
            ),
          ),
          InkWell(
            onTap: () {
              _showThemeModeDialog();
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Row(
              children: [
                Text(
                  getCurrentThemeLabel(),
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> toDarkSwitch(int mode) async {
    switch (mode) {
      case 0:
        // 跟随系统
        final isSystemDark = await DarkModeUtils.querySystemMode();
        settingInfo.darkSwitch = isSystemDark;
        break;
      case 1:
        // 关闭暗黑模式
        settingInfo.darkSwitch = false;
        break;
      case 2:
        // 开启暗黑模式
        settingInfo.darkSwitch = true;
        break;
      default:
        break;
    }
  }

  void _showThemeModeDialog() {
    final options = ['跟随系统', '普通模式', '夜间模式'];
    final currentIndex = settingInfo.currentThemeMode;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.getCardBackground(
          settingInfo.darkSwitch,
        ),
        title: Text(
          '模式设置',
          style: TextStyle(
            fontSize: Constants.FONT_18 * settingInfo.fontSizeRatio,
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
                  fontSize: Constants.FONT_16 * settingInfo.fontSizeRatio,
                  color: ThemeColors.getFontPrimary(
                    settingInfo.darkSwitch,
                  ),
                ),
              ),
              value: index,
              groupValue: currentIndex,
              activeColor: ThemeColors.appTheme,
              onChanged: (value) async {
                if (value != null) {
                  settingInfo.currentThemeMode = value;
                  await toDarkSwitch(settingInfo.currentThemeMode);
                  DarkModeUtils.setDarkMode(settingInfo.darkSwitch);
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
                fontSize: Constants.FONT_16 * settingInfo.fontSizeRatio,
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
