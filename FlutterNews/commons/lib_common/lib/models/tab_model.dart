import 'package:flutter/foundation.dart';

/// 应用的Tab信息模型
class TabModel with ChangeNotifier {
  /// 当前选择的tab下标
  int _selectedIndex = 0;

  /// 是否展示tab
  bool _showTabBar = true;

  /// tab的高度
  double? _tabHeight;

  /// 视频tab页的头部tab下标
  int _videoCurrentTabIndex = 1;
  int get selectedIndex => _selectedIndex;
  bool get showTabBar => _showTabBar;
  double? get tabHeight => _tabHeight;
  int get videoCurrentTabIndex => _videoCurrentTabIndex;
  set selectedIndex(int value) {
    if (_selectedIndex != value) {
      _selectedIndex = value;
      notifyListeners();
    }
  }

  set showTabBar(bool value) {
    if (_showTabBar != value) {
      _showTabBar = value;
      notifyListeners();
    }
  }

  set tabHeight(double? value) {
    if (_tabHeight != value) {
      _tabHeight = value;
      notifyListeners();
    }
  }

  set videoCurrentTabIndex(int value) {
    if (_videoCurrentTabIndex != value) {
      _videoCurrentTabIndex = value;
      notifyListeners();
    }
  }
}
