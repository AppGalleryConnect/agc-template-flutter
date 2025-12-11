import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import '../constants/constants.dart';
import '../utils/font_scale_utils.dart';
import 'package:lib_common/models/window_model.dart';
import '../viewmodels/message_single_comment_vm.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import '../components/comment_root.dart';
import '../components/comment_sub.dart';
import 'package:lib_news_api/observedmodels/comment_model.dart'
    as observed_comment_model;
import 'package:lib_news_api/params/response/comment_response.dart';

class MsgSingleCommentList extends StatefulWidget {
  const MsgSingleCommentList({super.key});

  @override
  _MsgSingleCommentListState createState() => _MsgSingleCommentListState();
}

class _MsgSingleCommentListState extends State<MsgSingleCommentList> {
  final MsgSingleCommentListViewModel _vm = MsgSingleCommentListViewModel();
  final WindowModel windowModel = WindowModel();
  void _onViewModelUpdated() {
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    _vm.addListener(_onViewModelUpdated);
    _vm.init();
  }

  @override
  void dispose() {
    _vm.removeListener(_onViewModelUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          NavHeaderBar(
            title: '全部回复',
            onBack: () {
              _vm.onBackPressed();
            },
            windowModel: windowModel,
            customTitleSize:
                CommonConstants.TITLE_S * FontScaleUtils.fontSizeRatio,
          ),
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_vm.data == null) {
      return _buildEmptyState();
    }

    final rootComment = _vm.getRootComment();
    final currentComment = _vm.getCurrentComment();
    final leftList = _vm.getLeftList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: CommonConstants.PADDING_PAGE,
        right: CommonConstants.PADDING_PAGE,
        top: CommonConstants.SPACE_M,
        bottom: CommonConstants.SPACE_XL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rootComment != null)
            CommentRoot(
              data: rootComment,
              fontSizeRatio: _vm.fontSizeRatio,
              onReply: () => _vm.showCommentSheet(context, rootComment),
            ),
          const SizedBox(height: CommonConstants.SPACE_XXL),
          Container(
            height: 8,
            width: double.infinity,
            color: Colors.grey[100],
          ),
          const SizedBox(height: CommonConstants.SPACE_XXL),
          if (currentComment != null &&
              rootComment != null &&
              currentComment.commentId != rootComment.commentId)
            CommentSub(
              data: observed_comment_model.CommentModel(
                  CommentResponse.fromJson(currentComment.toJson())),
              bgColor: Colors.yellow[100]!,
              fontSizeRatio: _vm.fontSizeRatio,
              onReply: () => _vm.showCommentSheet(context, currentComment),
            ),

          if (_vm.showAllReply)
            Column(
              children: leftList.map((comment) {
                return CommentSub(
                  data: observed_comment_model.CommentModel(
                      CommentResponse.fromJson((comment).toJson())),
                  fontSizeRatio: _vm.fontSizeRatio,
                  onReply: () => _vm.showCommentSheet(context, comment),
                );
              }).toList(),
            ),

          // 我的即时回复
          if (_vm.showMyInstantReply)
            Column(
              children: _vm.publishList.map((comment) {
                return CommentSub(
                  data: observed_comment_model.CommentModel(
                      CommentResponse.fromJson((comment).toJson())),
                  bgColor: Colors.green[100]!,
                  fontSizeRatio: _vm.fontSizeRatio,
                  onReply: () => _vm.showCommentSheet(context, comment),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Constants.icEmptyContent,
            width: 120,
            height: 120,
          ),
          const SizedBox(height: CommonConstants.SPACE_M),
          Text(
            '暂无评论内容',
            style: TextStyle(
              fontSize: 14 * FontScaleUtils.fontSizeRatio,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// 页面构建器函数
Widget msgSingleCommentListBuilder(BuildContext context) {
  return const MsgSingleCommentList();
}
