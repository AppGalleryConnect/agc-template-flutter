import 'package:flutter/material.dart';
import '../model/model.dart';
import '../utils/utils.dart';
import '../viewModel/feed_comment_vm.dart';
import 'comment_card.dart';
import 'package:module_flutter_feedcomment/constants/constants.dart';

class TotalComment extends StatefulWidget {
  const TotalComment({super.key});

  @override
  _TotalCommentState createState() => _TotalCommentState();
}

class _TotalCommentState extends State<TotalComment> {
  final FeedCommentVM feedCommentVM = FeedCommentVM.instance;

  Widget commentBuilder(
      BuildContext context, CommentInfo item, bool needPadding) {
    return Column(
      children: item.replyComments.map((value) {
        return Padding(
          padding: EdgeInsets.only(
              left: needPadding ? Constants.SPACE_16 : Constants.SPACE_0,
              right: needPadding ? Constants.SPACE_16 : Constants.SPACE_0),
          child: CommentCard(
            commentInfo: value,
            articleInfo: feedCommentVM.commentDetailInfo,
            isDark: feedCommentVM.isDark,
            replyComponentBuilder: (context) => const SizedBox(),
            totalCommentBuilder: (context) =>
                commentBuilder(context, value, false),
            isNeedReply: true,
          ),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    feedCommentVM.addListener(_refreshUI);

    super.initState();
  }

  @override
  void dispose() {
    feedCommentVM.removeListener(_refreshUI);
    super.dispose();
  }

  void _refreshUI() {
    if (feedCommentVM.commentDetailInfo.commentId == '') {
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.of(context).pop();
      });
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: feedCommentVM.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: feedCommentVM.isDark ? Colors.black : Colors.white,
        title: Text(
          '共${feedCommentVM.commentDetailInfo.replyComments.length}条回复',
          style: TextStyle(
              color: feedCommentVM.isDark ? Colors.white : Colors.black),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Container(
            color: feedCommentVM.isDark ? Colors.black : Colors.grey[200],
            width: double.infinity,
            height: Constants.SPACE_8,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1 +
                        2 +
                        feedCommentVM.commentDetailInfo.replyComments.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // 主要评论
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.SPACE_16,
                            vertical: Constants.SPACE_8,
                          ),
                          child: CommentCard(
                            commentInfo: feedCommentVM.commentDetailInfo,
                            articleInfo: feedCommentVM.commentDetailInfo,
                            isDark: feedCommentVM.isDark,
                            replyComponentBuilder: (context) =>
                                const SizedBox(),
                            totalCommentBuilder: (context) => const SizedBox(),
                            isNeedReply: false,
                          ),
                        );
                      } else if (index == 1) {
                        // 分隔线
                        return Container(
                          color: feedCommentVM.isDark
                              ? Colors.black
                              : Colors.grey[200],
                          width: double.infinity,
                          height: Constants.SPACE_8,
                        );
                      } else if (index == 2) {
                        // "全部回复"标题
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.SPACE_16,
                            vertical: Constants.SPACE_8,
                          ),
                          child: Text(
                            '全部回复',
                            style: TextStyle(
                                color: feedCommentVM.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: Constants.FONT_16 *
                                    feedCommentVM.fontSizeRatio,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        // 回复列表
                        final replyIndex = index - 3;
                        final value = feedCommentVM
                            .commentDetailInfo.replyComments[replyIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.SPACE_16,
                          ),
                          child: CommentCard(
                            commentInfo: value,
                            articleInfo: feedCommentVM.commentDetailInfo,
                            isDark: feedCommentVM.isDark,
                            replyComponentBuilder: (context) =>
                                const SizedBox(),
                            totalCommentBuilder: (context) =>
                                commentBuilder(context, value, false),
                            isNeedReply: true,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // 底部回复框
          Container(
            color: feedCommentVM.isDark
                ? Colors.black
                : Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.SPACE_16,
              vertical: Constants.SPACE_16,
            ),
            child: GestureDetector(
              onTap: () {
                commentSheetOpen(
                  context,
                  feedCommentVM.commentDetailInfo.author.authorNickName,
                  (String replyContent) {
                    feedCommentVM.addComment(
                        feedCommentVM.commentDetailInfo, replyContent);
                  },
                );
              },
              child: Container(
                width: double.infinity,
                height: Constants.SPACE_40,
                decoration: BoxDecoration(
                  color: feedCommentVM.isDark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(Constants.SPACE_24),
                ),
                padding: const EdgeInsets.only(left: Constants.SPACE_16),
                alignment: Alignment.centerLeft,
                child: Text(
                  '回复',
                  style: TextStyle(
                    fontSize: Constants.FONT_14 * feedCommentVM.fontSizeRatio,
                    color: feedCommentVM.isDark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
