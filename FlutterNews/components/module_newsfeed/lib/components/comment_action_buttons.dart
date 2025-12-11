import 'package:business_video/views/video_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lib_news_api/database/comment_type.dart';
import 'package:lib_news_api/lib_news_api.dart';
import 'package:lib_account/viewmodels/login_vm.dart' as login_vm;
import '../utils/number_formatter.dart';
import 'package:module_newsfeed/constants/constants.dart';

class CommentActionButtons extends StatefulWidget {
  final VoidCallback? onScrollToComment;
  final VoidCallback? onLike;
  final VoidCallback? onShare;
  final bool showBottomButton;
  final NewsResponse? newsResponse;

  const CommentActionButtons({
    super.key,
    required this.onScrollToComment,
    required this.onLike,
    required this.onShare,
    this.showBottomButton = true,
    this.newsResponse,
  });

  @override
  State<CommentActionButtons> createState() => _CommentActionButtonsState();
}

class _CommentActionButtonsState extends State<CommentActionButtons> {
  bool _isMark = false;
  late List<BaseComment> comments = [];

  @override
  void initState() {
    super.initState();
    List<CommentResponse>? commentList =
        CommentServiceApi.queryCommentList(widget.newsResponse!.id);
    if (commentList != null) {
      setState(() {
        comments = commentList
            .map((response) => _convertToBaseComment(response))
            .toList();
      });
    }
  }

  BaseComment _convertToBaseComment(CommentResponse response) {
    return BaseComment(
      commentId: response.commentId,
      newsId: response.newsId,
      authorId: response.author?.authorId ?? '',
      commentBody: response.commentBody,
      commentLikeNum: response.commentLikeNum,
      createTime: response.createTime,
      isLiked: response.isLiked,
      replyComments: (response.replyComments as List<dynamic>?)?.map((item) {
            return item?.toString() ?? '';
          }).toList() ??
          [],
      parentCommentId: response.parentCommentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showBottomButton) ...[
          _buildActionItem(
              icon: Constants.messageActiveImage,
              count: CommentServiceApi.queryCommentList(widget.newsResponse!.id)
                      ?.toList()
                      .length ??
                  0,
              onTap: () {
                widget.onScrollToComment?.call();
              }),
          const SizedBox(width: Constants.SPACE_4),
        ],
        if (widget.showBottomButton) ...[
          _buildMarkActionItem(
            icon: widget.newsResponse!.isMarked == true
                ? Constants.starFillImage
                : Constants.starImage,
            count: widget.newsResponse?.markCount ?? 0,
            onTap: () {
              final loginVM = login_vm.LoginVM.getInstance();
              if (!loginVM.accountInstance.userInfoModel.isLogin) {
                VideoSheet.showLoginSheet(context);
                return;
              }

              _isMark = !widget.newsResponse!.isMarked;
              setState(() {
                if (_isMark) {
                  MineServiceApi.addMark(widget.newsResponse!.id);
                  widget.newsResponse!.isMarked = true;
                  widget.newsResponse!.markCount++;
                } else {
                  MineServiceApi.cancelMark(widget.newsResponse!.id);
                  widget.newsResponse!.isMarked = false;
                  widget.newsResponse!.markCount--;
                }
              });
            },
          ),
          const SizedBox(width: Constants.SPACE_4),
        ],
        if (widget.showBottomButton)
          _buildShareActionItem(
            count: widget.newsResponse?.shareCount ?? 0,
            onTap: () => widget.onShare?.call(),
          ),
      ],
    );
  }

  Widget _buildActionItem({
    required String icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: SizedBox(
        height: Constants.SPACE_40,
        child: Column(
          children: [
            icon.contains('png')
                ? Image.asset(
                    'packages/module_newsfeed/assets/$icon',
                    width: Constants.SPACE_20,
                    height: Constants.SPACE_20,
                  )
                : SvgPicture.asset(
                    'packages/module_newsfeed/assets/$icon',
                    width: Constants.SPACE_18,
                    height: Constants.SPACE_18,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                    fit: BoxFit.contain,
                  ),
            Text(count.toString()),
          ],
        ),
      ),
      onPressed: onTap,
    );
  }

  Widget _buildMarkActionItem({
    required String icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: SizedBox(
        height: Constants.SPACE_40,
        child: Column(
          children: [
            icon.contains('png')
                ? Image.asset(
                    'packages/module_newsfeed/assets/$icon',
                    width: Constants.SPACE_20,
                    height: Constants.SPACE_20,
                  )
                : SvgPicture.asset(
                    'packages/module_newsfeed/assets/$icon',
                    width: Constants.SPACE_18,
                    height: Constants.SPACE_18,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                    fit: BoxFit.contain,
                  ),
            Text(count < 0 ? '0' : count.toString()),
          ],
        ),
      ),
      onPressed: onTap,
    );
  }

  Widget _buildShareActionItem({
    required int count,
    required VoidCallback onTap,
  }) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: SizedBox(
        height: Constants.SPACE_40,
        child: Column(
          children: [
            SvgPicture.asset(
              Constants.opForwardImage,
              width: Constants.SPACE_18,
              height: Constants.SPACE_18,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
              fit: BoxFit.contain,
            ),
            Text(
              NumberFormatter.formatCompact(
                  widget.newsResponse?.shareCount ?? 0),
            ),
          ],
        ),
      ),
      onPressed: onTap,
    );
  }
}
