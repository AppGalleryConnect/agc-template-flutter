import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:lib_common/models/window_model.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:lib_widget/components/custom_image.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';
import '../components/uniform_news_card.dart';
import '../viewmodels/comment_vm.dart';
import '../common/observed_model.dart';
import '../utils/content_navigation_utils.dart';
import '../constants/constants.dart' as MineConstants;
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late CommentViewModel _vm;
  late WindowModel _windowModel;

  @override
  void initState() {
    super.initState();
    _vm = CommentViewModel();
    _windowModel = WindowModel();
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
              title: '我的评论',
              showBackBtn: true,
              rightPartBuilder: (BuildContext context) => _rightPartBuilder(),
              windowModel: _windowModel,
              onBack: () {
                Navigator.pop(context);
              },
              backButtonBackgroundColor:
                  MineConstants.Constants.backgroundLightGrayColor,
              backButtonPressedBackgroundColor:
                  MineConstants.Constants.dividerColor,
              customTitleSize: MineConstants.Constants.textHeaderSize *
                  FontScaleUtils.fontSizeRatio,
            ),
            Expanded(
              child:
                  _vm.list.isNotEmpty ? _buildCommentList() : _buildEmptyView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentList() {
    return Consumer<CommentViewModel>(
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
          Text(
            '暂无评论内容',
            style: TextStyle(
              fontSize: MineConstants.Constants.textSecondarySize *
                  FontScaleUtils.fontSizeRatio,
              color: MineConstants.Constants.textMediumGrayColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rightPartBuilder() {
    return Consumer<CommentViewModel>(
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

  Widget _contentItemBuilder(AggregateNewsCommentModel v) {
    return Consumer<CommentViewModel>(
      builder: (context, vm, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: CommonConstants.SPACE_M),
          child: Row(
            children: [
              Visibility(
                visible: vm.isEditMode,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: CommonConstants.PADDING_NONE),
                  child: Checkbox(
                    value: vm.toDeleteList
                        .any((item) => item.commentId == v.commentId),
                    onChanged: (value) {
                      vm.onChange(value ?? false, v);
                    },
                    shape: const CircleBorder(),
                    checkColor: Colors.white,
                    activeColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _commentBuilder(v),
                    _referenceNewsBuilder(v),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _commentBuilder(AggregateNewsCommentModel v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomImage(
              imageUrl: v.author?.authorIcon ?? '',
              width: MineConstants.Constants.commentAvatarRadius * 2,
              height: MineConstants.Constants.commentAvatarRadius * 2,
              borderRadius: BorderRadius.circular(
                  MineConstants.Constants.commentAvatarRadius),
            ),
            const SizedBox(width: CommonConstants.SPACE_S),
            Text(
              v.author?.authorNickName ?? '',
              style: TextStyle(
                fontSize: MineConstants.Constants.textSecondarySize *
                    FontScaleUtils.fontSizeRatio,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: MineConstants.Constants.commentContentPaddingLeft),
          child: Text(
            v.commentBody,
            style: TextStyle(
              fontSize: MineConstants.Constants.buttonTextSize *
                  FontScaleUtils.fontSizeRatio,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: MineConstants.Constants.commentContentPaddingLeft),
          child: Row(
            children: [
              Text(
                TimeUtils.getDateDiff(v.createTime),
                style: TextStyle(
                  fontSize: MineConstants.Constants.textMinSize *
                      FontScaleUtils.fontSizeRatio,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(width: CommonConstants.SPACE_S),
              Text(
                '评论',
                style: TextStyle(
                  fontSize: MineConstants.Constants.textMinSize *
                      FontScaleUtils.fontSizeRatio,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _referenceNewsBuilder(AggregateNewsCommentModel v) {
    return Padding(
      padding: const EdgeInsets.only(
          left: MineConstants.Constants.commentContentPaddingLeft),
      child: GestureDetector(
        onTap: () {
          ContentNavigationUtils.navigateFromCommentToDetail(v.newsDetailInfo);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: MineConstants.Constants.backgroundLightGrayColor,
            borderRadius: BorderRadius.circular(
                MineConstants.Constants.newsCardBorderRadius),
          ),
          padding: const EdgeInsets.all(CommonConstants.PADDING_S),
          child: UniformNewsCard(
            newsInfo: v.newsDetailInfo,
            customStyle: UniformNewsStyle(
              bodyFg: MineConstants.Constants.buttonTextSize *
                  FontScaleUtils.fontSizeRatio,
              bodyFgColor: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            showAuthorInfoBottom: false,
            operateBuilder: () => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _toolBarBuilder() {
    return Consumer<CommentViewModel>(
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
