// 扩展功能：为Widget添加点击功能
import 'package:flutter/material.dart';

extension ClickableExtension on Widget {
  Widget clickable(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
}
