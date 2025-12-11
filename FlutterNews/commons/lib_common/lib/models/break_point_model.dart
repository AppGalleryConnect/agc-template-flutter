import 'package:flutter/foundation.dart';
import '../constants/grid_row_col_setting.dart';

class BreakpointModel with ChangeNotifier {
  BreakpointName _currentBreakpoint = BreakpointName.sm;
  BreakpointName get currentBreakpoint => _currentBreakpoint;
  set currentBreakpoint(BreakpointName value) {
    if (_currentBreakpoint != value) {
      _currentBreakpoint = value;
      notifyListeners();
    }
  }
}
