import 'package:flutter/material.dart';

class FullScreenProvider extends ChangeNotifier {
  static FullScreenProvider? _instance;
  factory FullScreenProvider() => _instance ??= FullScreenProvider._internal();
  FullScreenProvider._internal();

  bool _isFullScreen = false;
  bool get isFullScreen => _isFullScreen;

  void setFullScreen(bool value) {
    _isFullScreen = value;
    notifyListeners();
  }
}
