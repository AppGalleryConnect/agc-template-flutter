import 'package:flutter/services.dart';
import 'package:lib_common/lib_common.dart';

/// 推送工具类
class PushUtils {
  static const String _TAG = 'PushUtils';
  static const MethodChannel _notificationChannel =
      MethodChannel('com.news.flutter/notification');
  static const MethodChannel _pushChannel =
      MethodChannel('com.news.flutter/push');
  static Future<bool> requestNotificationPermission() async {
    try {
      final bool? result =
          await _notificationChannel.invokeMethod('requestEnableNotification');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 获取Push Token
  static Future<String> getPushToken() async {
    try {
      final String? token = await _pushChannel.invokeMethod('getToken');
      return token ?? '';
    } catch (e) {
      return '';
    }
  }

  static Future<void> pushMessage(List<dynamic> articleList) async {
    if (articleList.isEmpty) {
      return;
    }

    try {
      final randomIndex =
          DateTime.now().millisecondsSinceEpoch % articleList.length;
      final article = articleList[randomIndex];
      final Map<String, dynamic> pushParams = {
        'title': '新闻模板',
        'body': article['title'] ?? '',
        'image': article['postImgList']?[0]?['picVideoUrl'] ?? '',
        'articleId': article['id'] ?? '',
        'authorId': article['authorId'] ?? '',
        'type': article['type'] ?? '',
      };
      final bool? result =
          await _pushChannel.invokeMethod('pushMessage', pushParams);

      if (result == true) {
        Logger.info(_TAG, '推送成功');
      } else {
        Logger.info(_TAG, '推送失败');
      }
    } catch (e) {
      Logger.error(_TAG, '推送消息失败: $e');
    }
  }

  /// 随机推送消息
  static Future<void> randomPushMessage(List<dynamic> articleList) async {
    await pushMessage(articleList);
  }

  /// 检查并发送推送通知
  static Future<void> sendPushNotice({
    required SettingModel settingInfo,
    required List<dynamic> articleList,
  }) async {
    if (settingInfo.pushSwitch) {
      final bool hasPermission = await requestNotificationPermission();
      if (hasPermission) {
        final String token = await getPushToken();
        if (token.isNotEmpty) {
          await randomPushMessage(articleList);
        } else {
          Logger.info(_TAG, 'Push Token为空，无法推送');
        }
      } else {
        Logger.info(_TAG, '用户拒绝通知权限');
      }
    } else {
      Logger.info(_TAG, '推送开关已关闭');
    }
  }
}
