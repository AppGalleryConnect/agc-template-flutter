import 'dart:math';

/// 安全随机数生成类
class SafeRandomGenerate {
  static int generate() {
    final random = Random.secure();
    final bytes = List<int>.generate(2, (_) => random.nextInt(256));
    final hexString = bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();
    var decimalValue = 0;
    const hexChars = '0123456789ABCDEF';
    for (var char in hexString.split('')) {
      final value = hexChars.indexOf(char);
      decimalValue = decimalValue * 16 + value;
    }
    return decimalValue.abs();
  }
}
