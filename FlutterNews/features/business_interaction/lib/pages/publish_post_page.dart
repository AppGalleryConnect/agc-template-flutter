import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/lib_widget.dart';
import 'package:module_post/module_post.dart';
import '../viewmodels/publish_post_vm.dart';
import 'package:module_setfontsize/module_setfontsize.dart';
import '../constants/constants.dart' as InteractionConstants;

/// 发布帖子页面
class PublishPostPage extends StatefulWidget {
  const PublishPostPage({super.key});

  @override
  State<PublishPostPage> createState() => _PublishPostPageState();
}

class _PublishPostPageState extends BaseStatefulWidgetState<PublishPostPage> {
  final PublishPostViewModel vm = PublishPostViewModel();

  final WindowModel windowModel = WindowModel();

  @override
  void initState() {
    super.initState();
    vm.onKeyBoard();
    vm.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    vm.offKeyBoard();
    vm.removeListener(_onViewModelChanged);
    vm.dispose();
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          final customBack = vm.onBackPressed(context);
          if (!customBack) {
            RouterUtils.of.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor:
            ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
        body: Column(
          children: [
            NavHeaderBar(
              title: '',
              showBackBtn: true,
              bgColor:
                  ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
              titleColor: ThemeColors.getFontPrimary(
                  settingInfo.darkSwitch), 
              backButtonBackgroundColor: ThemeColors.getBackgroundTertiary(
                  settingInfo.darkSwitch),
              windowModel: windowModel,
              leftPadding: InteractionConstants.Constants.SPACE_16,
              rightPadding: InteractionConstants.Constants.SPACE_16,
              topPadding: statusBarHeight + InteractionConstants.Constants.SPACE_8,
              onBack: () {
                final customBack = vm.onBackPressed(context);
                if (!customBack) {
                  RouterUtils.of.pop();
                }
              },
              rightPartBuilder: (context) => barRight(),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: InteractionConstants.Constants.SPACE_16,
                  right: InteractionConstants.Constants.SPACE_16,
                  top: InteractionConstants.Constants.SPACE_12,
                  bottom: vm.paddingBottom,
                ),
                child: PublishPostComp(
                  fontRatio: vm.fontSizeRatio,
                  columnsNum: 3, 
                  imageParams: DEFAULT_IMAGE_PARAM,
                  videoParams: DEFAULT_VIDEO_PARAM,
                  isDark: settingInfo.darkSwitch,
                  onChange: (body, mediaList) {
                    vm.body = body;
                    vm.mediaList = mediaList;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建导航栏右侧区域
  Widget barRight() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: vm.enablePublish() ? () => vm.publishPost() : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(InteractionConstants.Constants.SPACE_72, InteractionConstants.Constants.SPACE_40),
            backgroundColor: ThemeColors.appTheme,
            foregroundColor: Colors.white, 
            disabledBackgroundColor: ThemeColors.getBackgroundTertiary(
                settingInfo.darkSwitch), 
            disabledForegroundColor: ThemeColors.getFontTertiary(
                settingInfo.darkSwitch), 
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(InteractionConstants.Constants.SPACE_20),
            ),
          ),
          child: Text(
            '发表',
            style: TextStyle(
              fontSize: InteractionConstants.Constants.FONT_16 * FontScaleUtils.fontSizeRatio, 
            ),
          ),
        ),
      ],
    );
  }
}
