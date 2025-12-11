import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 存储键名枚举
enum StorageKeys {
  notificationEnabled('notification_enabled'),
  darkModeEnabled('dark_mode_enabled'),
  listFontSizeLevel('list_font_size_level'),
  detailFontSizeLevel('detail_font_size_level'),
  nonWlanTraffic('non_wlan_traffic'),
  nonWlanPlayReminder('non_wlan_play_reminder'),
  improveExperienceWithMobileData('improve_experience_with_mobile_data'),
  autoSlideDown('auto_slide_down'),
  autoPlayRecommended('auto_play_recommended'),
  personalizedRecommendationEnabled('personalized_recommendation_enabled'),
  userInfo('user_info'),
  userIsLogin('user_is_login'),
  userName('user_name'),
  userAvatar('user_avatar'),
  userPhone('user_phone'),
  feedbackRecords('feedback_records');

  final String key;
  const StorageKeys(this.key);
}

/// 统一的持久化服务类
class PersistenceService {
  static PersistenceService? _instance;
  SharedPreferences? _prefs;
  PersistenceService._internal();
  factory PersistenceService() {
    _instance ??= PersistenceService._internal();
    return _instance!;
  }
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// 确保_prefs已初始化的辅助方法
  Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await init();
    }
  }

  Future<bool> getBool(StorageKeys key, {bool defaultValue = false}) async {
    try {
      await _ensureInitialized();
      return _prefs?.getBool(key.key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  Future<bool> setBool(StorageKeys key, bool value) async {
    try {
      await _ensureInitialized();
      return await _prefs?.setBool(key.key, value) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<String> getString(StorageKeys key, {String defaultValue = ''}) async {
    try {
      await _ensureInitialized();
      return _prefs?.getString(key.key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  Future<bool> setString(StorageKeys key, String value) async {
    try {
      await _ensureInitialized();
      return await _prefs?.setString(key.key, value) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<int> getInt(StorageKeys key, {int defaultValue = 0}) async {
    try {
      await _ensureInitialized();
      return _prefs?.getInt(key.key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  Future<bool> setInt(StorageKeys key, int value) async {
    try {
      await _ensureInitialized();
      return await _prefs?.setInt(key.key, value) ?? false;
    } catch (e) {
      return false;
    }
  }

  T getObject<T extends Object>(StorageKeys key,
      T Function(Map<String, dynamic>) fromJson, T defaultValue,
      {bool synchronous = false}) {
    try {
      if (synchronous && _prefs != null) {
        final jsonString = _prefs?.getString(key.key);
        if (jsonString != null && jsonString.isNotEmpty) {
          final Map<String, dynamic> json = jsonDecode(jsonString);
          return fromJson(json);
        }
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  Future<bool> saveObject(StorageKeys key, Map<String, dynamic> json) async {
    try {
      await _ensureInitialized();
      final jsonString = jsonEncode(json);
      return await _prefs?.setString(key.key, jsonString) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveObjectList<T extends Object>(StorageKeys key, List<T> list,
      Map<String, dynamic> Function(T) toJson) async {
    try {
      await _ensureInitialized();
      final jsonList = list.map((item) => toJson(item)).toList();
      final jsonString = jsonEncode(jsonList);
      return await _prefs?.setString(key.key, jsonString) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<List<T>> loadObjectList<T extends Object>(
      StorageKeys key, T Function(Map<String, dynamic>) fromJson) async {
    try {
      await _ensureInitialized();
      final jsonString = _prefs?.getString(key.key);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      final List<T> result = [];
      for (var json in jsonList) {
        if (json != null && json is Map<String, dynamic>) {
          try {
            result.add(fromJson(json));
          } catch (e) {
            // 解析单个对象失败时，打印日志并跳过该对象
          }
        }
      }
      return result;
    } catch (e) {
      return [];
    }
  }

  Future<bool> remove(StorageKeys key) async {
    try {
      await _ensureInitialized();
      return await _prefs?.remove(key.key) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearAll() async {
    try {
      await _ensureInitialized();
      return await _prefs?.clear() ?? false;
    } catch (e) {
      return false;
    }
  }
}

// 全局单例实例
final persistenceService = PersistenceService();
