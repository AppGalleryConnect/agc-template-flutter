import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_news_api/observedmodels/news_model.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
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
        backgroundColor: Colors.white,
        body: Column(
          children: [
            NavHeaderBar(
              title: '历史',
              showBackBtn: true,
              rightPartBuilder: (BuildContext context) => _rightPartBuilder(),
              windowModel: _windowModel,
              onBack: () {
                Navigator.pop(context);
              },
              backButtonBackgroundColor:
                  MineConstants.Constants.messageItemIconBgColor,
              backButtonPressedBackgroundColor:
                  MineConstants.Constants.dividerColor,
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
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: CommonConstants.PADDING_PAGE,
                  vertical: CommonConstants.SPACE_M,
                ),
                itemCount: vm.list.length,
                itemBuilder: (context, index) {
                  final item = vm.list[index];
                  return _contentItemBuilder(item);
                },
                physics: const BouncingScrollPhysics(),
              ),
            ),
            if (vm.isEditMode) _toolBarBuilder(),
          ],
        );
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
          const Text(
            '暂无历史记录',
            style: TextStyle(
              fontSize: MineConstants.Constants.textSecondarySize,
              color: MineConstants.Constants.textMediumGrayColor,
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
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      Text(
                        '一键清空',
                        style: TextStyle(
                          fontSize: MineConstants.Constants.textMinSize *
                              FontScaleUtils.fontSizeRatio,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
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
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      Text(
                        '删除',
                        style: TextStyle(
                          fontSize: MineConstants.Constants.textMinSize *
                              FontScaleUtils.fontSizeRatio,
                          color: vm.allowDelete
                              ? Theme.of(context).textTheme.bodyLarge?.color
                              : Theme.of(context).textTheme.bodySmall?.color,
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
