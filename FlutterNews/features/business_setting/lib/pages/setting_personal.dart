import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/lib_widget.dart';
import 'package:get/get.dart';
import '../viewmodels/setting_personal_vm.dart';
import 'package:module_setfontsize/module_setfontsize.dart';
import '../components/edit_bottom_sheet.dart';
import 'dart:io';
import '../constants/constants.dart';

class SettingPersonal extends StatefulWidget {
  const SettingPersonal({
    super.key,
  });

  @override
  State<SettingPersonal> createState() => _SettingPersonalState();
}

class _SettingPersonalState extends BaseStatefulWidgetState<SettingPersonal> {
  final controller = Get.put(
    SettingPersonalVM(),
  );

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
            title: '个人信息',
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
                _buildAvatarSection(),
                const SizedBox(
                  height: Constants.SPACE_12,
                ),
                _buildInfoGroup(
                  [
                    Obx(
                      () => _buildInfoItem(
                        title: '昵称',
                        value: controller.username,
                        onTap: () {
                          controller.editUsername();
                          _showEditNicknameSheet(
                            context,
                          );
                        },
                        height: Constants.SPACE_48,
                      ),
                    ),
                    Obx(
                      () => _buildInfoItem(
                        title: '手机号',
                        value: controller.phoneNumber.isEmpty
                            ? '未绑定'
                            : controller.phoneNumber,
                        onTap: () {
                          controller.editPhone();
                          _showEditPhoneSheet(
                            context,
                          );
                        },
                        height: Constants.SPACE_48,
                        isLast: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: Constants.SPACE_12,
                ),
                Obx(
                  () => _buildSingleInfoCard(
                    title: '个人简介',
                    value: controller.personalBio,
                    onTap: () {
                      controller.editBio();
                      _showEditBioSheet(
                        context,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建头像区域
  Widget _buildAvatarSection() {
    return Container(
      height: Constants.SPACE_56,
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(
          settingInfo.darkSwitch,
        ),
        borderRadius: BorderRadius.circular(
          Constants.SPACE_12,
        ),
      ),
      child: GestureDetector(
        onTap: controller.pickAvatar,
        child: Padding(
          padding: const EdgeInsets.all(
            Constants.SPACE_8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '头像',
                style: TextStyle(
                  fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                  fontWeight: FontWeight.w500,
                  color: ThemeColors.getFontPrimary(
                    settingInfo.darkSwitch,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () {
                      final avatar = controller.avatarPath.value;
                      String cleanPath = avatar;
                      if (avatar.startsWith(
                        'file://',
                      )) {
                        cleanPath = avatar.substring(7);
                      }

                      return ClipOval(
                        child: cleanPath.startsWith('http')
                            ? Image.network(
                                cleanPath,
                                width: Constants.SPACE_40,
                                height: Constants.SPACE_40,
                                fit: BoxFit.cover,
                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return _buildDefaultAvatar();
                                },
                              )
                            : (cleanPath.startsWith(
                                      '/',
                                    ) ||
                                    cleanPath.startsWith(
                                      'file:',
                                    )
                                ? Image.file(
                                    File(
                                      cleanPath,
                                    ),
                                    width: Constants.SPACE_40,
                                    height: Constants.SPACE_40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return _buildDefaultAvatar();
                                    },
                                  )
                                : Image.asset(
                                    cleanPath,
                                    width: Constants.SPACE_40,
                                    height: Constants.SPACE_40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildDefaultAvatar();
                                    },
                                  )),
                      );
                    },
                  ),
                  const SizedBox(
                    width: Constants.SPACE_4,
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
            ],
          ),
        ),
      ),
    );
  }

  /// 构建信息组（昵称和手机号）
  Widget _buildInfoGroup(List<Widget> children) {
    List<Widget> itemsWithDividers = [];

    for (int i = 0; i < children.length; i++) {
      itemsWithDividers.add(children[i]);

      if (i < children.length - 1) {
        itemsWithDividers.add(
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: Constants.SPACE_12,
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
      padding: const EdgeInsets.all(
        Constants.SPACE_8,
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
        children: itemsWithDividers,
      ),
    );
  }

  /// 构建默认头像
  Widget _buildDefaultAvatar() {
    return Container(
      width: Constants.SPACE_40,
      height: Constants.SPACE_40,
      decoration: BoxDecoration(
        color: ThemeColors.getBackgroundTertiary(
          settingInfo.darkSwitch,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        color: ThemeColors.getFontSecondary(
          settingInfo.darkSwitch,
        ),
        size: Constants.SPACE_20,
      ),
    );
  }

  /// 构建信息项（昵称、手机号）
  Widget _buildInfoItem({
    required String title,
    required String value,
    required VoidCallback onTap,
    double height = Constants.SPACE_48,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(
          Constants.SPACE_8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                fontWeight: FontWeight.w500,
                color: ThemeColors.getFontPrimary(
                  settingInfo.darkSwitch,
                ),
              ),
            ),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize:
                            Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
                        color: ThemeColors.getFontSecondary(
                          settingInfo.darkSwitch,
                        ),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(
                    width: Constants.SPACE_4,
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
          ],
        ),
      ),
    );
  }

  /// 构建单个信息卡片（个人简介）
  Widget _buildSingleInfoCard({
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return Container(
      height: Constants.SPACE_56,
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(
          settingInfo.darkSwitch,
        ),
        borderRadius: BorderRadius.circular(
          Constants.SPACE_12,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(
            Constants.SPACE_8,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                  fontWeight: FontWeight.w500,
                  color: ThemeColors.getFontPrimary(
                    settingInfo.darkSwitch,
                  ),
                ),
              ),
              const SizedBox(
                width: Constants.SPACE_16,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (value != null && value.isNotEmpty)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: Constants.SPACE_4,
                          ),
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: Constants.FONT_14 *
                                  FontScaleUtils.fontSizeRatio,
                              color: ThemeColors.getFontSecondary(
                                settingInfo.darkSwitch,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                          ),
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
            ],
          ),
        ),
      ),
    );
  }

  /// 显示编辑昵称底部弹窗
  void _showEditNicknameSheet(BuildContext context) {
    EditBottomSheet.show(
      context: context,
      title: '设置昵称',
      hintText: '请输入昵称',
      value: controller.nickName,
      maxLength: 20,
      onConfirm: controller.modifyNickName,
      onClose: () => controller.showNickNameSheet.value = false,
    );
  }

  /// 显示编辑手机号底部弹窗
  void _showEditPhoneSheet(BuildContext context) {
    EditBottomSheet.show(
      context: context,
      title: '设置手机号',
      hintText: '请输入手机号',
      value: controller.contactPhone,
      maxLength: 11,
      keyboardType: TextInputType.phone,
      onConfirm: controller.modifyContactPhone,
      onClose: () => controller.showPhoneSheet.value = false,
    );
  }

  /// 显示编辑个人简介底部弹窗
  void _showEditBioSheet(BuildContext context) {
    EditBottomSheet.show(
      context: context,
      title: '设置个人简介',
      hintText: '请输入个人简介',
      value: controller.personalDesc,
      maxLength: 200,
      maxLines: 5,
      onConfirm: controller.modifyPersonalDesc,
      onClose: () => controller.showPersonDescSheet.value = false,
    );
  }

  @override
  void dispose() {
    Get.delete<SettingPersonalVM>();
    super.dispose();
  }
}
