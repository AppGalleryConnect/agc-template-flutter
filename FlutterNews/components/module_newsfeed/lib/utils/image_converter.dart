import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// 辅助工具：将ui.Image转为可显示的Image组件
class ImageConverter {
  // 将ui.Image转为Image组件
  static Future<Image?> convertUiImageToWidget(ui.Image? uiImage) async {
    if (uiImage == null) return null;

    // 步骤1：将ui.Image转为字节数据（Uint8List）
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final uint8List = byteData.buffer.asUint8List();

    // 步骤2：用Image.memory创建可显示的Image组件
    return Image.memory(
      uint8List,
      fit: BoxFit.contain,
    );
  }
}
