import 'package:intl/intl.dart';
import 'dart:core';

/// 时间工具类（对应原 TimeUtils）
class TimeUtils {
  /// 格式化日期
  static String formatDate(
    dynamic date, {
    String format = 'yyyy-MM-dd HH:mm',
  }) {
    if (date == null) return '';

    DateTime targetDate;
    if (date is DateTime) {
      targetDate = date;
    } else if (date is num) {
      targetDate = DateTime.fromMillisecondsSinceEpoch(date.toInt());
    } else if (date is String) {
      if (DateTime.tryParse(date) != null) {
        targetDate = DateTime.parse(date);
      } else {
        return '';
      }
    } else {
      return '';
    }

    return DateFormat(format).format(targetDate);
  }

  /// 获取相对时间（如：刚刚、3分钟前、昨天）
  static String getDateDiff(int dateTimeStamp) {
    if (dateTimeStamp <= 0) return '';
    final now = DateTime.now();
    final target = DateTime.fromMillisecondsSinceEpoch(dateTimeStamp);
    if (target.isAfter(now)) return '';
    final diff = now.difference(target);
    final diffSeconds = diff.inSeconds;
    final diffMinutes = diff.inMinutes;
    final diffHours = diff.inHours;
    final diffDays = diff.inDays;
    if (diffSeconds < 60) {
      return '刚刚';
    } else if (diffMinutes < 60) {
      return '$diffMinutes分钟前';
    } else if (diffHours < 24) {
      return '$diffHours小时前';
    } else if (isYesterday(target)) {
      return '昨天';
    } else if (isDayBeforeYesterday(target)) {
      return '前天';
    } else if (diffDays < 7) {
      return '$diffDays天前';
    } else {
      return formatDate(target, format: 'yyyy-MM-dd');
    }
  }

  /// 处理消息相对时间
  static String handleMsgTimeDiff(int dateTimeStamp) {
    if (dateTimeStamp <= 0) return '';
    final time = DateTime.fromMillisecondsSinceEpoch(dateTimeStamp);
    final now = DateTime.now();
    final isToday =
        time.year == now.year && time.month == now.month && time.day == now.day;
    final isThisYear = time.year == now.year;
    if (isToday) {
      return DateFormat('HH:mm').format(time);
    } else if (isThisYear) {
      return DateFormat('MM-dd').format(time);
    } else {
      return DateFormat('yyyy-MM-dd').format(time);
    }
  }

  /// 处理视频时长（毫秒转时分秒）
  static String handleDuration(int? duration) {
    if (duration == null || duration <= 0) return '';
    final int totalSeconds = (duration / 1000).floor();
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;
    final String h = hours.toString().padLeft(2, '0');
    final String m = minutes.toString().padLeft(2, '0');
    final String s = seconds.toString().padLeft(2, '0');
    return hours > 0 ? '$h:$m:$s' : '$m:$s';
  }

  /// 判断是否昨天
  static bool isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// 判断是否前天
  static bool isDayBeforeYesterday(DateTime date) {
    final now = DateTime.now();
    final dayBeforeYesterday = DateTime(now.year, now.month, now.day - 2);
    return date.year == dayBeforeYesterday.year &&
        date.month == dayBeforeYesterday.month &&
        date.day == dayBeforeYesterday.day;
  }
}
