import 'package:flutter/material.dart';

class WeChatMaskPainter extends CustomPainter {
  final double frameSize;
  final double frameTop;
  final double screenWidth;
  final double screenHeight;

  WeChatMaskPainter({
    required this.frameSize,
    required this.frameTop,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final frameLeft = (screenWidth - frameSize) / 2;
    canvas.drawRect(Rect.fromLTWH(0, 0, screenWidth, frameTop), paint);
    canvas.drawRect(Rect.fromLTWH(0, frameTop, frameLeft, frameSize), paint);
    canvas.drawRect(
      Rect.fromLTWH(frameLeft + frameSize, frameTop,
          screenWidth - (frameLeft + frameSize), frameSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, frameTop + frameSize, screenWidth,
          screenHeight - (frameTop + frameSize)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant WeChatMaskPainter oldDelegate) => true;
}

class CornerMarkerPainter extends CustomPainter {
  final double width;
  final Color color;
  final bool isTopLeft;
  final bool isTopRight;
  final bool isBottomLeft;
  final bool isBottomRight;
  CornerMarkerPainter({
    required this.width,
    required this.color,
    this.isTopLeft = false,
    this.isTopRight = false,
    this.isBottomLeft = false,
    this.isBottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    if (isTopLeft) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, width), paint);
      canvas.drawRect(
          Rect.fromLTWH(0, 0, width, size.height - size.height / 3), paint);
    } else if (isTopRight) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, width), paint);
      canvas.drawRect(
          Rect.fromLTWH(
              size.width - width, 0, width, size.height - size.height / 3),
          paint);
    } else if (isBottomLeft) {
      canvas.drawRect(
          Rect.fromLTWH(0, size.height - width, size.width, width), paint);
      canvas.drawRect(
          Rect.fromLTWH(
              0, size.height / 3, width, size.height - size.height / 3),
          paint);
    } else if (isBottomRight) {
      canvas.drawRect(
          Rect.fromLTWH(0, size.height - width, size.width, width), paint);
      canvas.drawRect(
        Rect.fromLTWH(size.width - width, size.height / 3, width,
            size.height - size.height / 3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CornerMarkerPainter oldDelegate) => true;
}
