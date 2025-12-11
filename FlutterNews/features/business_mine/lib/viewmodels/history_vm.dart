import 'package:flutter/material.dart';
import 'package:lib_news_api/observedmodels/news_model.dart';
import 'package:lib_news_api/services/mine_service.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart';
import 'package:lib_common/dialogs/common_confirm_dialog.dart';

class HistoryViewModel extends ChangeNotifier {
  List<NewsModel> list = [];
  List<String> selectedIds = [];
  bool isEditMode = false;
  SettingInfo settingInfo = SettingInfo();
  WindowModel windowModel = WindowModel();

  HistoryViewModel() {
    queryList();
  }

  void queryList() {
    // 从MineServiceApi获取历史记录
    list = MineServiceApi.queryMyHistory()
        .map((v) => NewsModel.fromNewsResponse(v))
        .toList();
    notifyListeners();
  }

  void onChange(bool value, NewsModel model) {
    if (value) {
      selectedIds.add(model.id);
    } else {
      selectedIds.remove(model.id);
    }
    notifyListeners();
  }

  void enterEdit() {
    isEditMode = true;
    notifyListeners();
  }

  void quitEdit() {
    isEditMode = false;
    selectedIds.clear();
    notifyListeners();
  }

  void deleteConfirm(BuildContext context) {
    CommonConfirmDialog.show(
      context,
      IConfirmDialogParams(
        primaryTitle: '温馨提示',
        content: '删除动作不可恢复，是否删除此条记录？',
        secBtnV: '删除',
        secBtnFg: Colors.red,
        priBtnFg: const Color.fromARGB(255, 100, 130, 218),
        confirm: () {
          for (var id in selectedIds) {
            MineServiceApi.deleteFromHistory(id);
          }
          selectedIds.clear();
          queryList();
          // 使用CommonToastDialog显示删除成功提示
          CommonToastDialog.show(ToastDialogParams(
            message: '已删除',
          ));
        },
      ),
    );
  }

  void deleteAllConfirm(BuildContext context) {
    CommonConfirmDialog.show(
      context,
      IConfirmDialogParams(
        primaryTitle: '温馨提示',
        content: '删除动作不可恢复，是否删除所有历史记录',
        secBtnV: '删除',
        secBtnFg: Colors.red,
        priBtnFg: const Color.fromARGB(255, 100, 130, 218),
        confirm: () {
          // 实现清空所有历史记录的逻辑
          final historyList = MineServiceApi.queryMyHistory();
          for (var item in historyList) {
            MineServiceApi.deleteFromHistory(item.id);
          }
          selectedIds.clear();
          queryList();
          CommonToastDialog.show(ToastDialogParams(
            message: '已清空',
          ));
        },
      ),
    );
  }

  bool get allowEnterEdit {
    return list.isNotEmpty;
  }

  bool get allowDelete {
    return selectedIds.isNotEmpty;
  }

  bool onBackPressed() {
    if (isEditMode) {
      quitEdit();
      return true;
    }
    return false;
  }
}

// 假设存在的辅助类
class SettingInfo {
  double fontSizeRatio = 1.0;
}

class WindowModel {
  double get windowBottomPadding => 0.0;
}
