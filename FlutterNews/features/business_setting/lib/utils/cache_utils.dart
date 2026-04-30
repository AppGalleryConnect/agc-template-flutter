import 'dart:io';
import 'dart:math';
import 'package:lib_common/lib_common.dart';


const String TAG = '[CacheUtils]';

/// 缓存管理工具类
class CacheUtils {
  static Future<String> getCache() async {
    try {
      String totalSize = await NativeCacheUtils.getNativeCache();
      return totalSize;
    } catch (e) {
      return '0.0M';
    }
  }

  static Future<void> clearCache() async {
    try {
      await NativeCacheUtils.clearNativeCache();
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> _getDirectorySize(Directory dir) async {
    int size = 0;
    if (await dir.exists()) {
      await for (FileSystemEntity entity in dir.list(recursive: true)) {
        if (entity is File) {
          size += await entity.length();
        }
      }
    }
    return size;
  }

  static Future<void> _clearDirectory(Directory dir) async {
    if (await dir.exists()) {
      await for (FileSystemEntity entity in dir.list()) {
        if (entity is Directory) {
          await entity.delete(recursive: true);
        } else if (entity is File) {
          await entity.delete();
        }
      }
    }
  }

  static String formatFileSize(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
