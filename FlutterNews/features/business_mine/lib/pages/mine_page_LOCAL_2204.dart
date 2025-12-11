import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:flutter/material.dart'; // 确保导入了material.dart

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  // 创建WindowModel实例（NavHeaderBar组件必需的参数）
  final WindowModel windowModel = WindowModel();

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
      body: Center(
        child: GestureDetector(
          onTap: () {
            RouterUtils.of.push(RouterMap.HOME_SECOND_PAGE);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: CommonConstants.SPACE_M, vertical: 6 // 此值没有直接对应的常量
                ),
            child: const Text('测试按钮'),
          ),
        ),
      ),
    );
  }
}
