import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 二维码生成工具类
/// 功能：通过模型生成二维码图片（ui.Image）
class QrCodeGenerator {
  /// 生成二维码图片
  /// [model]：传入的模型（必须实现toJson()方法）
  /// [size]：二维码尺寸（默认300）
  /// [foregroundColor]：二维码颜色（默认黑色）
  /// [backgroundColor]：背景色（默认白色）
  static Future<ui.Image?> generateQrImage(
      dynamic model, {
        double size = 300,
        Color foregroundColor = Colors.black,
        Color backgroundColor = Colors.white,
      }) async {
    try {
      // 1. 模型转JSON字符串
      final jsonString = json.encode(model.toJson());

      // 2. 验证二维码数据有效性
      final qrValidationResult = QrValidator.validate(
        data: jsonString,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
      );

      if (!qrValidationResult.isValid) {
        return null;
      }

      // 3. 绘制二维码并返回ui.Image
      final qrPainter = QrPainter(
        data: jsonString,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        color: foregroundColor,
      );

      return await qrPainter.toImage(size);
    } catch (e) {
      return null;
    }
  }
}