import 'package:flutter/foundation.dart';
import '../utils/preference_utils.dart';
import '../utils/logger.dart';

const String _TAG = '[SettingModel]';

class SettingModel with ChangeNotifier {
  static const String _keyPushSwitch = 'setting_push_switch';
  static const String _keyDarkSwitch = 'setting_dark_switch';
  static const String _keyFontSizeRatio = 'setting_font_size_ratio';
  static const String _keyPersonalizedPush = 'setting_personalized_push';
  static SettingModel? _instance;
  late final PreferenceUtils _prefs;
  bool _isInitialized = false;
  static SettingModel getInstance() {
    _instance ??= SettingModel._internal();
    return _instance!;
  }

  SettingModel._internal();
  factory SettingModel() => getInstance();
  Future<void> initPreferences() async {
    if (_isInitialized) return;
    try {
      _prefs = PreferenceUtils.getInstance(fileName: 'settings');
      await Future.delayed(const Duration(milliseconds: 100));
      await _loadSettings();
      _isInitialized = true;
    } catch (e) {
      // 初始化失败
    }
  }

  bool _pushSwitch = false;
  bool _darkSwitch = false;

  /// 字体大小比例（对应鸿蒙 fontSizeRatio）
  double _fontSizeRatio = 1.0;
  bool _personalizedPush = true;
  late final SettingNetworkModel _network;
  bool get pushSwitch => _pushSwitch;
  bool get darkSwitch => _darkSwitch;
  double get fontSizeRatio => _fontSizeRatio;
  bool get personalizedPush => _personalizedPush;
  SettingNetworkModel get network => _network;
  Future<void> _loadSettings() async {
    try {
      _pushSwitch = _prefs.get(_keyPushSwitch, defaultValue: false) ?? false;
      _darkSwitch = _prefs.get(_keyDarkSwitch, defaultValue: false) ?? false;
      _fontSizeRatio = _prefs.get(_keyFontSizeRatio, defaultValue: 1.0) ?? 1.0;
      _personalizedPush =
          _prefs.get(_keyPersonalizedPush, defaultValue: true) ?? true;
      _network = SettingNetworkModel();
      await _network.initPreferences();
      notifyListeners();
    } catch (e) {
      // 加载设置失败
    }
  }

  set pushSwitch(bool value) {
    if (_pushSwitch != value) {
      _pushSwitch = value;
      _prefs.put(_keyPushSwitch, value);
      notifyListeners();
    }
  }

  set darkSwitch(bool value) {
    if (_darkSwitch != value) {
      _darkSwitch = value;
      _prefs.put(_keyDarkSwitch, value);
      notifyListeners();
    }
  }

  set fontSizeRatio(double value) {
    if (_fontSizeRatio != value) {
      _fontSizeRatio = value;
      _prefs.put(_keyFontSizeRatio, value);
      notifyListeners();
    }
  }

  set personalizedPush(bool value) {
    if (_personalizedPush != value) {
      _personalizedPush = value;
      _prefs.put(_keyPersonalizedPush, value);
      notifyListeners();
    }
  }
}

class SettingNetworkModel with ChangeNotifier {
  static const String _keyDownloadWithoutWlan = 'network_download_without_wlan';
  static const String _keyRemindWithoutWlan = 'network_remind_without_wlan';
  static const String _keyLiveAutoplayWithoutWlan =
      'network_live_autoplay_without_wlan';
  static const String _keyOptimizeWith4G = 'network_optimize_with_4g';
  static const String _keyAutoPlayNext = 'network_auto_play_next';
  static const String _keyAutoPlayTabRecommend =
      'network_auto_play_tab_recommend';
  late final PreferenceUtils _prefs;
  bool _isInitialized = false;
  int _downloadWithoutWlan = 0;
  int _remindWithoutWlan = 0;
  bool _liveAutoplayWithoutWlan = true;
  bool _optimizeWith4G = true;
  bool _autoPlayNext = true;
  bool _autoPlayTabRecommend = true;
  int get downloadWithoutWlan => _downloadWithoutWlan;
  int get remindWithoutWlan => _remindWithoutWlan;
  bool get liveAutoplayWithoutWlan => _liveAutoplayWithoutWlan;
  bool get optimizeWith4G => _optimizeWith4G;
  bool get autoPlayNext => _autoPlayNext;
  bool get autoPlayTabRecommend => _autoPlayTabRecommend;
  Future<void> initPreferences() async {
    if (_isInitialized) return;

    try {
      _prefs = PreferenceUtils.getInstance(fileName: 'settings_network');
      await Future.delayed(const Duration(milliseconds: 100));
      await _loadSettings();
      _isInitialized = true;
    } catch (e) {
      // 初始化失败
    }
  }

  /// 从本地存储加载网络设置
  Future<void> _loadSettings() async {
    try {
      _downloadWithoutWlan =
          _prefs.get(_keyDownloadWithoutWlan, defaultValue: 0) ?? 0;
      _remindWithoutWlan =
          _prefs.get(_keyRemindWithoutWlan, defaultValue: 0) ?? 0;
      _liveAutoplayWithoutWlan =
          _prefs.get(_keyLiveAutoplayWithoutWlan, defaultValue: true) ?? true;
      _optimizeWith4G =
          _prefs.get(_keyOptimizeWith4G, defaultValue: true) ?? true;
      _autoPlayNext = _prefs.get(_keyAutoPlayNext, defaultValue: true) ?? true;
      _autoPlayTabRecommend =
          _prefs.get(_keyAutoPlayTabRecommend, defaultValue: true) ?? true;

      Logger.info(_TAG, '加载网络设置完成');
      notifyListeners();
    } catch (e) {
      Logger.error(_TAG, '加载网络设置失败: $e');
    }
  }

  set downloadWithoutWlan(int value) {
    if (_downloadWithoutWlan != value) {
      _downloadWithoutWlan = value;
      _prefs.put(_keyDownloadWithoutWlan, value);
      notifyListeners();
      Logger.info(_TAG, '保存 downloadWithoutWlan: $value');
    }
  }

  set remindWithoutWlan(int value) {
    if (_remindWithoutWlan != value) {
      _remindWithoutWlan = value;
      _prefs.put(_keyRemindWithoutWlan, value);
      notifyListeners();
    }
  }

  set liveAutoplayWithoutWlan(bool value) {
    if (_liveAutoplayWithoutWlan != value) {
      _liveAutoplayWithoutWlan = value;
      _prefs.put(_keyLiveAutoplayWithoutWlan, value);
      notifyListeners();
    }
  }

  set optimizeWith4G(bool value) {
    if (_optimizeWith4G != value) {
      _optimizeWith4G = value;
      _prefs.put(_keyOptimizeWith4G, value);
      notifyListeners();
    }
  }

  set autoPlayNext(bool value) {
    if (_autoPlayNext != value) {
      _autoPlayNext = value;
      _prefs.put(_keyAutoPlayNext, value);
      notifyListeners();
    }
  }

  set autoPlayTabRecommend(bool value) {
    if (_autoPlayTabRecommend != value) {
      _autoPlayTabRecommend = value;
      _prefs.put(_keyAutoPlayTabRecommend, value);
      notifyListeners();
    }
  }
}
