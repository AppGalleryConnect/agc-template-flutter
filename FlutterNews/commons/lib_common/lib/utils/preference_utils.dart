import 'package:shared_preferences/shared_preferences.dart';
import 'logger.dart';

final Logger _logger = Logger();
const String _tag = '[PreferenceUtils]';

class PreferenceUtils {
  static final Map<String, PreferenceUtils> _preferenceRecord = {};
  SharedPreferences? _prefs;
  PreferenceUtils._(String fileName) {
    _init(fileName);
  }
  Future<void> _init(String fileName) async {
    try {
      await _clearCache(fileName);
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      // 初始化失败时打印日志
    }
  }

  /// 获取单例实例
  static PreferenceUtils getInstance({String fileName = 'default'}) {
    if (_preferenceRecord.containsKey(fileName)) {
      return _preferenceRecord[fileName]!;
    }
    final preferenceUtil = PreferenceUtils._(fileName);
    _preferenceRecord[fileName] = preferenceUtil;
    return preferenceUtil;
  }

  /// 存储数据
  Future<void> put(String key, dynamic value) async {
    if (_prefs == null) {
      Logger.info('$_tag PreferenceUtil: dataPreferences is null');
      return;
    }

    try {
      if (value is String) {
        await _prefs?.setString(key, value);
      } else if (value is bool) {
        await _prefs?.setBool(key, value);
      } else if (value is int) {
        await _prefs?.setInt(key, value);
      } else if (value is double) {
        await _prefs?.setDouble(key, value);
      } else if (value is List<String>) {
        await _prefs?.setStringList(key, value);
      } else {
        return;
      }
    } catch (e) {
      // 存储失败时打印日志
    }
  }

  /// 获取数据
  dynamic get(String key, {dynamic defaultValue}) {
    if (_prefs == null) {
      Logger.info('$_tag PreferenceUtil: dataPreferences is null');
      return defaultValue;
    }

    try {
      dynamic data;
      if (defaultValue is String) {
        data = _prefs?.getString(key) ?? defaultValue;
      } else if (defaultValue is bool) {
        data = _prefs?.getBool(key) ?? defaultValue;
      } else if (defaultValue is int) {
        data = _prefs?.getInt(key) ?? defaultValue;
      } else if (defaultValue is double) {
        data = _prefs?.getDouble(key) ?? defaultValue;
      } else if (defaultValue is List<String>) {
        data = _prefs?.getStringList(key) ?? defaultValue;
      } else {
        data = _prefs?.get(key) ?? defaultValue;
      }
      return data;
    } catch (e) {
      return defaultValue;
    }
  }

  /// 清除指定文件的缓存
  Future<void> _clearCache(String fileName) async {}
}




// // 获取默认文件的实例
// final prefs = PreferenceUtils.getInstance();
//
// // 存储数据
// await prefs.put('user_name', 'Flutter');
// await prefs.put('is_login', true);
// await prefs.put('age', 25);
//
// // 获取数据
// String? userName = prefs.get('user_name', defaultValue: 'Guest');
// bool isLogin = prefs.get('is_login', defaultValue: false);
// int age = prefs.get('age', defaultValue: 0);
//
// // 使用自定义文件名
// final customPrefs = PreferenceUtils.getInstance(fileName: 'settings');
// await customPrefs.put('theme_mode', 'dark');
// String? themeMode = customPrefs.get('theme_mode', defaultValue: 'light');