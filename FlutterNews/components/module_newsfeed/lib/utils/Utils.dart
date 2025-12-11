import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/recommend_model.dart';

// 尺寸模型（替代原 Size 类，避免命名冲突）
class ImageSize {
  final double width;
  final double height;

  ImageSize(this.width, this.height);
}

// 从URL提取尺寸参数（w/h）并转为Flutter适配单位
double? _extractDimension(String url, String dimensionKey) {
  // 正则匹配 "w=数字" 或 "h=数字"
  final regExp = RegExp('$dimensionKey=(\\d+)');
  final match = regExp.firstMatch(url);
  if (match != null && match.groupCount >= 1) {
    final value = double.tryParse(match.group(1) ?? '');
    if (value != null) {
      // 原px2vp：HarmonyOS像素转虚拟像素，Flutter中直接用px（或根据设备密度调整）
      return value;
    }
  }
  return null;
}

/// 计算图片尺寸（通用版）
ImageSize calculateDimensions(String? url) {
  if (url == null || url.isEmpty) {
    return ImageSize(0, 0);
  }

  // 提取URL中的宽高
  final width = _extractDimension(url, 'w') ?? 0;
  final height = _extractDimension(url, 'h') ?? 0;
  final aspectRatio = width > 0 && height > 0 ? width / height : 0;

  // 根据宽高比适配尺寸
  if (aspectRatio < 1) {
    // 竖图
    return ImageSize(220, 220 / (2 / 3));
  } else if (aspectRatio == 1) {
    // 正方形图
    return ImageSize(280, 280);
  } else if (aspectRatio > 1) {
    // 横图
    return ImageSize(327, 327 / 1.5);
  } else {
    // 异常情况：视频用横图尺寸，其他用竖图尺寸
    return url.contains('.mp4')
        ? ImageSize(327, 327 / 1.5)
        : ImageSize(220, 220 / (2 / 3));
  }
}

/// 计算用户相关图片尺寸（比通用版窄16单位）
ImageSize calculateDimensionsUser(String url) {
  // 提取URL中的宽高
  final width = _extractDimension(url, 'w') ?? 0;
  final height = _extractDimension(url, 'h') ?? 0;
  final aspectRatio = width > 0 && height > 0 ? width / height : 0;

  // 根据宽高比适配尺寸（比通用版窄16）
  if (aspectRatio < 1) {
    // 竖图
    return ImageSize(220 - 16, (220 - 16) / (2 / 3));
  } else if (aspectRatio == 1) {
    // 正方形图
    return ImageSize(280 - 16, 280 - 16);
  } else {
    // 横图
    return ImageSize(327 - 16, (327 - 16) / 1.5);
  }
}

/// 多图布局尺寸计算（根据组件宽度和图片数量）
/// [context]：Flutter上下文（用于获取组件尺寸）
/// [componentId]：组件标识（用于缓存宽度）
/// [num]：图片数量
double twoImagesSize({
  required BuildContext context,
  required String componentId,
  required int num,
}) {
  // 1. 获取组件宽度（模拟原getRectangleById）
  double currentWidth = MediaQuery.of(context).size.width;
  // （可选）如需缓存宽度，可使用Flutter的SharedPreferences替代AppStorage
  // 示例：SharedPreferences prefs = await SharedPreferences.getInstance();
  // currentWidth = prefs.getDouble(componentId) ?? currentWidth;
  // await prefs.setDouble(componentId, currentWidth);

  // 2. 计算单图尺寸（原逻辑：减去间距16，按数量均分）
  final adaptedWidth = currentWidth - 16; // 原px2vp已简化，直接用当前宽度
  if (num % 3 == 0 || num >= 6) {
    return adaptedWidth / 3;
  } else {
    return adaptedWidth / 2;
  }
}

/// 用户页面多图布局尺寸计算（根据屏幕宽度和图片数量）
double twoImagesSizeUser(int num) {
  final mediaQueryData =
      MediaQueryData.fromView(WidgetsBinding.instance.window);
  final screenWidth = mediaQueryData.size.width;

  if (num == 9) {
    return (screenWidth - 24 - 24 - 32) / 3;
  } else if (num >= 4) {
    return (screenWidth - 24 - 16 - 32) / 2;
  } else {
    return (screenWidth - 24 - 16 - 32) / num;
  }
}

Future<void> flutterSystemShare(String content) async {
 await Clipboard.setData(ClipboardData(text: content));
}

/// 时间差格式化（替代原getDateDiff，无dayjs依赖）
String getDateDiff(int dateTimeStamp) {
  if (dateTimeStamp <= 0) return '';

  final targetTime = DateTime.fromMillisecondsSinceEpoch(dateTimeStamp);
  final now = DateTime.now();

  if (targetTime.isAfter(now)) return '';

  final diffSeconds = now.difference(targetTime).inSeconds;

  if (diffSeconds < 60) {
    return '刚刚';
  }

  final diffMinutes = diffSeconds ~/ 60;
  if (diffMinutes < 60) {
    return '$diffMinutes分钟前';
  }

  final diffHours = diffMinutes ~/ 60;
  if (diffHours < 24) {
    return '$diffHours小时前';
  }

  final diffDays = diffHours ~/ 24;

  if (diffDays == 1) {
    return '昨天';
  }

  if (diffDays == 2) {
    return '前天';
  }

  if (diffDays < 7) {
    return '$diffDays天前';
  }

  return '${targetTime.year}-${_twoDigits(targetTime.month)}-${_twoDigits(targetTime.day)}';
}

// 辅助方法：数字补零（如1→01）
String _twoDigits(int n) => n.toString().padLeft(2, '0');

/// 数字格式化（超过1000显示为Xk，如1500→1.5k）
String formatToK(int number) {
  if (number.abs() < 1000) {
    return number.toString();
  }
  final valueInK = (number / 1000).toStringAsFixed(1);
  return valueInK.endsWith('.0')
      ? valueInK.replaceAll('.0', 'k')
      : '${valueInK}k';
}

/// 获取动态封面图URL（优先surfaceUrl，其次picVideoUrl）
String? handlerCoverImage(FeedCardInfo feedCardInfo) {
  if (feedCardInfo.postMedias.isEmpty) return null;
  final firstMedia = feedCardInfo.postMedias.first;
  return firstMedia.thumbnailUrl.isNotEmpty
      ? firstMedia.thumbnailUrl
      : firstMedia.url;
}
