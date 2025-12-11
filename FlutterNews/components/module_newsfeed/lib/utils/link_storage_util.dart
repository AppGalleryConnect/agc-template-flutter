import 'dart:core';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert'; 

/// 二维码生成与保存工具类（兼容Flutter 3.10+）
class QrCodeSaveUtil {
  static String _modelToJsonString(dynamic model) {
    try {
      return json.encode(model.toJson());
    } catch (e) {
      throw PlatformException(
        code: "MODEL_TO_JSON_ERROR",
        message: "模型转换JSON...失败：${e.toString()}",
      );
    }
  }

  /// 2. 检查并申请相册权限（修复focusedContext问题）
  static Future<bool> _checkGalleryPermission() async {
    PermissionStatus status;
    // 关键修复：用 PlatformDispatcher 判断当前平台（替代已移除的focusedContext）
    final currentPlatform = defaultTargetPlatform;

    if (currentPlatform == TargetPlatform.android) {
      // Android：优先用PHOTOS权限，兼容低版本STORAGE
      status = await Permission.photos.status;
      if (status.isDenied) status = await Permission.photos.request();
      if (status.isDenied) status = await Permission.storage.request();
    } else if (currentPlatform == TargetPlatform.iOS) {
      // iOS：统一用PHOTOS权限
      status = await Permission.photos.status;
      if (status.isDenied) status = await Permission.photos.request();
    } else {
      // 其他平台（如Web）：直接返回无权限
      return false;
    }

    // 权限永久拒绝时，引导去设置页
    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return status.isGranted;
  }

  /// 3. 核心方法：将模型对应的二维码保存到相册
  static Future<void> saveModelQrToGallery(
    dynamic model, {
    double qrSize = 300,
    Color qrColor = Colors.black,
    Color bgColor = Colors.white,
    String? imageName,
  }) async {
    // 步骤1：检查相册权限
    final hasPermission = await _checkGalleryPermission();
    if (!hasPermission) {
      throw PlatformException(
        code: "PERMISSION_DENIED",
        message: "未获取相册权限，无法保存图片",
      );
    }

    // 步骤2：模型转JSON字符串
    final jsonString = _modelToJsonString(model);
    if (jsonString.length > 2500) {
      debugPrint("警告：JSON字符数${jsonString.length}，可能影响二维码扫描成功率");
    }

    // 步骤3：验证并绘制二维码
    final qrValidation = QrValidator.validate(
      data: jsonString,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );

    if (!qrValidation.isValid) {
      throw PlatformException(
        code: "QR_VALIDATE_ERROR",
        message: "二维码生成失败：${qrValidation.error?.toString()}",
      );
    }

    // 绘制二维码
    final qrPainter = QrPainter(
      data: jsonString,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
      color: qrColor,
    );
    final qrImage = await qrPainter.toImage(qrSize);

    // 步骤4：图片转二进制数据
    final byteData = await qrImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw PlatformException(
        code: "IMAGE_TO_BYTE_ERROR",
        message: "二维码图片转二进制数据失败",
      );
    }
    final imageBytes = byteData.buffer.asUint8List();

    // 步骤5：保存到相册
    final saveResult = await ImageGallerySaver.saveImage(
      imageBytes,
      quality: 100,
      name: imageName ?? "qr_code_${DateTime.now().millisecondsSinceEpoch}",
    );

    // 解析保存结果
    bool saveSuccess = false;
    if (saveResult is Map) {
      saveSuccess = saveResult["isSuccess"] == true;
    } else if (saveResult is bool) {
      saveSuccess = saveResult;
    }

    if (!saveSuccess) {
      throw PlatformException(
        code: "SAVE_IMAGE_ERROR",
        message: "图片保存到相册失败，结果：${saveResult.toString()}",
      );
    }
  }
}
