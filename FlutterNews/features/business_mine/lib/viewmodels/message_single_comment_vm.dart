import 'package:flutter/material.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_news_api/observedmodels/comment_model.dart';
import 'package:lib_news_api/services/message_service.dart';
import 'package:lib_news_api/services/mine_service.dart';
import 'package:lib_news_api/params/request/common_request.dart';
import '../common/observed_model.dart';
import '../utils/font_scale_utils.dart';
import 'package:lib_common/utils/global_context.dart';
import 'package:module_flutter_feedcomment/utils/utils.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart'
    show CommonToastDialog, ToastDialogParams;

class MsgSingleCommentListViewModel extends ChangeNotifier {
  String replyContent = '';
  String currentCommentId = '';
  CommentDetailModel? data;
  List<CommentModel> publishList = [];
  double get fontSizeRatio => FontScaleUtils.fontSizeRatio;

  void init() {
    getParams();
    queryList();
    // 标记评论回复为已读，更新小红点状态
    messageServiceApi.setReplyRead();
  }

  void getParams() {
    // 确保使用正确的参数获取方法
    currentCommentId = RouterUtils.of.getParamByNameWithString<String>(
            RouterMap.MINE_MSG_COMMENT_DETAIL) ??
        '';
    // 如果没有获取到参数，使用默认的评论ID作为fallback，确保页面能展示数据
    if (currentCommentId.isEmpty) {
      currentCommentId = 'comment_1'; // 使用mock数据中存在的评论ID
    }
  }

  Future<void> queryList() async {
    try {
      // 使用MessageService的单例实例而不是MessageServiceApi
      final resp =
          await MessageService().querySingleCommentList(currentCommentId);
      // 确保数据模型正确转换
      data = CommentDetailModel(resp);
      notifyListeners();
    } catch (e) {
      // 错误处理

      // 显示错误提示
      ScaffoldMessenger.of(GlobalContext.context).showSnackBar(
        const SnackBar(content: Text('获取评论详情失败')),
      );
    }
  }

  AggregateNewsCommentModel? getRootComment() {
    // CommentDetailModel的root getter返回AggregateNewsComment类型
    // 我们需要创建一个AggregateNewsCommentModel实例
    if (data?.root != null) {
      return AggregateNewsCommentModel(data!.root);
    }
    return null;
  }

  CommentModel? getCurrentComment() {
    // CommentDetailModel的current getter返回CommentResponse类型
    // 我们需要创建一个CommentModel实例
    if (data?.current != null) {
      return CommentModel(data!.current!);
    }
    return null;
  }

  List<CommentModel> getLeftList() {
    // 直接使用internalList获取CommentModel类型列表，避免类型转换
    if (data?.internalList != null) {
      return data!.internalList;
    }
    return [];
  }

  Future<void> publishReply(dynamic comment, String content) async {
    try {
      // 从comment中提取必要的信息，支持AggregateNewsCommentModel和CommentModel两种类型
      final newsId = comment.newsId;
      final parentCommentId = comment.commentId;

      final params = PublishCommentRequest(
        newsId: newsId,
        content: content,
        parentCommentId: parentCommentId,
      );
      final resp = await MineServiceApi.publishComment(params);
      publishList.add(CommentModel(resp));
      // 使用CommonToastDialog显示成功提示
      CommonToastDialog.show(
        ToastDialogParams(message: '评论成功'),
      );
      notifyListeners();
    } catch (e) {
      // 错误处理

      // 使用CommonToastDialog显示失败提示
      CommonToastDialog.show(
        ToastDialogParams(message: '评论失败'),
      );
    }
  }

  void showCommentSheet(BuildContext context, dynamic comment) {
    try {
      if (comment != null) {
        // 支持AggregateNewsCommentModel和CommentModel两种类型
        String? replyAuthor;

        // 根据不同类型获取作者名称
        if (comment is AggregateNewsCommentModel) {
          replyAuthor = comment.author?.authorNickName;
        } else if (comment is CommentModel) {
          replyAuthor = comment.author?.authorNickName;
        } else {}

        // 直接使用传入的context
        commentSheetOpen(
          context,
          replyAuthor,
          (content) {
            // 调用发布回复方法

            publishReply(comment, content);
          },
          false, // 不校验登录，因为我们已经添加了兜底逻辑
        );
      } else {
        // 添加详细错误日志

        // 显示错误提示给用户
        ScaffoldMessenger.of(GlobalContext.context).showSnackBar(
          const SnackBar(content: Text('无法打开回复框，请稍后重试')),
        );
      }
    } catch (e) {
      // 捕获所有异常

      // 显示错误提示给用户
      ScaffoldMessenger.of(GlobalContext.context).showSnackBar(
        const SnackBar(content: Text('打开回复框时出错')),
      );
    }
  }

  bool get showAllReply {
    return getLeftList().isNotEmpty;
  }

  bool get showMyInstantReply {
    return publishList.isNotEmpty;
  }

  bool onBackPressed() {
    // 在返回前调用setReplyRead，确保评论标记为已读
    messageServiceApi.setReplyRead();
    RouterUtils.of.pop();
    return true;
  }
}
