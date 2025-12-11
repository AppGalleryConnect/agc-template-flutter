import 'package:intl/intl.dart';

class TimeUtils {
  /// 格式化日期时间
  static String formatDate(dynamic date, [String format = 'yyyy-MM-dd HH:mm']) {
    if (date == null) {
      return '';
    }
    DateTime targetDate;
    if (date is DateTime) {
      targetDate = date;
    } else if (date is int) {
      targetDate = DateTime.fromMillisecondsSinceEpoch(date);
    } else if (date is String) {
      targetDate = DateTime.parse(date);
    } else {
      return '';
    }
    try {
      final formatter = DateFormat(_convertFormat(format));
      return formatter.format(targetDate);
    } catch (e) {
      return targetDate.toString();
    }
  }

  /// 获取相对时间
  static String getDateDiff(int dateTimeStamp) {
    if (dateTimeStamp <= 0) {
      return '';
    }
    final now = DateTime.now();
    final target = DateTime.fromMillisecondsSinceEpoch(dateTimeStamp);
    if (target.isAfter(now)) {
      return '';
    }
    final diffSeconds = now.difference(target).inSeconds;
    if (diffSeconds < 60) {
      return '刚刚';
    }
    final diffMinutes = now.difference(target).inMinutes;
    if (diffMinutes < 60) {
      return '$diffMinutes分钟前';
    }
    final diffHours = now.difference(target).inHours;
    if (diffHours < 24) {
      return '$diffHours小时前';
    }
    final targetDate = DateTime(target.year, target.month, target.day);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final beforeYesterday = today.subtract(const Duration(days: 2));
    if (targetDate == yesterday) {
      return '昨天';
    }
    if (targetDate == beforeYesterday) {
      return '前天';
    }
    final diffDays = now.difference(target).inDays;
    if (diffDays < 7) {
      return '$diffDays天前';
    }
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(target);
  }

  /// 获取消息相对时间
  static String handleMsgTimeDiff(int dateTimeStamp) {
    if (dateTimeStamp <= 0) {
      return '';
    }
    final time = DateTime.fromMillisecondsSinceEpoch(dateTimeStamp);
    final now = DateTime.now();
    final isToday =
        time.year == now.year && time.month == now.month && time.day == now.day;
    final isThisYear = time.year == now.year;
    if (isToday) {
      final formatter = DateFormat('HH:mm');
      return formatter.format(time);
    } else if (isThisYear) {
      final formatter = DateFormat('MM-dd');
      return formatter.format(time);
    } else {
      final formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(time);
    }
  }

  /// 处理视频时长
  static String handleDuration(int? duration) {
    if (duration == null || duration <= 0) {
      return '';
    }
    final sec = duration ~/ 1000;
    final hour = sec ~/ 3600;
    final min = (sec % 3600) ~/ 60;
    final seconds = sec % 60;
    if (hour > 0) {
      return '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${min.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 将自定义格式转换为intl包支持的格式
  static String _convertFormat(String format) {
    return format
        .replaceAll('YYYY', 'yyyy')
        .replaceAll('MM', 'MM')
        .replaceAll('DD', 'dd')
        .replaceAll('HH', 'HH')
        .replaceAll('mm', 'mm')
        .replaceAll('ss', 'ss');
  }
}
