import 'package:flutter/material.dart';
import 'package:lib_news_api/lib_news_api.dart';
import 'comment_action_buttons.dart';
import 'package:module_newsfeed/constants/constants.dart';

class CommentInputBar extends StatefulWidget {
  final VoidCallback onSendComment;
  final VoidCallback onScrollToComment;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final NewsResponse? news;
  final double? fontSizeRatio;

  const CommentInputBar({
    super.key,
    required this.onSendComment,
    required this.onScrollToComment,
    required this.onLike,
    required this.onShare,
    this.news,
    this.fontSizeRatio = 1.0,
  });

  @override
  State<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<CommentInputBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: Constants.SPACE_8,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: Constants.SPACE_16,
          top: Constants.SPACE_5,
          left: Constants.SPACE_8,
          right: Constants.SPACE_8,
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => widget.onSendComment(),
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
                    '发表评论',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(width: Constants.SPACE_12),
            CommentActionButtons(
              newsResponse: widget.news,
              onScrollToComment: widget.onScrollToComment,
              onLike: widget.onLike,
              onShare: widget.onShare,
              showBottomButton: true,
            ),
          ],
        ),
      ),
    );
  }
}
