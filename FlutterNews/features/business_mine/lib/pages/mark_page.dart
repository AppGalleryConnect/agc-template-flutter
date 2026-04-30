import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import '../components/base_mark_like_page.dart';
import '../viewmodels/mark_vm.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';

class MarkPage extends StatefulWidget {
  const MarkPage({super.key});

  @override
  _MarkPageState createState() => _MarkPageState();
}

class _MarkPageState extends State<MarkPage> {
  final MarkViewModel _vm = MarkViewModel();
  late WindowModel _windowModel;

  @override
  void initState() {
    super.initState();
    _windowModel = WindowModel();
  }

  @override
  Widget build(BuildContext context) {
    final settingInfo = SettingModel.getInstance();
    return Scaffold(
      backgroundColor: ThemeColors.getBackgroundColor(settingInfo.darkSwitch),
      body: Column(
        children: [
          NavHeaderBar(
            title: '我的收藏',
            windowModel: _windowModel,
            titleColor: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
            bgColor: ThemeColors.getBackgroundColor(settingInfo.darkSwitch),
            backButtonBackgroundColor:
                ThemeColors.getCompBackgroundSecondary(settingInfo.darkSwitch),
            backButtonPressedBackgroundColor:
                ThemeColors.getCompBackgroundSecondary(settingInfo.darkSwitch),
            customTitleSize: 20 * FontScaleUtils.fontSizeRatio,
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: BaseMarkLikePage(
              vm: _vm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget markPageBuilder(BuildContext context) {
  return const MarkPage();
}
