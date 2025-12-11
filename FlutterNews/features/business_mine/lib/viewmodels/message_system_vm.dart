import 'package:flutter/material.dart';
import 'package:lib_news_api/services/message_service.dart';
import '../common/observed_model.dart';
import 'dart:developer' as developer;

class MsgSystemViewModel extends ChangeNotifier {
  List<SystemMessageInfo> list = [];

  MsgSystemViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // 标记系统消息为已读
      await messageServiceApi.setSystemRead();

      // 获取系统消息列表
      final resp = await messageServiceApi.queryAllSystemInfoList();

      // 转换数据模型
      list = resp.map((item) => SystemMessageInfo(item)).toList();
      notifyListeners();
    } catch (e) {
      // 错误处理
      print('Failed to initialize system messages: \$e');
    }
  }

  /// 删除指定作者的私信
  Future<void> deleteSystemIm(String id) async {
    try {
      await messageServiceApi.deleteSystemIM(id);
      list.removeWhere((v) => v.id == id);
      notifyListeners();
    } catch (e) {
      developer.log('Delete IM error: $e',
          name: 'business_mine.message_im_list_vm');
    }
  }

  Future<void> deleteAllSyetem() async {
    try {
      List<SystemMessageInfo> copy = List.from(list);
      for (SystemMessageInfo model in copy) {
        if (model.isSelect) {
          await messageServiceApi.deleteSystemIM(model.id);
          list.removeWhere((v) => v.id == model.id);
        }
      }
      notifyListeners();
    } catch (e) {
      developer.log('Delete IM error: $e',
          name: 'business_mine.message_im_list_vm');
    }
  }

  bool isShowSelect = false;

  void onClickShow(bool isShow) {
    isShowSelect = isShow;

    for (SystemMessageInfo model in list) {
      model.isDelete = false;
      model.isSelect = false;
    }
    notifyListeners();
  }

  int get deleteCount {
    int i = 0;
    for (SystemMessageInfo model in list) {
      if (model.isSelect) i++;
    }
    return i;
  }

  bool get isSelectAll {
    bool isSelectAll = true;
    for (SystemMessageInfo model in list) {
      if (!model.isSelect) isSelectAll = false;
    }
    return isSelectAll;
  }

  void onSelectAll(bool isSelectAll) {
    for (SystemMessageInfo model in list) {
      model.isSelect = !isSelectAll;
    }
    notifyListeners();
  }
}
