import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/models/window_model.dart' as common_window;
import 'package:business_mine/utils/font_scale_utils.dart';
import 'package:business_mine/viewmodels/mine_vm.dart';
import '../constants/constants.dart';
import 'dart:io';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final MineViewModel vm = MineViewModel();
  late SettingModel settingInfo;

  void _refreshUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    settingInfo = SettingModel.getInstance();
    vm.addListener(_refreshUI);
    settingInfo.addListener(_refreshUI);
  }

  @override
  void dispose() {
    vm.removeListener(_refreshUI);
    settingInfo.removeListener(_refreshUI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(CommonConstants.NAV_HEADER_HEIGHT),
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
          child: NavHeaderBar(
            title: '我的',
            showBackBtn: false,
            isSubTitle: false,
            bgColor: Colors.transparent,
            windowModel: common_window.WindowModel(),
            customTitleSize:
                CommonConstants.TITLE_XL * FontScaleUtils.fontSizeRatio,
            titleColor: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
            leftPadding: CommonConstants.SPACE_L,
            topPadding: CommonConstants.PADDING_S,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: CommonConstants.PADDING_PAGE,
            right: CommonConstants.PADDING_PAGE,
            top: CommonConstants.SPACE_M,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              loginCard(),
              const SizedBox(height: CommonConstants.SPACE_L),
              gridCard(),
              const SizedBox(height: CommonConstants.SPACE_L),
              listCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CommonConstants.PADDING_S),
      decoration: BoxDecoration(
        color: settingInfo.darkSwitch ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(CommonConstants.RADIUS_XL),
      ),
      child: InkWell(
        onTap: vm.userInfoModel.isLogin ? vm.jumpProfile : vm.jumpLogin,
        borderRadius: BorderRadius.circular(CommonConstants.RADIUS_XL),
        child: Padding(
          padding: const EdgeInsets.all(CommonConstants.PADDING_S),
          child: Row(
            children: [
              if (vm.userInfoModel.isLogin) ...[
                CircleAvatar(
                  backgroundImage: vm.userIcon.isNotEmpty
                      ? (vm.userIcon.startsWith('http')
                          ? NetworkImage(vm.userIcon)
                          : FileImage(File(vm.userIcon)))
                      : const AssetImage(Constants.icUserUnlogin)
                          as ImageProvider,
                  radius: 24,
                  onBackgroundImageError: (exception, stackTrace) {
                    return;
                  },
                ),
                const SizedBox(width: CommonConstants.SPACE_L),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vm.userInfoModel.authorNickName,
                        style: TextStyle(
                          fontSize: 18 * FontScaleUtils.fontSizeRatio,
                          color: ThemeColors.getFontPrimary(
                              settingInfo.darkSwitch),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: CommonConstants.SPACE_XXS),
                      Row(
                        children: [
                          Image.asset(
                            Constants.icPhone,
                            width: 16,
                            height: 16,
                            color: ThemeColors.getFontSecondary(
                                settingInfo.darkSwitch),
                          ),
                          const SizedBox(width: CommonConstants.SPACE_XS),
                          Expanded(
                            child: Text(
                              vm.userInfoModel.authorPhone,
                              style: TextStyle(
                                fontSize: 12 * FontScaleUtils.fontSizeRatio,
                                color: ThemeColors.getFontSecondary(
                                    settingInfo.darkSwitch),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Image.asset(
                  Constants.icUserUnlogin,
                  width: Constants.userUnloginIconSize,
                  height: Constants.userUnloginIconSize,
                ),
                const SizedBox(width: CommonConstants.SPACE_L),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '点击登录',
                        style: TextStyle(
                          fontSize: 18 * FontScaleUtils.fontSizeRatio,
                          color: ThemeColors.getFontPrimary(
                              settingInfo.darkSwitch),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: CommonConstants.SPACE_XXS),
                      const Text(
                        '登录后享受更多服务',
                        style: TextStyle(
                          fontSize: 12 * 1.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // 右侧箭头图标
              Padding(
                padding: const EdgeInsets.only(left: CommonConstants.SPACE_S),
                child: Image.asset(
                  Constants.icRightArrow,
                  width: Constants.arrowIconSize,
                  height: Constants.arrowIconSize,
                  color: ThemeColors.getArrowIcon(settingInfo.darkSwitch),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gridCard() {
    double dynamicHeight = 76 + (FontScaleUtils.fontSizeRatio - 1.0) * 40;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CommonConstants.RADIUS_XL),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(CommonConstants.PADDING_XS),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: dynamicHeight,
          mainAxisSpacing: CommonConstants.PADDING_L,
          crossAxisSpacing: CommonConstants.PADDING_L,
        ),
        itemCount: mineGridList.length,
        itemBuilder: (context, index) {
          final item = mineGridList[index];
          return InkWell(
            onTap: () => vm.gridClick(item),
            borderRadius: BorderRadius.circular(CommonConstants.RADIUS_M),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: CommonConstants.PADDING_M,
                horizontal: CommonConstants.PADDING_M,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 图标部分
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: CommonConstants.SPACE_XS),
                    child: Image.asset(
                      item.icon,
                      width: 36,
                      height: 36,
                    ),
                  ),
                  // 文字部分
                  Expanded(
                    child: Center(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14 * FontScaleUtils.fontSizeRatio,
                          color: ThemeColors.getFontPrimary(
                              settingInfo.darkSwitch),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        softWrap: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '常用服务',
          style: TextStyle(
            fontSize: 18 * 1.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: CommonConstants.PADDING_M),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(CommonConstants.RADIUS_XL),
          ),
          child: Column(
            children: [
              for (int i = 0; i < vm.serviceList.length; i++)
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        String routerName = vm.serviceList[i].routerName;
                        String label = vm.serviceList[i].label;
                        if (label == '意见反馈' && !vm.userInfoModel.isLogin) {
                          vm.jumpLogin(useHalfModal: true);
                          return;
                        }
                        RouterUtils.of.pushPathByName(routerName);
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.all(CommonConstants.PADDING_M),
                        child: Row(
                          children: [
                            Image.asset(
                              vm.serviceList[i].icon,
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: CommonConstants.SPACE_M),
                            Expanded(
                              child: Text(
                                vm.serviceList[i].label,
                                style: TextStyle(
                                  fontSize: 14 * FontScaleUtils.fontSizeRatio,
                                  color: ThemeColors.getFontPrimary(
                                      settingInfo.darkSwitch),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (i < vm.serviceList.length - 1)
                      Container(
                        height: 1,
                        color: settingInfo.darkSwitch
                            ? const Color(0xFF3A3A3A)
                            : Colors.grey.shade100,
                        margin: const EdgeInsets.only(left: 25, right: 25),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget minePageBuilder() {
  return const MinePage();
}
