class FormatCount {
  static String formatToK(num number) {
    if (number.abs() < 1000) {
      return number.toString();
    }
    final valueInK = (number / 1000).toStringAsFixed(1);
    return valueInK.endsWith('.0')
        ? '${valueInK.substring(0, valueInK.length - 2)}k'
        : '${valueInK}k';
  }

  static String formatNumberToW(num? num) {
    if (num == null || num == 0) {
      return '0';
    }
    if (num >= 10000) {
      return '${(num / 10000).toStringAsFixed(1)}万';
    }
    return num.toString();
  }
}
