import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:lib_common/utils/logger.dart';

class CallShortcutData {
  final dynamic data;
  final String? pageName;

  CallShortcutData({this.data, this.pageName});

  factory CallShortcutData.fromJson(dynamic json) {
    return CallShortcutData(
      data: json,
      pageName: json?['pageName'],
    );
  }

  static CallShortcutData get empty => CallShortcutData(data: null, pageName: null);
}

typedef FormCardDataChangedCallback = void Function(dynamic data);

class ShortcutUtils {
  static const MethodChannel _shortcutChannel =
      MethodChannel('com.news.flutter/shortcutChannel');

  static final ValueNotifier<dynamic> formCardDataNotifier =
      ValueNotifier(null);

  static final List<FormCardDataChangedCallback> _listeners = [];

  static bool _isListening = false;

  static Future<void> initShortcut() async {
    _shortcutChannel.setMethodCallHandler(_flutterMethodHandler);
    _initNotifierListener();
  }

  static void _initNotifierListener() {
    if (_isListening) return;

    formCardDataNotifier.addListener(() {
      final newValue = formCardDataNotifier.value;
      if (newValue != null) {
        _broadcastDataChanged(newValue);
      }
    });
    _isListening = true;
  }

  static void _broadcastDataChanged(dynamic data) {
    Logger.info('广播表单卡片数据变化: $data');
    for (final callback in _listeners) {
      try {
        callback(data);
      } catch (e) {
        Logger.error('监听器执行失败: $e');
      }
    }
  }

  static void addFormCardDataListener(FormCardDataChangedCallback callback) {
    if (!_listeners.contains(callback)) {
      _listeners.add(callback);
      Logger.info('添加表单卡片监听器成功，当前监听器数量: ${_listeners.length}');
    }
  }

  static void removeFormCardDataListener(FormCardDataChangedCallback callback) {
    if (_listeners.contains(callback)) {
      _listeners.remove(callback);
      Logger.info('移除表单卡片监听器成功，当前监听器数量: ${_listeners.length}');
    }
  }

  static void clearAllListeners() {
    _listeners.clear();
    _isListening = false;
    Logger.info('清空所有表单卡片监听器');
  }

  static Future<void> _flutterMethodHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'getShortcutData':
        formCardDataNotifier.value = methodCall.arguments;
        break;
      default:
        Logger.info('未处理的MethodChannel方法：${methodCall.method}');
    }
  }

  static Future<CallShortcutData> callShortcutData() async {
    try {
      final dynamic result =
          await _shortcutChannel.invokeMethod('callShortcutData');
      print('调用callShortcutData成功：$result');
      return CallShortcutData.fromJson(result);
    } catch (e) {
      Logger.error('调用callShortcutData失败：$e');
      return CallShortcutData.empty;
    }
  }
}
