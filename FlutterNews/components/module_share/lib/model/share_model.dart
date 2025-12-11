import 'dart:typed_data';
import 'dart:ui';

/// 分享内容参数模型
class ShareOptions {
  final String id;
  final String title;
  final String articleFrom;

  ShareOptions({
    required this.id,
    required this.title,
    required this.articleFrom,
  });
}

/// 分享面板参数模型
class ShareSheetParams {
  final Function(bool, Uint8List) onPost;
  final ShareOptions qrCodeInfo;
  final Function(String)? onOptionTap; 

  ShareSheetParams({
    required this.onPost,
    required this.qrCodeInfo,
    this.onOptionTap,
  });
}


/// 分享类型模型
class ShareKinds {
  final String id;
  final String name;
  final String icon;

  ShareKinds({
    required this.id,
    required this.name,
    required this.icon,
  });
}

/// 分享弹窗配置选项
class SheetOptions {
  final String title;
  final Color backgroundColor;
  final bool showClose;

  SheetOptions({
    required this.title,
    required this.backgroundColor,
    required this.showClose,
  });
}

/// 海报分享弹窗参数
class PosterSharePopParams {
  final bool sharePopShow;
  final ShareOptions qrCodeInfo;
  final Uint8List pixmap;
  final VoidCallback onClose;
  final Function(bool) popClose;

  PosterSharePopParams({
    required this.sharePopShow,
    required this.qrCodeInfo,
    required this.pixmap,
    required this.onClose,
    required this.popClose,
  });
}
