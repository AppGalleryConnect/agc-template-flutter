import 'package:flutter/foundation.dart';

class NetHandle {
  final int netId;
  NetHandle({required this.netId});
}

class NetworkModel with ChangeNotifier {
  static NetworkModel? _instance;
  NetHandle? _netHandle;
  bool _hasNet = true;
  bool _isCellular = false;
  bool _isWiFi = false;
  bool _hasOfflineTip = false;
  bool _canUseMobileData = false;
  bool _hasUseMobileDataTip = false;
  bool _isNetworkAvailable = true;
  bool _isWeekNetwork = false;
  List<String> _netAddress = [];
  NetworkModel._internal();
  static NetworkModel getInstance() {
    _instance ??= NetworkModel._internal();
    return _instance!;
  }

  NetHandle? get netHandle => _netHandle;
  bool get hasNet => _hasNet;
  bool get isCellular => _isCellular;
  bool get isWiFi => _isWiFi;
  bool get hasOfflineTip => _hasOfflineTip;
  bool get canUseMobileData => _canUseMobileData;
  bool get hasUseMobileDataTip => _hasUseMobileDataTip;
  bool get isNetworkAvailable => _isNetworkAvailable;
  bool get isWeekNetwork => _isWeekNetwork;
  List<String> get netAddress => List.unmodifiable(_netAddress);
  set netHandle(NetHandle? value) {
    if (_netHandle != value) {
      _netHandle = value;
      notifyListeners();
    }
  }

  set hasNet(bool value) {
    if (_hasNet != value) {
      _hasNet = value;
      notifyListeners();
    }
  }

  set isCellular(bool value) {
    if (_isCellular != value) {
      _isCellular = value;
      notifyListeners();
    }
  }

  set isWiFi(bool value) {
    if (_isWiFi != value) {
      _isWiFi = value;
      notifyListeners();
    }
  }

  set hasOfflineTip(bool value) {
    if (_hasOfflineTip != value) {
      _hasOfflineTip = value;
      notifyListeners();
    }
  }

  set canUseMobileData(bool value) {
    if (_canUseMobileData != value) {
      _canUseMobileData = value;
      notifyListeners();
    }
  }

  set hasUseMobileDataTip(bool value) {
    if (_hasUseMobileDataTip != value) {
      _hasUseMobileDataTip = value;
      notifyListeners();
    }
  }

  set isNetworkAvailable(bool value) {
    if (_isNetworkAvailable != value) {
      _isNetworkAvailable = value;
      notifyListeners();
    }
  }

  set isWeekNetwork(bool value) {
    if (_isWeekNetwork != value) {
      _isWeekNetwork = value;
      notifyListeners();
    }
  }

  set netAddress(List<String> value) {
    if (!listEquals(_netAddress, value)) {
      _netAddress = List.from(value);
      notifyListeners();
    }
  }
}

bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
