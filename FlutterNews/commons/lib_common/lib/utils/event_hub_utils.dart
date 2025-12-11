import 'package:event_bus/event_bus.dart';

/// 事件总线工具类
class EventHubUtils {
  /// 事件总线实例
  final EventBus _eventBus = EventBus();

  /// 单例实例
  static EventHubUtils? _instance;

  /// 私有构造函数
  EventHubUtils._internal();

  /// 获取单例实例
  static EventHubUtils getInstance() {
    _instance ??= EventHubUtils._internal();
    return _instance!;
  }

  /// 发送事件
  void emit(dynamic eventKey, [List<Object> args = const []]) {
    _eventBus.fire(_EventPackage(eventKey: eventKey, args: args));
  }

  void on(dynamic eventKey, Function(List<Object>) callback) {
    _eventBus.on<_EventPackage>().listen((package) {
      if (package.eventKey == eventKey) {
        callback(package.args);
      }
    });
  }

  void off(dynamic eventKey) {}
}

/// 事件包装类
class _EventPackage {
  final dynamic eventKey;
  final List<Object> args;
  _EventPackage({
    required this.eventKey,
    required this.args,
  });
}
