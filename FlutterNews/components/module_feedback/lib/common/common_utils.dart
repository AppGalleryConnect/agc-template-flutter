import 'package:intl/intl.dart';

class CommonUtils {
  static final DateFormat weekFormat = DateFormat('EEEE', 'zh_CN');

  static String handleDateTime(int dateTime) {
    final date = DateTime.fromMillisecondsSinceEpoch(dateTime);
    final dateStr = '${date.year}.${padStart(date.month)}.${padStart(date.day)}';
    final weekStr = weekFormat.format(date).substring(0, 3); 
    final timeStr = '${padStart(date.hour)}:${padStart(date.minute)}:${padStart(date.second)}';

    return '$dateStr $weekStr $timeStr';
  }

  static String padStart(int value) {
    return value.toString().padLeft(2, '0');
  }
}