import 'package:flutter/material.dart';

import '../services/func_service.dart';
import '../services/response_model.dart';

class RecordListVM with ChangeNotifier {
  List<FeedbackResponseParams> list = [];
  bool loading = false;

  RecordListVM() {
    queryListInfo();
  }

  Future<void> queryListInfo() async {
    loading = true;
    notifyListeners();

    try {
      list = await feedbackService.queryFeedbackList();
    } catch (e) {
      // 处理错误
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
