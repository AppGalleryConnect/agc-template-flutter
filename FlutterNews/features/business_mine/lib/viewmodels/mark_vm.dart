import 'package:flutter/material.dart';
import 'package:lib_common/utils/pop_view_utils.dart';
import 'package:lib_news_api/services/mine_service.dart';
import 'package:lib_news_api/observedmodels/news_model.dart';
import '../components/cancel_dialog_builder.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart';

class MarkViewModel extends ChangeNotifier implements MarkLikeObserver {
  List<NewsModel> list = [];

  MarkViewModel() {
    queryList();
    // 注册为MineService的观察者
    MineServiceApi.addObserver(this);
  }

  @override
  void dispose() {
    // 移除观察者
    MineServiceApi.removeObserver(this);
    super.dispose();
  }

  @override
  void onMarkLikeUpdated(MarkLikeUpdateType type) {
    // 当收藏状态更新时，刷新列表
    if (type == MarkLikeUpdateType.Mark || type == MarkLikeUpdateType.All) {
      queryList();
    }
  }

  void queryList() {
    list = MineServiceApi.queryMyMarks()
        .map((v) => NewsModel.fromNewsResponse(v))
        .toList();
    notifyListeners();
  }

  void cancelMark(NewsModel v) {
    MineServiceApi.cancelMark(v.id);
    // 更新NewsModel实例的收藏状态，确保其他使用该实例的组件也能同步更新
    v.toggleMark();
    PopViewUtils.closePopView();
    CommonToastDialog.show(ToastDialogParams(message: '取消收藏成功'));
    queryList();
  }

  void popDialog(BuildContext context, NewsModel v) {
    PopViewUtils.showPopView(
      contentView: cancelDialogBuilder(
        context,
        CancelDialogParams(
          btnText: '取消收藏',
          onCancel: () {
            cancelMark(v);
          },
        ),
      ),
    );
  }
}
