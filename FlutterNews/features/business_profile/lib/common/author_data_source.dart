import 'package:lib_common/dataSource/common_data_source.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';

/// 作者数据源类
class AuthorDataSource implements CommonDataSource<AuthorModel> {
  final List<DataChangeListener> _listeners = [];
  @override
  List<AuthorModel> originDataArray = [];

  @override
  int totalCount() {
    return originDataArray.length;
  }

  @override
  List<AuthorModel> getAllData() {
    return List.unmodifiable(originDataArray);
  }

  @override
  AuthorModel? getData(int index) {
    if (index < 0 || index >= originDataArray.length) {
      return null;
    }
    return originDataArray[index];
  }

  @override
  void addData(int index, AuthorModel data) {
    if (index < 0 || index > originDataArray.length) {
      return;
    }
    originDataArray.insert(index, data);
    _notifyDataAdd(index);
  }

  @override
  void pushData(AuthorModel data) {
    originDataArray.add(data);
    _notifyDataAdd(originDataArray.length - 1);
  }

  @override
  void pushDataArray(List<AuthorModel> items) {
    for (final data in items) {
      originDataArray.add(data);
      _notifyDataAdd(originDataArray.length - 1);
    }
  }

  @override
  void setData(List<AuthorModel>? dataArray) {
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

  @override
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

  @override
  void notifyDataDelete(int index) {
    if (index < 0 || index >= originDataArray.length) {
      return;
    }
    originDataArray.removeAt(index);
    for (final listener in _listeners) {
      listener.onDataDelete(index);
    }
  }

  @override
  void notifyDataChange(int index) {
    if (index < 0 || index >= originDataArray.length) {
      return;
    }
    for (final listener in _listeners) {
      listener.onDataChange(index);
    }
  }
}
