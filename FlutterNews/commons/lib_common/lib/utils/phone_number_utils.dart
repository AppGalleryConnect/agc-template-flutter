import 'dart:core';

/// 手机号码工具类
class PhoneNumberUtils {
  /// 验证手机号格式是否正确
  static bool isPhoneNumberValid(String phone) {
    final RegExp phoneReg = RegExp(r'^[1][3-9][0-9]{9}$');
    return phoneReg.hasMatch(phone);
  }

  static String encryptPhone(String phone, [String maskChar = '*']) {
    if (isPhoneNumberValid(phone)) {
      return phone.replaceAllMapped(
        RegExp(r'^(\d{3})(\d{4})(\d{4})$'),
        (Match match) => '${match.group(1)}${maskChar * 4}${match.group(3)}',
      );
    }
    return phone;
  }
}
