class NumberFormatter {
  /// 将数字格式化为带单位的字符串（如 1200→1.2k，12000→1.2w）
  static String formatCompact(int number) {
    // 处理负数（如果有需求）
    if (number < 0) {
      return '-${formatCompact(-number)}';
    }

    // 万级（10000及以上）
    if (number >= 10000) {
      final value = number / 10000;
      // 保留一位小数（如 12000→1.2w，10000→1w）
      return value % 1 == 0 ? '${value.toInt()}w' : '${value.toStringAsFixed(1)}w';
    }

    // 千级（1000-9999）
    if (number >= 1000) {
      final value = number / 1000;
      // 保留一位小数（如 1200→1.2k，1000→1k）
      return value % 1 == 0 ? '${value.toInt()}k' : '${value.toStringAsFixed(1)}k';
    }

    // 千级以下直接返回原数字
    return number.toString();
  }
}