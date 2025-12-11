import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_news_api/services/mine_service.dart';
import 'package:lib_news_api/services/message_service.dart';
import 'package:lib_news_api/params/request/common_request.dart';
import 'package:flutter/material.dart';
import 'package:module_flutter_feedcomment/utils/utils.dart';
import '../common/observed_model.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart'
    show CommonToastDialog, ToastDialogParams;

class MsgCommentViewModel extends ChangeNotifier {
  List<AggregateNewsCommentModel> list = [];
  bool loading = false;
  double fontSizeRatio = 1.0;

  MsgCommentViewModel() {
    queryList();
    setAllRead();
  }

  Future<void> queryList() async {
    loading = true;
    notifyListeners();

    try {
      final resp = await messageServiceApi.queryCommentReplyList();
      list = resp.map((v) => AggregateNewsCommentModel(v)).toList();
    } catch (error) {
      print('获取评论回复列表失败: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void replyComment(BuildContext context, AggregateNewsCommentModel v) {
    commentSheetOpen(
      context,
      v.author?.authorNickName ?? '',
      (content) {
        publishReply(v, content);
      },
      false,
    );
  }

  void jumpProfile(String authorId) {
    RouterUtils.of.push(RouterMap.PROFILE_HOME, arguments: authorId);
  }

  void jumpMoreComment(String commentId) {
    RouterUtils.of
        .pushPathByName(RouterMap.MINE_MSG_COMMENT_DETAIL, param: commentId);
  }

  void publishReply(AggregateNewsCommentModel data, String content) {
    final params = PublishCommentRequest(
      newsId: data.newsId,
      content: content,
      parentCommentId: data.commentId,
    );

    MineServiceApi.publishComment(params).then((_) {
      CommonToastDialog.show(
        ToastDialogParams(
          message: '评论成功',
          duration: const Duration(milliseconds: 2000),
        ),
      );
      queryList();
    }).catchError((error) {
      CommonToastDialog.show(
        ToastDialogParams(
          message: '评论失败，请重试',
          duration: const Duration(milliseconds: 2000),
        ),
      );
    });
  }

  // 区分评论/回复
  bool isReply(AggregateNewsCommentModel v) {
    return v.parentCommentId != null && v.parentCommentId!.isNotEmpty;
  }

  Future<void> onRefresh() {
    return queryList();
  }

  void setAllRead() {
    messageServiceApi.setReplyRead();
  }

  bool onBackPressed() {
    messageServiceApi.setReplyRead();
    RouterUtils.of.pop();
    return true;
  }
}
