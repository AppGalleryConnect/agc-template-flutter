import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  // 指示器高度
  final double height;
  // 指示器颜色
  final Color color;
  // 指示器宽度
  final double width;

  const CustomTabIndicator({
    this.height = 2.0,
    this.color = Colors.blue,
    this.width = 30.0, // 固定宽度
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _EqualWidthTabIndicatorPainter(
      decoration: this,
      onChanged: onChanged,
    );
  }
}

class _EqualWidthTabIndicatorPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _EqualWidthTabIndicatorPainter({
    required this.decoration,
    VoidCallback? onChanged,
  }) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    // 获取标签的中心位置
    final center = offset + Offset(
      configuration.size!.width / 2,
      configuration.size!.height - decoration.height / 2,
    );

    // 绘制固定宽度的指示器
    final rect = Rect.fromCenter(
      center: center,
      width: decoration.width,
      height: decoration.height,
    );

    final paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(decoration.height / 2)),
      paint,
    );
  }
}