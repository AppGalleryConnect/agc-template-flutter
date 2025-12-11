import 'package:flutter/foundation.dart';

enum StorageType {
  appStorage,
  persistence,
}

class StorageUtils {
  static T connect<T extends ChangeNotifier>({
    required T Function() create,
    required StorageType type,
  }) {
    final T instance = create();

    if (type == StorageType.persistence) {}
    return instance;
  }
}
