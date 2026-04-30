import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_news_api/observedmodels/news_model.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../components/uniform_news_card.dart';
import '../viewmodels/history_vm.dart';
import 'package:lib_common/models/window_model.dart' as common;
import 'package:provider/provider.dart';
import '../utils/content_navigation_utils.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';
import '../constants/constants.dart' as MineConstants;


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late HistoryViewModel _vm;
  late common.WindowModel _windowModel;
  final settingInfo = SettingModel.getInstance();

  @override
  void initState() {
    super.initState();
    _vm = HistoryViewModel();
    _windowModel = common.WindowModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Scaffold(
        backgroundColor: ThemeColors.getBackgroundColor(settingInfo.darkSwitch),
        body: Column(
          children: [
            NavHeaderBar(
              title: '历史',
              showBackBtn: true,
              rightPartBuilder: (BuildContext context) => _rightPartBuilder(),
              windowModel: _windowModel,
              titleColor: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
              onBack: () {
                Navigator.pop(context);
              },
              backButtonBackgroundColor: ThemeColors.getCompBackgroundSecondary(
                  settingInfo.darkSwitch),
              backButtonPressedBackgroundColor:
                  ThemeColors.getCompBackgroundSecondary(
                      settingInfo.darkSwitch),
              customTitleSize: MineConstants.Constants.textHeaderSize *
                  FontScaleUtils.fontSizeRatio,
            ),
            Expanded(
              child:
                  _vm.list.isNotEmpty ? _buildHistoryList() : _buildEmptyView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return Consumer<HistoryViewModel>(
      builder: (context, vm, child) {
        return Obx(() {
          final breakpointCtrl = Get.find<BreakpointController>();
          final currentLanes = breakpointCtrl.lanes.value;

        return Column(
          children: [
            Expanded(
                child: MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: currentLanes,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  itemCount: vm.list.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: CommonConstants.PADDING_PAGE,
                  vertical: CommonConstants.SPACE_M,
                  ),
                itemBuilder: (context, index) {
                  final item = vm.list[index];
                  return _contentItemBuilder(item);
                  },
              ),
            ),
            if (vm.isEditMode) _toolBarBuilder(),
          ],
        );
        });
      },
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            MineConstants.Constants.icEmptyContent,
            width: MineConstants.Constants.commentEmptyIconSize,
            height: MineConstants.Constants.commentEmptyIconSize,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无历史记录',
            style: TextStyle(
              fontSize: MineConstants.Constants.textSecondarySize,
              color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
            ),
          ),
        ],
      ),
    );
  }

  // 右侧操作按钮
  Widget _rightPartBuilder() {
    return Consumer<HistoryViewModel>(
      builder: (context, vm, child) {
        return Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: CommonConstants.PADDING_M),
            child: GestureDetector(
              onTap: () {
                if (vm.isEditMode) {
                  vm.quitEdit();
                } else {
                  vm.enterEdit();
                }
              },
              child: Image.asset(
                vm.isEditMode
                    ? MineConstants.Constants.icClose
                    : MineConstants.Constants.icPublicTrash,
                width: MineConstants.Constants.commentIconSize,
                height: MineConstants.Constants.commentIconSize,
                color: vm.allowEnterEdit
                    ? Theme.of(context).textTheme.bodyLarge?.color
                    : Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
        );
      },
    );
  }

// 历史记录项
  Widget _contentItemBuilder(NewsModel item) {
    return Consumer<HistoryViewModel>(
      builder: (context, vm, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: CommonConstants.SPACE_M),
          child: Row(
            children: [
              Visibility(
                visible: vm.isEditMode,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: CommonConstants.PADDING_XS),
                  child: Checkbox(
                    value: vm.selectedIds.contains(item.id),
                    onChanged: (value) {
                      vm.onChange(value ?? false, item);
                    },
                    shape: const CircleBorder(),
                    checkColor: Colors.white,
                    activeColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              Expanded(
                child: _buildContentItem(item),
              ),
            ],
          ),
        );
      },
    );
  }

// 内容项
  Widget _buildContentItem(NewsModel v) {
    return GestureDetector(
      onTap: () {
        // 使用导航工具类跳转到内容详情
        ContentNavigationUtils.navigateToContentDetail(v);
      },
      child: UniformNewsCard(
        newsInfo: v,
        showAuthorInfoTop: true,
        showAuthorInfoBottom: false,
        customStyle: UniformNewsStyle(
          bodyFg: 16 * _vm.settingInfo.fontSizeRatio,
        ),
        operateBuilder: () => const SizedBox.shrink(),
      ),
    );
  }

  Widget _toolBarBuilder() {
    return Consumer<HistoryViewModel>(
      builder: (context, vm, child) {
        return Container(
          padding: EdgeInsets.only(bottom: _windowModel.windowBottomPadding),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    vm.deleteAllConfirm(context);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        MineConstants.Constants.icPublicEraser,
                        width: MineConstants.Constants.commentToolIconSize,
                        height: MineConstants.Constants.commentToolIconSize,
                        color:
                            ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                      ),
                      Text(
                        '一键清空',
                        style: TextStyle(
                          fontSize: MineConstants.Constants.textMinSize *
                              FontScaleUtils.fontSizeRatio,
                          color: ThemeColors.getFontPrimary(
                              settingInfo.darkSwitch),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap:
                      vm.allowDelete ? () => vm.deleteConfirm(context) : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        MineConstants.Constants.icPublicDelete,
                        width: MineConstants.Constants.commentToolIconSize,
                        height: MineConstants.Constants.commentToolIconSize,
                        color: vm.allowDelete
                            ? ThemeColors.getFontPrimary(settingInfo.darkSwitch)
                            : ThemeColors.getFontSecondary(
                                settingInfo.darkSwitch),
                      ),
                      Text(
                        '删除',
                        style: TextStyle(
                          fontSize: MineConstants.Constants.textMinSize *
                              FontScaleUtils.fontSizeRatio,
                          color: vm.allowDelete
                              ? ThemeColors.getFontPrimary(
                                  settingInfo.darkSwitch)
                              : ThemeColors.getFontSecondary(
                                  settingInfo.darkSwitch),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
