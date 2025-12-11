import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:lib_common/models/window_model.dart';
import 'package:lib_news_api/services/message_service.dart';
import '../common/observed_model.dart';
import '../viewmodels/message_comment_vm.dart';
import '../components/uniform_news_card.dart';
import '../utils/content_navigation_utils.dart';
import '../utils/font_scale_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/constants/router_map.dart';
import '../constants/constants.dart' as MineConstants;

class MsgCommentReplyPage extends StatefulWidget {
  const MsgCommentReplyPage({super.key});

  @override
  State<MsgCommentReplyPage> createState() => _MsgCommentReplyPageState();
}

class _MsgCommentReplyPageState extends State<MsgCommentReplyPage> {
  final WindowModel windowModel = WindowModel();

  @override
  void initState() {
    super.initState();
    messageServiceApi.setReplyRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MineConstants.Constants.newsCardWhiteColor,
      body: ChangeNotifierProvider(
        create: (context) => MsgCommentViewModel(),
        child: Consumer<MsgCommentViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                NavHeaderBar(
                  title: '评论与回复',
                  showBackBtn: true,
                  windowModel: windowModel,
                  onBack: () {
                    viewModel.onBackPressed();
                  },
                  backButtonBackgroundColor:
                      MineConstants.Constants.messageItemIconBgColor,
                  backButtonPressedBackgroundColor:
                      MineConstants.Constants.dividerColor,
                  customTitleSize: MineConstants.Constants.textHeaderSize *
                      FontScaleUtils.fontSizeRatio,
                ),
                Expanded(
                  child: _buildCommentList(context, viewModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCommentList(
      BuildContext context, MsgCommentViewModel viewModel) {
    return RefreshIndicator(
      onRefresh: () => viewModel.onRefresh(),
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: CommonConstants.PADDING_PAGE,
          right: CommonConstants.PADDING_PAGE,
          top: CommonConstants.SPACE_S,
          bottom: windowModel.windowBottomPadding,
        ),
        itemCount: viewModel.list.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: CommonConstants.SPACE_L,
        ),
        itemBuilder: (context, index) {
          final item = viewModel.list[index];
          return _buildCommentItem(
            context,
            viewModel,
            item,
          );
        },
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, MsgCommentViewModel viewModel,
      AggregateNewsCommentModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopUserInfo(
          viewModel,
          item,
        ),
        _buildMiddleComment(
          viewModel,
          item,
        ),
        _buildReferenceNews(
          item,
        ),
        _buildReplyButton(
          context,
          viewModel,
          item,
        ),
      ],
    );
  }

  Widget _buildTopUserInfo(
      MsgCommentViewModel viewModel, AggregateNewsCommentModel item) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            String? authorId = item.author?.authorId;
            if (authorId != null && authorId.isNotEmpty) {
              RouterUtils.of
                  .pushPathByName(RouterMap.PROFILE_HOME, param: authorId);
            } else {
              // 跳转到作者主页
            }
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              item.author?.authorIcon ?? '',
            ),
            radius: MineConstants.Constants.commentAvatarRadius,
          ),
        ),
        const SizedBox(
          width: CommonConstants.SPACE_XS,
        ),
        Text(
          item.author?.authorNickName ?? '',
          style: TextStyle(
            fontSize: MineConstants.Constants.textSecondarySize *
                FontScaleUtils.fontSizeRatio,
            color: const Color(CommonConstants.COLOR_FONT_SECONDARY),
          ),
        ),
        const Spacer(),
        Text(
          TimeUtils.handleMsgTimeDiff(item.createTime),
          style: TextStyle(
            fontSize: MineConstants.Constants.textSecondarySize *
                FontScaleUtils.fontSizeRatio,
            color: const Color(CommonConstants.COLOR_FONT_SECONDARY),
          ),
        ),
      ],
    );
  }

  Widget _buildMiddleComment(
      MsgCommentViewModel viewModel, AggregateNewsCommentModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 评论/回复内容 - 添加点击事件跳转到全部回复页面
        GestureDetector(
          onTap: () {
            viewModel.jumpMoreComment(item.commentId);
          },
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: viewModel.isReply(item) ? '回复你: ' : '评论你: ',
                  style: TextStyle(
                    fontSize: MineConstants.Constants.textPrimarySize *
                        FontScaleUtils.fontSizeRatio,
                  ),
                ),
                TextSpan(
                  text: item.commentBody,
                  style: TextStyle(
                    fontSize: MineConstants.Constants.textPrimarySize *
                        FontScaleUtils.fontSizeRatio,
                  ),
                ),
              ],
            ),
            // 确保文本可以换行
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),

        // 回复的评论引用
        if (item.parentComment != null &&
            item.parentComment!.commentBody.isNotEmpty)
          Text(
            item.parentComment!.commentBody,
            style: TextStyle(
              fontSize: MineConstants.Constants.textSecondarySize *
                  FontScaleUtils.fontSizeRatio,
              color: const Color(CommonConstants.COLOR_FONT_SECONDARY),
            ),
            // 确保文本可以换行
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
      ],
    );
  }

  Widget _buildReferenceNews(AggregateNewsCommentModel item) {
    return GestureDetector(
      onTap: () {
        // 使用ContentNavigationUtils中的方法跳转到新闻详情页
        ContentNavigationUtils.navigateFromMessageToDetail(item.newsDetailInfo);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: MineConstants.Constants.backgroundLightGrayColor,
          borderRadius: BorderRadius.circular(
              MineConstants.Constants.newsCardBorderRadius / 2),
        ),
        padding: const EdgeInsets.all(CommonConstants.PADDING_S),
        child: UniformNewsCard(
          newsInfo: item.newsDetailInfo,
          customStyle: UniformNewsStyle(
            bodyFg: MineConstants.Constants.textSecondarySize *
                FontScaleUtils.fontSizeRatio,
            bodyFgColor: const Color(CommonConstants.COLOR_FONT_SECONDARY),
            imgRatio: 2, // 可以在Constants中添加对应的常量，这里暂时保持不变
          ),
          showAuthorInfoBottom: false,
          operateBuilder: () => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildReplyButton(BuildContext context, MsgCommentViewModel viewModel,
      AggregateNewsCommentModel item) {
    return GestureDetector(
      onTap: () {
        viewModel.replyComment(context, item);
      },
      child: Text('回复',
          style: TextStyle(
            fontSize: MineConstants.Constants.textSecondarySize *
                FontScaleUtils.fontSizeRatio,
            color: const Color(CommonConstants.COLOR_FONT_SECONDARY),
          )),
    );
  }
}

/// 页面构建器函数
dynamic msgCommentReplyPageBuilder() {
  return const MsgCommentReplyPage();
}
