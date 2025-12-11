import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/model.dart';
import '../components/comment_card.dart';
import '../viewModel/feed_comment_vm.dart';
import '../utils/event_dispatcher.dart';
import '../utils/utils.dart';
import 'package:module_flutter_feedcomment/constants/constants.dart';

class FeedComment extends StatefulWidget {
  final AuthorInfo author;
  final List<CommentInfo> commentList;
  final double fontSizeRatio;
  final bool isDark;
  final Function(CommentInfo, String) addComment;
  final Function(CommentInfo, bool) giveLike;
  final Function(String) onGoAuthorInfo;
  final Function(Function(bool)) onInterceptLogin;
  final Function(String) onDeleteComment;
  final Function(String) onFirstComment;
  final WidgetBuilder commentTopViewBuilder;

  const FeedComment({
    super.key,
    required this.author,
    required this.commentList,
    this.fontSizeRatio = 1.0,
    this.isDark = false,
    required this.addComment,
    required this.giveLike,
    required this.onGoAuthorInfo,
    required this.onInterceptLogin,
    required this.onDeleteComment,
    required this.onFirstComment,
    required this.commentTopViewBuilder,
  });

  @override
  _FeedCommentState createState() => _FeedCommentState();
}

class _FeedCommentState extends State<FeedComment> {
  final FeedCommentVM feedCommentVM = FeedCommentVM.instance;
  final ScrollController _scroller = ScrollController();

  @override
  void initState() {
    super.initState();
    initDispatch();
    setFontSizeRatio();
    setDarkMode();
    setAuthor();
  }

  @override
  void didUpdateWidget(FeedComment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fontSizeRatio != widget.fontSizeRatio) {
      setFontSizeRatio();
    }
    if (oldWidget.isDark != widget.isDark) {
      setDarkMode();
    }
  }

  void initDispatch() {
    CommentEventDispatcher.addCommentCallback = (commentInfo, replyContent) {
      widget.addComment(commentInfo, replyContent);
    };
    CommentEventDispatcher.giveLikeCallback = (commentInfo, isLike) {
      widget.giveLike(commentInfo, isLike);
    };
    CommentEventDispatcher.goUserHome = (authorId) {
      widget.onGoAuthorInfo(authorId);
    };
    CommentEventDispatcher.interceptLogin = (cb) {
      widget.onInterceptLogin(cb);
    };
    CommentEventDispatcher.deleteComment = (commentId) {
      widget.onDeleteComment(commentId);
    };
  }

  void setFontSizeRatio() {
    feedCommentVM.setFontSizeRatio(widget.fontSizeRatio);
  }

  void setDarkMode() {
    feedCommentVM.setIsDark(widget.isDark);
  }

  void setAuthor() {
    feedCommentVM.setAuthor(widget.author);
  }

  @override
  Widget build(BuildContext context) {
    feedCommentVM.updateCommentDetailInfo(widget.commentList);
    return Container(
      color: widget.isDark ? Colors.black : Colors.white,
      child: Column(
        children: [
          commentTopView(),
          widget.commentTopViewBuilder(context),
          Expanded(
            child: widget.commentList.isEmpty
                ? emptyWidget(context)
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    controller: _scroller,
                    itemCount: widget.commentList.length,
                    itemBuilder: (context, index) {
                      return commentComponent(widget.commentList[index]);
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget emptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '暂无评论，点击抢首评',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Constants.FONT_16 * widget.fontSizeRatio,
              color: widget.isDark
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: Constants.SPACE_16),
          ElevatedButton(
            onPressed: () {
              commentSheetOpen(
                context,
                null,
                (commentContent) {
                  widget.onFirstComment(commentContent);
                },
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: Constants.SPACE_6,
                horizontal: Constants.FONT_16,
              ),
              backgroundColor: Colors.blue,
            ),
            child: Text(
              '写评论',
              style: TextStyle(
                fontSize: Constants.FONT_16 * widget.fontSizeRatio,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget commentTopView() {
    return Container(
      margin: const EdgeInsets.only(
          top: Constants.SPACE_16, bottom: Constants.SPACE_16),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: '评论·'),
            TextSpan(text: widget.commentList.length.toString()),
          ],
        ),
        style: TextStyle(
          fontSize: Constants.FONT_18 * widget.fontSizeRatio,
          fontWeight: FontWeight.bold,
          color: widget.isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget commentComponent(CommentInfo params) {
    return CommentCard(
      commentInfo: params,
      articleInfo: params,
      isDark: widget.isDark,
      replyComponentBuilder: (context) {
        return replyComponent(
          params.replyComments,
        );
      },
      totalCommentBuilder: (context) => const SizedBox(),
      isNeedReply: true,
    );
  }

  Widget replyComponent(List<CommentInfo> replyComments) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.SPACE_8),
        color: feedCommentVM.isDark ? Colors.grey[800] : Colors.grey[200],
      ),
      padding: const EdgeInsets.all(Constants.SPACE_8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...(replyComments.take(3).map((item) {
            return Container(
              margin: const EdgeInsets.only(top: Constants.SPACE_8),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              CommentEventDispatcher.dispatchToUserHome(
                                  item.author.authorId);
                            },
                            child: Text(
                              '${item.author.authorNickName}:',
                              style: TextStyle(
                                fontSize: Constants.FONT_12 *
                                    feedCommentVM.fontSizeRatio,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.commentBody,
                              style: TextStyle(
                                fontSize: Constants.FONT_12 *
                                    feedCommentVM.fontSizeRatio,
                                color: feedCommentVM.isDark
                                    ? Colors.grey[400]
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList()),
          Container(
            margin: const EdgeInsets.only(top: Constants.SPACE_8),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: '共'),
                  TextSpan(text: replyComments.length.toString()),
                  const TextSpan(text: '条回复 >'),
                ],
              ),
              style: TextStyle(
                fontSize: Constants.FONT_12 * feedCommentVM.fontSizeRatio,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
