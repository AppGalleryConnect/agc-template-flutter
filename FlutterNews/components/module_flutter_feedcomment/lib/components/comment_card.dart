import 'package:flutter/material.dart';
import '../utils/common_confirm_dialog.dart';
import '../model/model.dart';
import '../utils/event_dispatcher.dart';
import '../utils/utils.dart';
import '../viewModel/feed_comment_vm.dart';
import 'package:intl/intl.dart';
import 'package:module_flutter_feedcomment/constants/constants.dart';
import 'total_comment.dart';
import 'press_action.dart';

class CommentCard extends StatefulWidget {
  final CommentInfo commentInfo;
  final CommentInfo articleInfo;
  final bool isDark;
  final WidgetBuilder replyComponentBuilder;
  final WidgetBuilder totalCommentBuilder;
  final bool isNeedReply;

  const CommentCard({
    super.key,
    required this.commentInfo,
    required this.articleInfo,
    required this.isDark,
    required this.replyComponentBuilder,
    required this.totalCommentBuilder,
    required this.isNeedReply,
  });

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final FeedCommentVM feedCommentVM = FeedCommentVM.instance;
  int customDialogComponentId = 0;

  bool get isReplyShow {
    return widget.commentInfo.parentComment?.author.authorNickName != null &&
        widget.isNeedReply &&
        widget.commentInfo.parentComment!.author.authorNickName !=
            widget.commentInfo.author.authorNickName;
  }

  void pressReply() {
    Navigator.of(context).pop();
    commentSheetOpen(
      context,
      widget.commentInfo.author.authorNickName,
      (String replyContent) {
        feedCommentVM.addComment(widget.commentInfo, replyContent);
      },
    );
  }

  void pressDelete() {
    Navigator.of(context).pop();
    CommonConfirmDialog.show(
        context,
        IConfirmDialogParams(
          content: '是否删除此评论',
          priBtnV: '取消',
          secBtnV: '删除',
          secBtnFg: Colors.red,
          confirm: () {
            feedCommentVM.deleteComment(widget.commentInfo.commentId);
          },
        ),
        feedCommentVM.isDark);
  }

  void pressCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    CommentEventDispatcher.dispatchToUserHome(
                        widget.commentInfo.author.authorId);
                  },
                  child: CircleAvatar(
                    radius: Constants.SPACE_16,
                    backgroundImage:
                        widget.commentInfo.author.authorIcon.isNotEmpty
                            ? NetworkImage(widget.commentInfo.author.authorIcon)
                            : const AssetImage(Constants.iconDefaultImage)
                                as ImageProvider,
                  ),
                ),
                const SizedBox(width: Constants.SPACE_8),
                Text(
                  widget.commentInfo.author.authorNickName,
                  style: TextStyle(
                    color: feedCommentVM.isDark
                        ? Colors.grey[50]
                        : Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: Constants.FONT_12 * feedCommentVM.fontSizeRatio,
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Constants.SPACE_40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isReplyShow)
                        GestureDetector(
                          onTap: () {
                            final authorId = widget
                                .commentInfo.parentComment!.author.authorId;
                            CommentEventDispatcher.dispatchToUserHome(authorId);
                          },
                          child: Text.rich(
                            TextSpan(
                              text: '回复',
                              style: TextStyle(
                                color: feedCommentVM.isDark
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '@${widget.commentInfo.parentComment!.author.authorNickName}:',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                            style: TextStyle(
                                fontSize: Constants.FONT_14 *
                                    feedCommentVM.fontSizeRatio),
                          ),
                        ),
                      GestureDetector(
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).padding.bottom,
                                ),
                                child: confirmDialogView(
                                    context,
                                    BuilderParamsImpl(
                                        cancel: pressCancel,
                                        delete: pressDelete,
                                        reply: pressReply,
                                        isCommentOwner: widget
                                                .commentInfo.author.authorId ==
                                            feedCommentVM.author.authorId,
                                        fontSizeRatio:
                                            feedCommentVM.fontSizeRatio)),
                              );
                            },
                            isScrollControlled: true,
                          );
                        },
                        child: Text(
                          widget.commentInfo.commentBody,
                          style: TextStyle(
                            color: feedCommentVM.isDark
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize:
                                Constants.FONT_14 * feedCommentVM.fontSizeRatio,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Constants.SPACE_9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    widget.commentInfo.createTime)),
                            style: TextStyle(
                              fontSize: Constants.FONT_10 *
                                  feedCommentVM.fontSizeRatio,
                              color: feedCommentVM.isDark
                                  ? Colors.grey[50]
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                            ),
                          ),
                          const SizedBox(
                            width: Constants.SPACE_10,
                          ),
                          GestureDetector(
                            onTap: () {
                              commentSheetOpen(
                                context,
                                widget.commentInfo.author.authorNickName,
                                (String replyContent) {
                                  feedCommentVM.addComment(
                                      widget.commentInfo, replyContent);
                                },
                              );
                            },
                            child: Text(
                              '回复',
                              style: TextStyle(
                                fontSize: Constants.FONT_10 *
                                    feedCommentVM.fontSizeRatio,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          feedCommentVM.giveLike(
                              widget.commentInfo, !widget.commentInfo.isLiked);
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              widget.commentInfo.isLiked
                                  ? Constants.giveLikeActiveImage
                                  : feedCommentVM.isDark
                                      ? Constants.giveLikeDarkImage
                                      : Constants.giveLikeImage,
                              width: Constants.SPACE_16,
                              height: Constants.SPACE_14,
                            ),
                            const SizedBox(width: Constants.SPACE_5),
                            Text(
                              '${widget.commentInfo.commentLikeNum}',
                              style: TextStyle(
                                fontSize: Constants.FONT_10 *
                                    feedCommentVM.fontSizeRatio,
                                color: feedCommentVM.isDark
                                    ? Colors.grey[50]
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Constants.SPACE_10,
                  ),
                  if (widget.commentInfo.replyComments.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        feedCommentVM.commentDetailInfo = widget.commentInfo;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TotalComment(),
                          ),
                        );
                      },
                      child: widget.replyComponentBuilder(context),
                    ),
                  if (widget.commentInfo.replyComments.isNotEmpty)
                    const SizedBox(
                      height: Constants.SPACE_10,
                    ),
                ],
              ),
            ),
          ],
        ),
        if (widget.commentInfo.replyComments.isNotEmpty)
          widget.totalCommentBuilder(context),
      ],
    );
  }
}
