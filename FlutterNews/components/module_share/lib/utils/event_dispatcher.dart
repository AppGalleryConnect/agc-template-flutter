import 'dart:async';
import 'dart:ui';
import 'package:event_bus/event_bus.dart';

class ShareEventDispatcher {
  static final ShareEventDispatcher instance = ShareEventDispatcher._internal();
  VoidCallback? closeCallback;

  ShareEventDispatcher._internal();

  void triggerClose() => closeCallback?.call();
}

/// EventBus 工具类（单例模式，全局唯一实例）
class EventBusUtils {
  // 1. 私有静态实例（确保只有一个）
  static EventBus? _instance;

  // 2. 私有构造函数（禁止外部 new 实例）
  EventBusUtils._();

  // 3. 公开方法：获取全局唯一的 EventBus 实例
  static EventBus get instance {
    _instance ??= EventBus();
    return _instance!;
  }

  // 4. 简化方法：发送事件（避免外部重复写 instance.fire）
  static void sendEvent(dynamic event) {
    instance.fire(event);
  }

  // 5. 简化方法：监听事件（返回订阅对象，方便取消）
  static StreamSubscription listenEvent<T>(void Function(T event) onData) {
    return instance.on<T>().listen(onData);
  }
}

/// --------------- 定义分享相关事件（可选：统一放在工具类同文件）---------------
class ShareButtonClickEvent {
  final String buttonName;

  ShareButtonClickEvent(this.buttonName);
}

class CommentDeletedEvent {
  final bool isRefresh; 

  CommentDeletedEvent(this.isRefresh);
}

class NewLikeEvent {
  final bool isLike; 
  final String? cmd;
  NewLikeEvent(this.isLike,this.cmd);
}

class CommentRefreshEvent {
  final bool isRefreshComment; 
  CommentRefreshEvent(this.isRefreshComment);
}
