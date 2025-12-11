import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/lib_widget.dart';
import 'package:get/get.dart';
import '../components/font_size_slider.dart';
import '../utils/font_scale_utils.dart';
import '../viewmodels/setting_font_vm.dart';
import '../components/button_group.dart' as setting;
import 'package:module_setfontsize/constants/constants.dart';

/// 字体大小设置页面
class SettingFont extends StatefulWidget {
  const SettingFont({super.key});

  @override
  State<SettingFont> createState() => _SettingFontState();
}

class _SettingFontState extends BaseStatefulWidgetState<SettingFont> {
  final controller = Get.put(SettingFontViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
      body: Column(
        children: [
          NavHeaderBar(
            title: '字体大小',
            windowModel: controller.windowModel,
            bgColor: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
            titleColor: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
            backButtonBackgroundColor: settingInfo.darkSwitch
                ? Constants.FONT_BUTTON_DARK_COLOR
                : Constants.FONT_BUTTON_COLOR,
            backButtonPressedBackgroundColor: settingInfo.darkSwitch
                ? Constants.FONT_PRESSED_BUTTON_DARK_COLOR 
                : Constants.FONT_PRESSED_BUTTON_COLOR, 
            customTitleSize: Constants.SPACE_20 * FontScaleUtils.fontSizeRatio,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: CommonConstants.SPACE_L),
              child: Column(
                children: [
                  Obx(() => setting.ButtonGroup(
                        buttonList: SettingFontViewModel.buttonList,
                        selectedId: controller.selectedId.value,
                        onSelected: controller.switchButton,
                        isDark: settingInfo.darkSwitch,
                      )),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: Constants.SPACE_16, bottom: Constants.SPACE_16),
                        child: Obx(() => controller.showListSample
                            ? _buildListSample()
                            : _buildDetailSample()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          _buildBottomCard(),
        ],
      ),
    );
  }

  Widget _buildBottomCard() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(settingInfo.darkSwitch),
        boxShadow: [
          BoxShadow(
            color: settingInfo.darkSwitch
                ? Constants.FONT_BOTTOM_DARK_COLOR 
                : Constants.FONT_BOTTOM_COLOR,
            offset: const Offset(0, -4),
            blurRadius: Constants.SPACE_8,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: CommonConstants.SPACE_L,
        right: CommonConstants.SPACE_L,
        bottom: controller.windowModel.windowBottomPadding +
            CommonConstants.SPACE_L,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => FontSizeSlider(
                currentRatio: controller.currentRatio.value,
                onRatioChanged: (ratio) =>
                    controller.updateFontRatio(ratio.value),
              )),

          const SizedBox(height: Constants.SPACE_16), 

          SizedBox(
            width: double.infinity,
            height: Constants.SPACE_40,
            child: ElevatedButton(
              onPressed: () =>
                  controller.confirm(controller.currentRatio.value),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.appTheme,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.SPACE_20), 
                ),
                elevation: 0,
              ),
              child: Text(
                '确定',
                style: TextStyle(
                  fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSample() {
    return Obx(() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '住建部称住宅层高标准将提至不低于3米，层高低的房子不值钱了？',
                    style: TextStyle(
                      fontSize: Constants.FONT_16 * controller.currentRatio.value,
                      fontWeight: FontWeight.w500,
                      color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: CommonConstants.SPACE_XS),
                  Text(
                    '央视新闻  2小时前',
                    style: TextStyle(
                      fontSize: Constants.FONT_12 * FontScaleUtils.fontSizeRatio,
                      color:
                          ThemeColors.getFontSecondary(settingInfo.darkSwitch),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: CommonConstants.SPACE_M),
            ClipRRect(
              borderRadius: BorderRadius.circular(Constants.SPACE_4),
              child: Image.asset(
                Constants.sampleListImage,
                width: Constants.SPACE_72,
                height: Constants.SPACE_72,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: Constants.SPACE_72,
                    height: Constants.SPACE_72,
                    decoration: BoxDecoration(
                      color: Constants.ACTIVE_TRACK_SELECT_COLOR,
                      borderRadius: BorderRadius.circular(Constants.SPACE_4),
                    ),
                    child: const Icon(
                      Icons.image,
                      color: Constants.SLIDER_TEXT_COLOR,
                      size: Constants.SPACE_32,
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildDetailSample() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '住建部称住宅层高标准将提至不低于3米，层高低的房子不值钱了？',
              style: TextStyle(
                fontSize: Constants.FONT_20 * controller.currentRatio.value,
                fontWeight: FontWeight.w500,
                color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
              ),
            ),

            const SizedBox(height: CommonConstants.SPACE_S),

            // 作者信息行
            Row(
              children: [
                // 用户头像，使用鸿蒙原生图片
                ClipOval(
                  child: Image.asset(
                    Constants.sampleUserIconImage,
                    width: Constants.SPACE_40,
                    height: Constants.SPACE_40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: Constants.SPACE_40,
                        height: Constants.SPACE_40,
                        decoration: BoxDecoration(
                          color: Constants.ACTIVE_TRACK_SELECT_COLOR,
                          borderRadius: BorderRadius.circular(Constants.SPACE_20),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Constants.SLIDER_TEXT_COLOR,
                          size: Constants.SPACE_20,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: CommonConstants.SPACE_M),

                // 作者信息
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '新闻客户端',
                      style: TextStyle(
                        fontSize: Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
                        fontWeight: FontWeight.w500,
                        color:
                            ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                      ),
                    ),
                    const SizedBox(height: CommonConstants.SPACE_XXS),
                    Text(
                      '2025-05-04 12:30',
                      style: TextStyle(
                        fontSize: Constants.FONT_12 * FontScaleUtils.fontSizeRatio,
                        color: ThemeColors.getFontSecondary(
                            settingInfo.darkSwitch),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // 关注按钮
                Container(
                  height: Constants.SPACE_20,
                  padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_12),
                  decoration: BoxDecoration(
                    color: Constants.ACTIVE_TRACK_COLOR,
                    borderRadius: BorderRadius.circular(Constants.SPACE_14),
                  ),
                  child: Center(
                    child: Text(
                      '关注',
                      style: TextStyle(
                        fontSize: Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: CommonConstants.SPACE_L),

            // 正文内容
            Text(
              '"竞高品质住宅建设方案"是北京今年首批集中供地提出的竞拍规则之一。30个开拍地块中，有8个因触及"竞地价+竞公共租赁住房面积"或"竞地价+竞政府持有商品住宅产权份额"等上限后转入"竞高标准商品住宅建设方案"环节，最终，通过评选组评分确定了8宗商品住宅用地竞得人。',
              style: TextStyle(
                fontSize: Constants.FONT_16 * controller.currentRatio.value,
                color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                height: 1.6,
              ),
            ),

            const SizedBox(height: CommonConstants.SPACE_L),

            ClipRRect(
              borderRadius: BorderRadius.circular(Constants.SPACE_4),
              child: Image.asset(
                Constants.sampleDetailImage,
                width: double.infinity,
                height: Constants.SPACE_200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: Constants.SPACE_200,
                    decoration: BoxDecoration(
                      color: Constants.ACTIVE_TRACK_SELECT_COLOR,
                      borderRadius: BorderRadius.circular(Constants.SPACE_4),
                    ),
                    child: const Icon(
                      Icons.image,
                      color: Constants.SLIDER_TEXT_COLOR,
                      size: Constants.SPACE_48,
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    Get.delete<SettingFontViewModel>();
    super.dispose();
  }
}
