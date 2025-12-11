import 'package:flutter/material.dart';
import '../common/constants.dart';
import '../services/func_service.dart';
import '../services/request_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lib_common/lib_common.dart' as Common;
import 'package:lib_common/dialogs/common_toast_dialog.dart';

class SubmitVM with ChangeNotifier {
  String body = '';
  List<String> imgArr = [];
  String contactPhone = '';
  final int maxSelectNumber = Constants.MAX_IMG_COUNT;
  bool loading = false;
  SubmitVM();
  // 更新反馈内容
  void updateBody(String value) {
    body = value;
    notifyListeners();
  }

  // 更新联系电话
  void updateContactPhone(String value) {
    contactPhone = value;
    notifyListeners();
  }

  // 添加图片
  void addImage(String uri) {
    if (imgArr.length < maxSelectNumber) {
      imgArr.add(uri);
      notifyListeners();
    }
  }

  // 删除图片
  void removeImage(int index) {
    imgArr.removeAt(index);
    notifyListeners();
  }

  // 选择图片
  Future<void> selectPhoto() async {
    try {
      final remainingCount = maxSelectNumber - imgArr.length;
      if (remainingCount <= 0) {
        return;
      }
      final ImagePicker picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage(
        imageQuality: 80,
      );
      if (pickedFiles.isNotEmpty) {
        final limitedFiles = pickedFiles.take(remainingCount).toList();
        for (var file in limitedFiles) {
          addImage(file.path);
        }
      }
    } catch (e) {
      CommonToastDialog.show(ToastDialogParams(
        message: '选择图片失败，请重试',
        duration: const Duration(seconds: 1),
      ));
    }
  }

  // 提交反馈
  Future<bool> submit(BuildContext context) async {
    if (!validInfo(context)) {
      return false;
    }
    loading = true;
    notifyListeners();
    try {
      final params = SubmitFeedbackParams(
        problemDesc: body,
        screenShots: imgArr,
        contactPhone: contactPhone.isEmpty ? null : contactPhone,
      );
      await feedbackService.addFeedback(params);
      CommonToastDialog.show(ToastDialogParams(
        message: '提交成功！',
        duration: const Duration(milliseconds: 800),
      ));
      await Future.delayed(const Duration(milliseconds: 1200));
      Navigator.pushReplacementNamed(
          context, Common.RouterMap.FEEDBACK_RECORD_LIST_PAGE);
    } catch (e) {
      CommonToastDialog.show(ToastDialogParams(
        message: '提交失败，请重试',
        duration: const Duration(seconds: 1),
      ));
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
    return true;
  }

  // 验证提交信息
  bool validInfo(BuildContext context) {
    if (body.isEmpty) {
      CommonToastDialog.show(ToastDialogParams(
        message: '请描述您的问题',
        duration: const Duration(seconds: 1),
      ));
      return false;
    }

    if (contactPhone.isNotEmpty) {
      final phoneReg = RegExp(Constants.PHONE_REG);
      if (!phoneReg.hasMatch(contactPhone)) {
        CommonToastDialog.show(ToastDialogParams(
          message: '请输入正确的手机号码',
          duration: const Duration(seconds: 1),
        ));
        return false;
      }
    }

    return true;
  }
}
