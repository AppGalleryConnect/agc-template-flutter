import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:lib_common/lib_common.dart';

class CallFormCardData {
  final int id;
  final String pageUrl;
  final String newsId;
  final int newsType;

  const CallFormCardData({
    this.id = 0,
    this.pageUrl = '',
    this.newsId = '',
    this.newsType = 0,
  });

  factory CallFormCardData.fromJson(Map<dynamic, dynamic> json) {
    return CallFormCardData(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      pageUrl: json['pageUrl']?.toString() ?? '',
      newsId: json['newsId']?.toString() ?? '',
      newsType: json['newsType'] is int
          ? json['newsType']
          : int.tryParse(json['newsType'].toString()) ?? 0,
    );
  }

  bool get isValid {
    return newsId.isNotEmpty || id > 0;
  }

  static const CallFormCardData empty = CallFormCardData();

  @override
  String toString() {
    return 'RequestListData(id: $id, newsId: $newsId, pageUrl: $pageUrl, newsType: $newsType)';
  }
}

/// 服务卡片/AppLink工具类
class FormCardUtils {
  static const MethodChannel _formCardChannel =
      MethodChannel('com.news.flutter/formCardChannel');

  static final ValueNotifier<dynamic> formCardDataNotifier =
      ValueNotifier(null);

  static Future<void> initFormCard() async {
    _formCardChannel.setMethodCallHandler(_flutterMethodHandler);
  }

  static Future<void> _flutterMethodHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'getFormCardData':
        Logger.info('getFormCardData，结果: ${methodCall.arguments}');
        formCardDataNotifier.value = methodCall.arguments;
        break;
      case 'getFormAppLinkingData':
        Logger.info('getFormAppLinkingData: ${methodCall.arguments}');
        formCardDataNotifier.value = methodCall.arguments;
        break;
      default:
        Logger.info('未处理的MethodChannel方法：${methodCall.method}');
    }
  }

  static Future<CallFormCardData> callFormCardData() async {
    try {
      final dynamic result =
          await _formCardChannel.invokeMethod('callFormCardData');
      Logger.info('调用callFormCardData成功：$result');
      return CallFormCardData.fromJson(result);
    } catch (e) {
      Logger.error('调用callFormCardData失败：$e');
      return CallFormCardData.empty;
    }
  }

  static Future<CallFormCardData> callFormAppLinkingData() async {
    try {
      final dynamic result =
          await _formCardChannel.invokeMethod('callFormAppLinkingData');
      Logger.info('调用callFormAppLinkingData成功：$result');
      return CallFormCardData.fromJson(result);
    } catch (e) {
      Logger.error('调用callFormCardData失败：$e');
      return CallFormCardData.empty;
    }
  }
}
