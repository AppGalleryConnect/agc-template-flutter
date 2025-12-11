import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SysShareOptions {
  final String title;
  final String createTime;

  const SysShareOptions({required this.title, required this.createTime});
}

class ShareEventDispatcher {
  static void dispatchToClose() {
    
  }
}

class PosterShare {
  static final PosterShare _instance = PosterShare._internal();
  BuildContext? _context;

  factory PosterShare() {
    return _instance;
  }

  PosterShare._internal();

  void setContext(BuildContext context) {
    _context = context;
  }

  void copy() {
    const textToCopy = 'www.vmall.com/index.html?cid=128688';

    Clipboard.setData(const ClipboardData(text: textToCopy)).then((_) {
      _showToast('复制成功');
    }).catchError((error) {
      _showToast('复制失败');
    });
  }

  void _showToast(String message) {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}