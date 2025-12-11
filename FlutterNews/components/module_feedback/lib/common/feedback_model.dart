import 'package:flutter/material.dart';

class FeedbackModel extends ChangeNotifier {
  double windowTopPadding = 40.0;
  double windowBottomPadding = 28.0;
  double fontSizeRatio = 1.0;

  void updateWindowTopPadding(double value) {
    windowTopPadding = value;
    notifyListeners();
  }

  void updateWindowBottomPadding(double value) {
    windowBottomPadding = value;
    notifyListeners();
  }

  void updateFontSizeRatio(double value) {
    fontSizeRatio = value;
    notifyListeners();
  }
}