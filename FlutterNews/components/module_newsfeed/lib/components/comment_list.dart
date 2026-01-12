import 'dart:io';
import 'package:business_video/views/video_sheet.dart';
import 'package:lib_account/viewmodels/login_vm.dart' as login_vm;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_news_api/lib_news_api.dart';
import 'package:module_share/utils/event_dispatcher.dart';
import 'comment_detail_list.dart';
import 'delete_commentDialog.dart';
import 'package:module_newsfeed/constants/constants.dart';

typedef OnDirectComment = void Function();
typedef OnReplyToComment = void Function({
  required CommentResponse targetComment,
  CommentResponse? targetReply,
});
typedef OnCommentLike = void Function(String commentId, bool isLiked);
typedef OnReplyLike = void Function(String replyId, bool isLiked);
typedef OnPullUpKeyboard = void Function();

class CommentList extends StatefulWidget {
  final List<CommentResponse> commentResponse;
  final bool? showInteractiveButtons;
  final int? commentCount;
  final OnDirectComment? onDirectComment;
  final OnReplyToComment? onReplyToComment;
  final OnCommentLike? onCommentLike;
  final OnReplyLike? onReplyLike;
  final OnPullUpKeyboard? onPullUpKeyboard;
  final NewsResponse? cardData;
  final double? fontSizeRatio;

