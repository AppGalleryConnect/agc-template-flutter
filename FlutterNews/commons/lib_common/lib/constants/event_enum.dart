/// 事件类型枚举（对应原 EventEnum，用于全局事件标识）
enum EventEnum {
  /// 全局刷新事件
  globalRefreshEvent,
}

/// 为 EventEnum 扩展字符串值属性
extension EventEnumValue on EventEnum {
  /// 获取枚举对应的事件字符串标识
  String get value {
    switch (this) {
      case EventEnum.globalRefreshEvent:
        return 'globalRefreshEvent';
    }
  }
}
