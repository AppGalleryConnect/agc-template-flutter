import 'request_model.dart';
import 'response_model.dart';
import 'mockdata/mockdata.dart';

class FuncService {
  /// 新增提交反馈
  Future<void> addFeedback(SubmitFeedbackParams params) {
    return Future.delayed(const Duration(milliseconds: 500), () {
      final item = FeedbackResponseParams(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createTime: DateTime.now().millisecondsSinceEpoch,
        problemDesc: params.problemDesc,
        screenShots: params.screenShots,
        contactPhone: params.contactPhone,
      );
      MockData.list.insert(0, item);
    });
  }

  /// 查询反馈记录列表
  Future<List<FeedbackResponseParams>> queryFeedbackList() {
    return Future.delayed(const Duration(milliseconds: 500), () {
      return MockData.list;
    });
  }
}

// 创建单例
final FuncService feedbackService = FuncService();
