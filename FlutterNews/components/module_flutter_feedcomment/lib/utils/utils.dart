import 'package:flutter/material.dart';
import './event_dispatcher.dart';
import '../components/publish_comment.dart';

class CommentParams {
  String reNickName;
  Function(String) callback;
  String? articleAuthorId; 

  CommentParams(String? replyAuthor, this.callback, {this.articleAuthorId})
      : reNickName = replyAuthor ?? '';
}

void openPublishComment(
    BuildContext context, String? replyAuthor, Function(String) callback, {String? articleAuthorId}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: publishCommentBuilder(
            context, CommentParams(replyAuthor, callback, articleAuthorId: articleAuthorId)),
      );
    },
    isScrollControlled: true,
  );
}

/// 打开评论弹窗
/// @param replyAuthor 回复对象
/// @param callback 回复回调事件
/// @param context BuildContext
/// @param isVerifyLogin 是否校验登录
/// @param articleAuthorId 文章作者ID
void commentSheetOpen(
    BuildContext context, String? replyAuthor, Function(String) callback,
    [bool? isVerifyLogin, String? articleAuthorId]) {
  if (isVerifyLogin != null && !isVerifyLogin) {
    openPublishComment(context, replyAuthor, callback, articleAuthorId: articleAuthorId);
    return;
  }

  if (CommentEventDispatcher.interceptLogin == null) {
    openPublishComment(context, replyAuthor, callback, articleAuthorId: articleAuthorId);
    return;
  }

  CommentEventDispatcher.dispatchToInterceptLogin((bool? isLogin) {
    if (isLogin == true || isLogin == null) {
      openPublishComment(context, replyAuthor, callback, articleAuthorId: articleAuthorId);
    }
  });
}
