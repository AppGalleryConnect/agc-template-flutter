import 'package:flutter/foundation.dart';

/// 窗口持久化模型
class WindowModel with ChangeNotifier {
  /// 窗口顶部内边距
  double _windowTopPadding = 40.0;

  /// 窗口底部内边距
  double _windowBottomPadding = 28.0;

  /// 窗口宽度
  double _windowWidth = 0.0;

  /// 窗口高度
  double _windowHeight = 0.0;

  double get windowTopPadding => _windowTopPadding;
  double get windowBottomPadding => _windowBottomPadding;
  double get windowWidth => _windowWidth;
  double get windowHeight => _windowHeight;

  set windowTopPadding(double value) {
    if (_windowTopPadding != value) {
      _windowTopPadding = value;
      notifyListeners();
    }
  }

  set windowBottomPadding(double value) {
    if (_windowBottomPadding != value) {
      _windowBottomPadding = value;
      notifyListeners();
    }
  }

  set windowWidth(double value) {
    if (_windowWidth != value) {
      _windowWidth = value;
      notifyListeners();
    }
  }

  set windowHeight(double value) {
    if (_windowHeight != value) {
      _windowHeight = value;
      notifyListeners();
    }
  }

  /// 同步更新窗口尺寸（宽度和高度）
  void updateWindowSize(double width, double height) {
    if (_windowWidth != width || _windowHeight != height) {
      _windowWidth = width;
      _windowHeight = height;
      notifyListeners();
    }
  }

  /// 同步更新窗口边距（顶部和底部）
  void updateWindowPadding(double top, double bottom) {
    if (_windowTopPadding != top || _windowBottomPadding != bottom) {
      _windowTopPadding = top;
      _windowBottomPadding = bottom;
      notifyListeners();
    }
  }
}
