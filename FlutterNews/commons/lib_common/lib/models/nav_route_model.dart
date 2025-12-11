import 'package:flutter/cupertino.dart';
import '../constants/router_map.dart';

class NavRouteModel with ChangeNotifier {
  final Map<String, Function(NavDestinationInfo)>
      _navDestinationUpdateListeners = {};
  final List<String> _videoPauseByRoutePage = [
    RouterMap.HOME_PAGE,
  ];

  Map<String, Function(NavDestinationInfo)> get navDestinationUpdateListeners =>
      Map.unmodifiable(_navDestinationUpdateListeners);

  void addNavListener(String key, Function(NavDestinationInfo) listener) {
    if (!_navDestinationUpdateListeners.containsKey(key)) {
      _navDestinationUpdateListeners[key] = listener;
      notifyListeners();
    }
  }

  void removeNavListener(String key) {
    if (_navDestinationUpdateListeners.containsKey(key)) {
      _navDestinationUpdateListeners.remove(key);
      notifyListeners();
    }
  }

  void notifyNavUpdate(NavDestinationInfo info) {
    for (final listener in _navDestinationUpdateListeners.values) {
      listener(info);
    }
  }
}

class NavDestinationInfo {
  final String currentRoute;
  final Map<String, dynamic>? arguments;
  NavDestinationInfo({
    required this.currentRoute,
    this.arguments,
  });
}
