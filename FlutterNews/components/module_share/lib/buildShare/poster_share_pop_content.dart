
import 'dart:typed_data'; 
import 'package:flutter/material.dart';
import '../model/share_model.dart';

class PosterSharePop extends StatelessWidget {
  final bool sharePopShow;
  final ShareOptions qrCodeInfo;
  final Uint8List pixmap;
  final VoidCallback onClose;
  final Function(bool) popClose;

  const PosterSharePop({
    super.key,
    required this.sharePopShow,
    required this.qrCodeInfo,
    required this.pixmap,
    required this.onClose,
    required this.popClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('Poster Share Pop'),
    );
  }
}
