import 'dart:developer';

class Logger {
  static int domain = 0xff00;
  static String prefix = 'ComprehensiveNews';
  static String format = '%s, %s';

  /// 调试日志
  static void debug([String? tag, String? message]) {
    if (tag != null && message != null) {
      log('$tag: $message', name: prefix, level: 0);
    } else if (tag != null) {
      log(tag, name: prefix, level: 0);
    }
  }

  /// 信息日志
  static void info([String? tag, String? message]) {
    if (tag != null && message != null) {
      log('$tag: $message', name: prefix, level: 1);
    } else if (tag != null) {
      log(tag, name: prefix, level: 1);
    }
  }

  /// 警告日志
  static void warn([String? tag, String? message]) {
    if (tag != null && message != null) {
      log('$tag: $message', name: prefix, level: 2);
    } else if (tag != null) {
      log(tag, name: prefix, level: 2);
    }
  }

  /// 错误日志
  static void error([String? tag, String? message]) {
    if (tag != null && message != null) {
      log('$tag: $message', name: prefix, level: 3);
    } else if (tag != null) {
      log(tag, name: prefix, level: 3);
    }
  }
}