  const CommentList({
    super.key,
    required this.commentResponse,
    this.showInteractiveButtons,
    this.commentCount,
    this.onDirectComment,
    this.onReplyToComment,
    this.onCommentLike,
    this.onReplyLike,
    this.onPullUpKeyboard,
    this.cardData,
    this.fontSizeRatio = 1.0,
  });

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  List<CommentResponse> get _mainComments {
    final allMainComments = widget.commentResponse
        .where((comment) =>
            comment.parentCommentId == null || comment.parentCommentId!.isEmpty)
        .toList();

    if (allMainComments.isNotEmpty) {
      final lastComment = allMainComments.removeLast();
      allMainComments.insert(0, lastComment);
    }

    final recentThreshold =
        DateTime.now().millisecondsSinceEpoch - 5 * 60 * 1000;
    final newComments = allMainComments
        .where((c) => c.createTime >= recentThreshold)
        .toList()
      ..sort((a, b) => b.createTime.compareTo(a.createTime));

    final oldComments = allMainComments
        .where((c) => c.createTime < recentThreshold)
        .toList()
      ..sort((a, b) => b.createTime.compareTo(a.createTime));

    return [...newComments, ...oldComments];
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  bool _isCurrentUser(CommentResponse comment) {
    final loginVM = login_vm.LoginVM.getInstance();
    if (!loginVM.accountInstance.userInfoModel.isLogin) return false;
    return comment.author?.authorId ==
        loginVM.accountInstance.userInfoModel.authorId;
  }

  @override
  void initState() {
    super.initState();
    EventBusUtils.instance.on<NewLikeEvent>().listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.SPACE_16, vertical: Constants.SPACE_12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showInteractiveButtons != null &&
              widget.showInteractiveButtons == false)
            Text(
              '评论(${widget.commentCount != null && widget.commentCount! > 0 ? widget.commentCount : _mainComments.length}条)',
              style: TextStyle(
                fontSize: Constants.FONT_16 * (widget.fontSizeRatio ?? 1.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          if (widget.showInteractiveButtons != null &&
              widget.showInteractiveButtons == false)
            const SizedBox(height: Constants.SPACE_10),
          if (_mainComments.isEmpty)
            const SizedBox(height: Constants.SPACE_160),
          _mainComments.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: Constants.SPACE_16),
                  itemCount: _mainComments.length,
                  itemBuilder: (context, index) {
                    final comment = _mainComments[index];
                    final replies = comment.replyComments
                      ..sort((a, b) => b.createTime.compareTo(a.createTime));

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Constants.SPACE_1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCommentItem(comment),
                          const SizedBox(height: Constants.SPACE_1),
                          if (replies.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: Constants.SPACE_24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: Constants.SPACE_6),
                                  ..._buildAggregatedReplies(comment, replies)
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    children: [
                      Text(
                        '暂无评论内容，点击抢首评',
                        style: TextStyle(
                          fontSize:
                              Constants.FONT_14 * (widget.fontSizeRatio ?? 1.0),
                          color: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue),
                          ),
                          onPressed: () {
                            final loginVM = login_vm.LoginVM.getInstance();
                            if (!loginVM
                                .accountInstance.userInfoModel.isLogin) {
                              VideoSheet.showLoginSheet(context);
                              return;
                            }
                            widget.onPullUpKeyboard?.call();
                          },
                          child: Text(
                            "写评论",
                            style: TextStyle(
                                fontSize: Constants.FONT_13 *
                                    (widget.fontSizeRatio ?? 1.0),
                                color: Colors.white),
                          ))
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentResponse comment) {
    final AuthorResponse? author = comment.author;
    final String authorName = author?.authorNickName ?? "未知作者";
    final String authorAvatar = author?.authorIcon ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: Constants.SPACE_8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Constants.SPACE_4),
              Row(
                children: [
                  SizedBox(
                    height: Constants.SPACE_24,
                    width: Constants.SPACE_25,
                    child: CircleAvatar(
                      radius: Constants.SPACE_20,
                      backgroundImage: authorAvatar.isNotEmpty
                          ? (authorAvatar.startsWith('http')
                              ? NetworkImage(authorAvatar)
                              : FileImage(File(authorAvatar)))
                          : const AssetImage(Constants.icUserUnloginImage)
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(width: Constants.SPACE_8),
                  Text(
                    authorName,
                    style: TextStyle(
                      fontSize:
                          Constants.FONT_14 * (widget.fontSizeRatio ?? 1.0),
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // 一级评论内容点击（回复一级评论：targetReply = null）
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _handleReply(comment, targetReply: null),
                onLongPress: () => _handleCommentLongPress(comment),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(33.0, 4.0, 20.0, 4.0),
                  child: Text(
                    comment.commentBody,
                    style: TextStyle(
                        fontSize:
                            Constants.FONT_14 * (widget.fontSizeRatio ?? 1.0)),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              // 一级评论操作栏（修复回复按钮参数）
              Padding(
                padding: const EdgeInsets.only(left: Constants.SPACE_33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _formatTime(comment.createTime),
                      style: const TextStyle(
                          fontSize: Constants.FONT_12, color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () => _handleReply(comment, targetReply: null),
                      child: Text(
                        '回复',
                        style: TextStyle(
                          fontSize:
                              Constants.FONT_12 * (widget.fontSizeRatio ?? 1.0),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => _handleLike(comment),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(
                                  Constants.SPACE_24, Constants.SPACE_24)),
                          child: SvgPicture.asset(
                            comment.isLiked
                                ? Constants.giveLikeActiveImage
                                : Constants.giveLikeImage,
                            width: Constants.SPACE_16,
                            height: Constants.SPACE_16,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          comment.commentLikeNum.toString(),
                          style: TextStyle(
                              fontSize: Constants.FONT_12 *
                                  (widget.fontSizeRatio ?? 1.0)),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _handleReply(CommentResponse targetComment,
      {CommentResponse? targetReply}) {
    final loginVM = login_vm.LoginVM.getInstance();
    if (!loginVM.accountInstance.userInfoModel.isLogin) {
      VideoSheet.showLoginSheet(context);
      return;
    }
    widget.onReplyToComment?.call(
      targetComment: targetComment,
      targetReply: targetReply ?? targetComment,
    );
  }

  void _handleLike(CommentResponse comment) {
    final loginVM = login_vm.LoginVM.getInstance();
    if (!loginVM.accountInstance.userInfoModel.isLogin) {
      VideoSheet.showLoginSheet(context);
      return;
    }
    setState(() {
      comment.isLiked = !comment.isLiked;
      widget.onCommentLike?.call(comment.commentId, comment.isLiked);
      comment.commentLikeNum = comment.isLiked
          ? comment.commentLikeNum + 1
          : (comment.commentLikeNum > 0 ? comment.commentLikeNum - 1 : 0);
    });
  }

  void _handleCommentLongPress(CommentResponse comment) {
    final loginVM = login_vm.LoginVM.getInstance();
    if (!loginVM.accountInstance.userInfoModel.isLogin) {
      VideoSheet.showLoginSheet(context);
      return;
    }
    _showLongPressBottomSheet(context, comment, _isCurrentUser(comment));
  }

  // 长按弹窗（修复回复回调参数 + 优化逻辑）
  void _showLongPressBottomSheet(
      BuildContext context, CommentResponse comment, bool isCurrentUser) {
    final isFirstLevelComment =
        comment.parentCommentId == null || comment.parentCommentId!.isEmpty;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(Constants.SPACE_16))),
      backgroundColor: Colors.white,
      isDismissible: false,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
              vertical: Constants.SPACE_16, horizontal: Constants.SPACE_20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBottomSheetItem(
                icon: Icons.reply,
                title: "回复",
                onTap: () {
                  Navigator.pop(context);
                  if (isFirstLevelComment) {
                    // 长按一级评论回复：targetReply = null
                    _handleReply(comment, targetReply: null);
                  } else {
                    // 长按二级回复回复：先找到父评论，再传递子回复对象
                    final parentComment = _mainComments.firstWhere(
                      (c) => c.commentId == comment.parentCommentId,
                      orElse: () => comment,
                    );
                    _handleReply(parentComment, targetReply: comment);
                  }
                },
              ),
              if (isCurrentUser)
                _buildBottomSheetItem(
                  icon: Icons.delete,
                  title: "删除",
                  textColor: Colors.red,
                  onTap: () {
                    DeleteCommentDialog.show(
                      context,
                      title: '确定删除此评论吗？',
                      onDelete: () {
                        if (comment.parentCommentId?.isNotEmpty == true) {
                          MineServiceApi.deleteComment(
                              comment.newsId, comment.parentCommentId!);
                          // 删除二级回复：从父评论的 replyComments 中移除
                          final parentComment = _mainComments.firstWhere(
                            (c) => c.commentId == comment.parentCommentId,
                            orElse: () => comment,
                          );
                          if (parentComment != comment) {
                            parentComment.replyComments.remove(comment);
                          }
                        } else {
                          MineServiceApi.deleteComment(
                              comment.newsId, comment.commentId);
                          _mainComments.remove(comment);
                        }
                        setState(() => widget.commentResponse.remove(comment));
                        Navigator.pop(context);
                        Navigator.pop(context);
                        EventBusUtils.sendEvent(CommentDeletedEvent(true));
                      },
                      onCancel: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              _buildBottomSheetItem(
                icon: Icons.close,
                title: "取消",
                textColor: Colors.black,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetItem({
    required IconData icon,
    required String title,
    Color? textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: Constants.SPACE_14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: Constants.SPACE_8),
            Text(
              title,
              style: TextStyle(
                fontSize: Constants.FONT_16 * (widget.fontSizeRatio ?? 1.0),
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAggregatedReplies(
      CommentResponse parentComment, List<CommentResponse> replies) {
    final sortedReplies = List<CommentResponse>.from(replies)
      ..sort((a, b) => a.createTime.compareTo(b.createTime));
    final totalReplyCount = sortedReplies.length;
    List<CommentResponse> displayReplies;

    if (totalReplyCount > 3) {
      final lastReply = sortedReplies.last;
      final previousTwo = sortedReplies.sublist(0, 2);
      displayReplies = [lastReply, ...previousTwo];
    } else {
      displayReplies = sortedReplies;
    }

    return [
      GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CommentDetailList(
                  comments: replies, parentComment: parentComment)),
        ),
        child: Container(
          padding: const EdgeInsets.all(Constants.SPACE_12),
          margin: const EdgeInsets.symmetric(vertical: Constants.SPACE_6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(Constants.SPACE_8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: displayReplies.asMap().entries.map((replyEntry) {
                  final reply = replyEntry.value;

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 二级回复点击（回复二级：targetReply = reply）
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${reply.author?.authorNickName ?? "未知作者"}:",
                                      style: TextStyle(
                                        fontSize: Constants.FONT_14 *
                                            (widget.fontSizeRatio ?? 1.0),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(width: Constants.SPACE_4),
                                    Expanded(
                                      child: Text(
                                        reply.commentBody ?? '',
                                        style: TextStyle(
                                          fontSize: Constants.FONT_14 *
                                              (widget.fontSizeRatio ?? 1.0),
                                          color: Colors.black87,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: Constants.SPACE_1),
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentDetailList(
                            comments: replies, parentComment: parentComment)),
                  ),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize:
                          const Size(Constants.SPACE_50, Constants.SPACE_30)),
                  child: Text(
                    "共$totalReplyCount条回复>",
                    style: TextStyle(
                      fontSize:
                          Constants.FONT_13 * (widget.fontSizeRatio ?? 1.0),
                      color: Colors.blue,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
