
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/models/window_model.dart' as commonWindow;
import 'package:business_mine/viewmodels/mine_vm.dart';
import 'package:business_mine/constants/constants.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final commonWindow.WindowModel windowModel = commonWindow.WindowModel();
  final MineViewModel vm = MineViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(CommonConstants.COLOR_PAGE_BACKGROUND),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(CommonConstants.NAV_HEADER_HEIGHT),
        child: Container(
          padding: EdgeInsets.only(top: windowModel.windowTopPadding),
          color: const Color(CommonConstants.COLOR_PAGE_BACKGROUND),
          child: NavHeaderBar(
            title: '我的',
            showBackBtn: false,
            isSubTitle: false,
            bgColor: Colors.transparent,
            windowModel: windowModel,
            customTitleSize: CommonConstants.TITLE_XL,
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
        color: Colors.white,
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
                  backgroundImage: AssetImage(vm.userIcon),
                  radius: 24,
                ),
                const SizedBox(width: CommonConstants.SPACE_L),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vm.userInfoModel.authorNickName,
                        style: const TextStyle(
                          fontSize: 18 * 1.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: CommonConstants.SPACE_XXS),
                      Row(
                        children: [
                          Image.asset(
                            'assets/ic_phone.png',
                            width: 16,
                            height: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: CommonConstants.SPACE_XS),
                          Text(
                            vm.userInfoModel.authorPhone,
                            style: const TextStyle(
                              fontSize: 12 * 1.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Image.asset(
                  'packages/business_mine/assets/ic_user_unlogin.svg',
                  width: Constants.userUnloginIconSize,
                  height: Constants.userUnloginIconSize,
                ),
                const SizedBox(width: CommonConstants.SPACE_L),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '点击登录',
                        style: TextStyle(
                          fontSize: 18 * 1.0, // 修改为固定值1.0
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: CommonConstants.SPACE_XXS),
                      Text(
                        '登录后享受更多服务',
                        style: TextStyle(
                          fontSize: 12 * 1.0, // 修改为固定值1.0
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Image.asset(
                'packages/lib_common/assets/ic_right.svg',
                width: Constants.arrowIconSize,
                height: Constants.arrowIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gridCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CommonConstants.PADDING_XS),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CommonConstants.RADIUS_XL),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
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
                vertical: CommonConstants.PADDING_S,
                horizontal: CommonConstants.PADDING_M,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    item.icon,
                    width: 36,
                    height: 36,
                  ),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 12 * 1.0, // 修改为固定值1.0
                      color: Colors.black,
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
        // 简单实现SettingCard组件
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
                      onTap: () => RouterUtils.of
                          .pushPathByName(vm.serviceList[i].routerName),
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
                                style: const TextStyle(
                                  fontSize: 16 * 1.0,
                                  color: Colors.black,
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
                        color: Colors.grey.shade100,
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

