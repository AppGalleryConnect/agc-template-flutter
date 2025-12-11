import 'package:flutter/material.dart';
import 'package:lib_common/dialogs/common_confirm_dialog.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart';
import 'package:lib_news_api/services/mine_service.dart';
import '../common/observed_model.dart';

class DelItem {
  String? newsId;
  String? commentId;

  DelItem({this.newsId, this.commentId});
}

class CommentViewModel extends ChangeNotifier {
  bool isEditMode = false;
  List<DelItem> toDeleteList = [];
  List<AggregateNewsCommentModel> list = [];

  CommentViewModel() {
    queryList();
  }

  void queryList() {
    list = MineServiceApi.queryMineCommentList()
        .map((v) => AggregateNewsCommentModel(v))
        .toList();
    notifyListeners();
  }

  void callDeleteApi(bool isDelAll, List<DelItem> toDeleteList) {
    if (isDelAll) {
      for (var v in list) {
        MineServiceApi.deleteComment(v.newsId, v.commentId);
      }
    } else {
      for (var v in toDeleteList) {
        MineServiceApi.deleteComment(v.newsId!, v.commentId!);
      }
    }

    this.toDeleteList = [];
  }

  void onChange(bool value, AggregateNewsCommentModel v) {
    if (value) {
      toDeleteList.add(DelItem(
        newsId: v.newsId,
        commentId: v.commentId,
      ));
    } else {
      final index =
          toDeleteList.indexWhere((item) => item.commentId == v.commentId);
      if (index != -1) {
        toDeleteList.removeAt(index);
      }
    }
    notifyListeners();
  }

  void enterEdit() {
    isEditMode = true;
    notifyListeners();
  }

  void quitEdit() {
    isEditMode = false;
    toDeleteList.clear();
    notifyListeners();
  }

  void deleteAllConfirm(BuildContext context) {
    CommonConfirmDialog.show(
      context,
      IConfirmDialogParams(
        primaryTitle: '温馨提示',
        content: '删除全部评论后，所有评论内容将被永久删除，无法找回，请确认是否继续。',
        secBtnV: '删除',
        secBtnFg: Colors.red,
        confirm: () {
          callDeleteApi(true, []);
          quitEdit();
          queryList();
          // 使用CommonToastDialog显示提示
          CommonToastDialog.show(ToastDialogParams(
            message: '已清空',
          ));
        },
      ),
    );
  }

  void deleteConfirm(BuildContext context) {
    final String dialogText = toDeleteList.length == 1
        ? '删除动作不可恢复，是否删除此条评论？'
        : '删除动作不可恢复，是否删除 ${toDeleteList.length} 条评论？';
    CommonConfirmDialog.show(
      context,
      IConfirmDialogParams(
        primaryTitle: '温馨提示',
        content: dialogText,
        secBtnV: '删除',
        secBtnFg: Colors.red,
        confirm: () {
          callDeleteApi(false, toDeleteList);
          quitEdit();
          queryList();
          // 使用CommonToastDialog显示提示
          CommonToastDialog.show(ToastDialogParams(
            message: '已删除',
          ));
        },
      ),
    );
  }

  bool onBackPressed() {
    if (isEditMode) {
      isEditMode = false;
      toDeleteList.clear();
      notifyListeners();
      return true;
    }
    return false;
  }

  bool get allowDelete {
    return toDeleteList.isNotEmpty;
  }

  bool get allowEnterEdit {
    return list.isNotEmpty;
  }
}
