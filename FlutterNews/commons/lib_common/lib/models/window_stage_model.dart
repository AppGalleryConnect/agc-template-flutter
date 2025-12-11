import 'package:flutter/foundation.dart';

/// 窗口生命周期事件类型
enum WindowStageEventType {
  created,
  destroyed,
  resumed,
  paused,
  sizeChanged,
}

/// 窗口生命周期模型
class WindowStageModel with ChangeNotifier {
  /// 窗口生命周期事件监听器集合
  final Map<String, Function(WindowStageEventType)> _windowStageEventListeners =
      {};

  /// 获取所有监听器
  Map<String, Function(WindowStageEventType)> get windowStageEventListeners =>
      Map.unmodifiable(_windowStageEventListeners);

  /// 添加窗口生命周期监听器
  void addWindowStageListener(
      String key, Function(WindowStageEventType) listener) {
    if (!_windowStageEventListeners.containsKey(key)) {
      _windowStageEventListeners[key] = listener;
      notifyListeners();
    }
  }

  /// 移除窗口生命周期监听器
  void removeWindowStageListener(String key) {
    if (_windowStageEventListeners.containsKey(key)) {
      _windowStageEventListeners.remove(key);
      notifyListeners();
    }
  }

  /// 触发窗口生命周期事件
  void dispatchWindowStageEvent(WindowStageEventType type) {
    for (final listener in _windowStageEventListeners.values) {
      listener(type);
    }
  }
}
