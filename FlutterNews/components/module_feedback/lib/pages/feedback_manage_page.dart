import 'package:lib_common/models/setting_model.dart';
import 'package:lib_common/utils/theme_colors.dart';

import '../components/nav_header_bar.dart';
import '../common/constants.dart';
import '../components/setting_list.dart';
import 'package:flutter/material.dart';

Widget feedbackManagePageBuilder() {
  return const FeedbackManagePage();
}

class FeedbackManagePage extends StatefulWidget {
  const FeedbackManagePage({super.key});

  @override
  State<FeedbackManagePage> createState() => _FeedbackManagePageState();
}

class _FeedbackManagePageState extends State<FeedbackManagePage> {
  final settingInfo = SettingModel.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
      body: Column(
        children: [
          // 导航头部栏
         const NavHeaderBar(
            title: '意见反馈',
            hasBgColor: true,
            showBackBtn: true,
          ),

          // 内容区域
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.SPACE_0,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingList(
                    list: LIST_INFO,
                    onItemTap: _handleItemTap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleItemTap(RouterMap routerName) {
    switch (routerName) {
      case RouterMap.FEEDBACK_SUBMIT_PAGE:
        Navigator.pushNamed(context, '/feedback/submit');
        break;
      case RouterMap.FEEDBACK_RECORD_LIST_PAGE:
        Navigator.pushNamed(context, '/feedback_record_list');
        break;
      case RouterMap.FEEDBACK_MANAGE_PAGE:
      default:
        break;
    }
  }
}
