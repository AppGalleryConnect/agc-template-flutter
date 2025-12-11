import 'package:business_video/views/video_sheet.dart';
import 'package:lib_account/viewmodels/login_vm.dart' as login_vm;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lib_account/services/account_api.dart';
import 'package:lib_news_api/params/request/common_request.dart';
import 'package:lib_news_api/params/response/comment_response.dart';
import 'package:lib_news_api/services/comment_service.dart';
import 'package:lib_news_api/services/mine_service.dart';
import 'package:module_flutter_feedcomment/utils/utils.dart';
import 'package:module_share/utils/event_dispatcher.dart';
import 'delete_commentDialog.dart';
import 'package:module_newsfeed/constants/constants.dart';

class CommentDetailList extends StatefulWidget {
  final CommentResponse? parentComment;
  final List<CommentResponse> comments;
  const CommentDetailList(
      {super.key, required this.comments, this.parentComment});
  @override
  State<CommentDetailList> createState() => _CommentDetailListState();
}

class _CommentDetailListState extends State<CommentDetailList> {
  late List<CommentResponse> _localComments;
  final userInfoModel = AccountApi.getInstance().userInfoModel;

  @override
  void initState() {
    super.initState();

    setState(() {
      _localComments = widget.comments;
    });
    _localComments = List.from(widget.comments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('评论详情', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final appBarHeight = AppBar().preferredSize.height;
          const inputHeight = Constants.SPACE_40;
          final listHeight = screenHeight - appBarHeight - inputHeight;

          return Stack(
            children: [
              Positioned(
                top: Constants.SPACE_0,
                left: Constants.SPACE_0,
                right: Constants.SPACE_0,
                height: listHeight,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.SPACE_16,
                      vertical: Constants.SPACE_12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.parentComment != null)
                        _buildParentCommentHeader(widget.parentComment!),
                      if (widget.parentComment != null)
                        const SizedBox(height: Constants.SPACE_16),
                      const Text(
                        '全部评论',
                        style: TextStyle(
                          fontSize: Constants.FONT_16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: Constants.SPACE_12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _localComments.length,
                        itemBuilder: (context, index) {
                          final comment = _localComments[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCommentItem(comment),
                              const SizedBox(height: Constants.SPACE_2),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // 底部输入框
              Positioned(
                left: Constants.SPACE_10,
                right: Constants.SPACE_10,
                bottom: Constants.SPACE_18,
                child: GestureDetector(
                  onTap: () => showCommond(
                      widget.parentComment!.author!.authorNickName,
                      widget.parentComment!.commentId),
                  child: Container(
                    height: Constants.SPACE_40,
                    padding: const EdgeInsets.all(Constants.SPACE_10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Constants.SPACE_24),
                      border: Border.all(
                          color: Colors.black12, width: Constants.SPACE_1),
                      color: Colors.grey[200],
                    ),
                    child: const Text(
                      '回复',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void showCommond(String title, String commendId) {
    final loginVM = login_vm.LoginVM.getInstance();
    if (!loginVM.accountInstance.userInfoModel.isLogin) {
      VideoSheet.showLoginSheet(context);
      return;
    }
    commentSheetOpen(
      context,
      title,
      (content) {
        PublishCommentRequest params = PublishCommentRequest(
            newsId: widget.parentComment!.newsId,
            content: content,
            parentCommentId: commendId);
        MineServiceApi.publishComment(params).then((value) {
          setState(() {
            _localComments.insert(0, value);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("评论发送成功！"), duration: Duration(seconds: 1)),
          );
        });
      },
      false,
    );
  }

  void _showLongPressBottomSheet(
      BuildContext context, CommentResponse comment, bool hidden) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Constants.SPACE_16)),
      ),
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
                  showCommond(widget.parentComment!.author!.authorNickName,
                      widget.parentComment!.commentId);
                },
              ),
              if (hidden == true)
                _buildBottomSheetItem(
                  icon: Icons.delete,
                  title: "删除",
                  textColor: Colors.red,
                  onTap: () {
                    DeleteCommentDialog.show(
                      context,
                      title: '确定删除此评论吗？',
                      onDelete: () {
                        final loginVM = login_vm.LoginVM.getInstance();
                        if (!loginVM.accountInstance.userInfoModel.isLogin) {
                          VideoSheet.showLoginSheet(context);
                          return;
                        }
                        if (comment.parentCommentId!.isNotEmpty) {
                          CommentServiceApi.deleteComment(
                              comment.parentCommentId!);
                        } else {
                          CommentServiceApi.deleteComment(comment.commentId);
                        }
                        setState(() {
                          widget.comments.remove(comment);
                          _localComments.remove(comment);
                        });

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
    Color? textColor = Colors.black87,
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
                fontSize: Constants.FONT_16,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentCommentHeader(CommentResponse parentComment) {
    final authorName = parentComment.author?.authorNickName ?? "未知作者";
    final formattedTime = _formatTime(parentComment.createTime);
    final commentContent = parentComment.commentBody ?? "无评论内容";

    return Container(
      padding: const EdgeInsets.only(left: Constants.SPACE_1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Constants.SPACE_36,
                height: Constants.SPACE_36,
                child: CircleAvatar(
                  radius: Constants.SPACE_18,
                  backgroundImage:
                      parentComment.author?.authorIcon.isNotEmpty == true
                          ? NetworkImage(parentComment.author!.authorIcon)
                          : const AssetImage(Constants.iconDefaultImage)
                              as ImageProvider,
                ),
              ),
              const SizedBox(width: Constants.SPACE_5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(authorName,
                        style: const TextStyle(
                            fontSize: Constants.FONT_14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(height: Constants.SPACE_6),
                    GestureDetector(
                        onLongPress: () {
                          final loginVM = login_vm.LoginVM.getInstance();
                          if (!loginVM.accountInstance.userInfoModel.isLogin) {
                            VideoSheet.showLoginSheet(context);
                            return;
                          }
                          if (widget.parentComment!.author?.authorId ==
                              login_vm.LoginVM.getInstance()
                                  .accountInstance
                                  .userInfoModel
                                  .authorId) {
                            // 自己的评论，可以删除
                            _showLongPressBottomSheet(
                                context, parentComment, true);
                          } else {
                            _showLongPressBottomSheet(
                                context, parentComment, false);
                          }
                        },
                        child: Text(commentContent,
                            style: const TextStyle(
                                fontSize: Constants.FONT_15,
                                color: Colors.black87),
                            softWrap: true)),
                    const SizedBox(height: Constants.SPACE_6),
                    Row(
                      children: [
                        Text(formattedTime,
                            style: const TextStyle(
                                fontSize: Constants.FONT_12,
                                color: Colors.grey)),
                        const SizedBox(width: Constants.SPACE_20),
                        GestureDetector(
                          onTap: () {
                            showCommond(
                                widget.parentComment!.author!.authorNickName,
                                widget.parentComment!.commentId);
                          },
                          child: const Text(
                            '回复',
                            style: TextStyle(
                              fontSize: Constants.FONT_12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            final loginVM = login_vm.LoginVM.getInstance();
                            if (!loginVM
                                .accountInstance.userInfoModel.isLogin) {
                              VideoSheet.showLoginSheet(context);
                              return;
                            }
                            parentComment.isLiked = !parentComment.isLiked;
                            setState(() {
                              if (parentComment.isLiked) {
                                if (parentComment.commentLikeNum >= 0) {
                                  parentComment.commentLikeNum++;
                                }
                                CommentServiceApi.addCommentLike(
                                    parentComment.commentId);
                              } else {
                                if (parentComment.commentLikeNum > 0) {
                                  parentComment.commentLikeNum--;
                                }
                                CommentServiceApi.cancelLikeComment(
                                    parentComment.commentId);
                              }
                              EventBusUtils.sendEvent(NewLikeEvent(
                                  parentComment.isLiked,
                                  parentComment.commentId));
                            });
                          },
                          child: SvgPicture.asset(
                            parentComment.isLiked
                                ? Constants.giveLikeActiveImage
                                : Constants.giveLikeImage,
                            width: Constants.SPACE_16,
                            height: Constants.SPACE_16,
                          ),
                        ),
                        const SizedBox(width: Constants.SPACE_5),
                        Text(
                          parentComment.commentLikeNum.toString(),
                          style: const TextStyle(
                            fontSize: Constants.FONT_12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentResponse comment) {
    final authorName = comment.author?.authorNickName ?? "未知作者";
    final formattedTime = _formatTime(comment.createTime);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Constants.SPACE_32,
          height: Constants.SPACE_32,
          child: CircleAvatar(
            radius: Constants.SPACE_16,
            backgroundImage: comment.author?.authorIcon.isNotEmpty == true
                ? NetworkImage(comment.author!.authorIcon)
                : const AssetImage(Constants.iconDefaultImage) as ImageProvider,
          ),
        ),
        const SizedBox(width: Constants.SPACE_8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(authorName,
                    style: const TextStyle(
                        fontSize: Constants.FONT_14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(width: Constants.SPACE_8)
              ]),
              const SizedBox(height: Constants.SPACE_4),
              Text(comment.commentBody ?? "无评论内容",
                  style: const TextStyle(
                      fontSize: Constants.FONT_14, color: Colors.black87)),
              Row(
                children: [
                  Text(formattedTime,
                      style: const TextStyle(
                          fontSize: Constants.FONT_12, color: Colors.grey)),
                  const SizedBox(width: Constants.SPACE_20),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      final loginVM = login_vm.LoginVM.getInstance();
                      if (!loginVM.accountInstance.userInfoModel.isLogin) {
                        VideoSheet.showLoginSheet(context);
                        return;
                      }
                      comment.isLiked = !comment.isLiked;
                      setState(() {
                        if (comment.isLiked) {
                          if (comment.commentLikeNum >= 0) {
                            comment.commentLikeNum++;
                          }
                          CommentServiceApi.addCommentLike(comment.commentId);
                        } else {
                          if (comment.commentLikeNum > 0) {
                            comment.commentLikeNum--;
                          }
                          CommentServiceApi.cancelLikeComment(
                              comment.commentId);
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize:
                            const Size(Constants.SPACE_40, Constants.SPACE_24)),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          comment.isLiked
                              ? Constants.giveLikeActiveImage
                              : Constants.giveLikeImage,
                          width: Constants.SPACE_16,
                          height: Constants.SPACE_16,
                        ),
                        const SizedBox(width: Constants.SPACE_5),
                        Text(
                          comment.commentLikeNum.toString(),
                          style: const TextStyle(
                            fontSize: Constants.FONT_12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
