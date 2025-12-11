/// 全局键枚举
enum GlobalKey {
  loginFlag,
}

/// 为 GlobalKey 扩展属性，绑定对应的字符串值
extension GlobalKeyStringValue on GlobalKey {
  /// 获取枚举对应的业务字符串（与原枚举值完全一致）
  String get value {
    switch (this) {
      case GlobalKey.loginFlag:
        return 'login_flag'; // 保持原字符串值不变
    }
  }
}
