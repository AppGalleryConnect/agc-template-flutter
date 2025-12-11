/// 数据变更监听器接口（对应原 DataChangeListener）
abstract class DataChangeListener {
  void onDataReloaded();
  void onDataAdd(int index);
  void onDataMove(int from, int to);
  void onDataDelete(int index);
  void onDataChange(int index);
}

/// 数据源接口（对应原 IDataSource）
abstract class IDataSource<T> {
  int totalCount();
  List<T> getAllData();
  T? getData(int index);
  void addData(int index, T data);
  void pushData(T data);
  void pushDataArray(List<T> items);
  void setData(List<T>? dataArray);
  void registerDataChangeListener(DataChangeListener listener);
  void unregisterDataChangeListener(DataChangeListener listener);
}

/// 通用数据源实现类（对应原 CommonDataSource）
class CommonDataSource<T> implements IDataSource<T> {
  final List<DataChangeListener> _listeners = [];
  List<T> originDataArray = [];

  @override
  int totalCount() {
    return originDataArray.length;
  }

  @override
  List<T> getAllData() {
    return List.unmodifiable(originDataArray);
  }

  @override
  T? getData(int index) {
    if (index < 0 || index >= originDataArray.length) {
      return null;
    }
    return originDataArray[index];
  }

  @override
  void addData(int index, T data) {
    if (index < 0 || index > originDataArray.length) {
      return;
    }
    originDataArray.insert(index, data);
    _notifyDataAdd(index);
  }

  @override
  void pushData(T data) {
    originDataArray.add(data);
    _notifyDataAdd(originDataArray.length - 1);
  }

  @override
  void pushDataArray(List<T> items) {
    for (final data in items) {
      originDataArray.add(data);
      _notifyDataAdd(originDataArray.length - 1);
    }
  }

  @override
  void setData(List<T>? dataArray) {
    if (dataArray != null) {
      originDataArray = List.from(dataArray);
    }
    _notifyDataReload();
  }

  @override
  void registerDataChangeListener(DataChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  @override
  void unregisterDataChangeListener(DataChangeListener listener) {
    _listeners.remove(listener);
  }

  void _notifyDataReload() {
    for (final listener in _listeners) {
      listener.onDataReloaded();
    }
  }

  void _notifyDataAdd(int index) {
    for (final listener in _listeners) {
      listener.onDataAdd(index);
    }
  }

  void notifyDataMove(int from, int to) {
    if (from < 0 ||
        to < 0 ||
        from >= originDataArray.length ||
        to >= originDataArray.length) {
      return;
    }
    final data = originDataArray.removeAt(from);
    originDataArray.insert(to, data);
    for (final listener in _listeners) {
      listener.onDataMove(from, to);
    }
  }

  void notifyDataDelete(int index) {
    if (index < 0 || index >= originDataArray.length) {
      return;
    }
    originDataArray.removeAt(index);
    for (final listener in _listeners) {
      listener.onDataDelete(index);
    }
  }

  void notifyDataChange(int index) {
    if (index < 0 || index >= originDataArray.length) {
      return;
    }
    for (final listener in _listeners) {
      listener.onDataChange(index);
    }
  }
}
