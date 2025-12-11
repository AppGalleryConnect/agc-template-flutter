import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../viewModel/feed_comment_vm.dart';
import '../utils/common_toast_dialog.dart'
    show CommonToastDialog, ToastDialogParams;
import 'package:module_flutter_feedcomment/constants/constants.dart';
import '../utils/send_button.dart';

class PublishComment extends StatefulWidget {
  final CommentParams commentParams;

  const PublishComment({
    super.key,
    required this.commentParams,
  });

  @override
  _PublishCommentState createState() => _PublishCommentState();
}

class _PublishCommentState extends State<PublishComment> {
  String commendText = '';
  bool emojiActive = false;
  double keyBordHeight = 0;
  late final FeedCommentVM feedCommentVM;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    feedCommentVM = FeedCommentVM.instance;
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Constants.SPACE_24),
          topRight: Radius.circular(Constants.SPACE_24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Constants.SPACE_16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: widget.commentParams.reNickName.isNotEmpty
                      ? '回复 ${widget.commentParams.reNickName}'
                      : '发表评论',
                  hintStyle: TextStyle(
                    fontSize: Constants.FONT_14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  contentPadding: const EdgeInsets.only(
                      left: Constants.SPACE_16,
                      top: Constants.SPACE_10,
                      bottom: Constants.SPACE_10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constants.SPACE_24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: TextStyle(
                  fontSize: Constants.FONT_14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                keyboardType: TextInputType.text,
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    commendText = value;
                  });
                },
                autofocus: true,
              ),
            ),
            const SizedBox(width: Constants.SPACE_8),
            SendButton(
              controller: _controller,
              onPressed: () {
                if (commendText.trim().isEmpty) {
                  CommonToastDialog.show(
                      ToastDialogParams(
                        message: '发表内容不能为空',
                        duration: const Duration(milliseconds: 2000),
                      ),
                      context);
                  return;
                }

                widget.commentParams.callback(commendText);

                Navigator.of(context).pop();

                if (widget.commentParams.articleAuthorId != null) {
                  CommonToastDialog.show(
                      ToastDialogParams(
                        message: '发表成功',
                        duration: const Duration(milliseconds: 2000),
                      ),
                      context);
                }
              },
              iconPath: Constants.publishImage,
            ),
          ],
        ),
      ),
    );
  }
}

Widget publishCommentBuilder(
    BuildContext context, CommentParams commentParams) {
  return PublishComment(commentParams: commentParams);
}
