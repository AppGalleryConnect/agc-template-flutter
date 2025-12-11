import 'package:lib_common/dataSource/common_data_source.dart';
import 'package:lib_news_api/observedmodels/news_model.dart';
import 'package:lib_news_api/params/response/layout_response.dart';

/// 布局新闻数据源类
class LayoutNewsDataSource implements CommonDataSource<RequestListData> {
  final List<DataChangeListener> _listeners = [];
  @override
  List<RequestListData> originDataArray = [];

  @override
  int totalCount() {
    return originDataArray.length;
  }

  @override
  List<RequestListData> getAllData() {
    return List.unmodifiable(originDataArray);
  }

  @override
  RequestListData? getData(int index) {
    if (index < 0 || index >= originDataArray.length) {
      return null;
    }
    return originDataArray[index];
  }

  @override
  void addData(int index, RequestListData data) {
    if (index < 0 || index > originDataArray.length) {
      return;
    }
    originDataArray.insert(index, data);
    _notifyDataAdd(index);
  }

  @override
  void pushData(RequestListData data) {
    originDataArray.add(data);
    _notifyDataAdd(originDataArray.length - 1);
  }

  @override
  void pushDataArray(List<RequestListData> items) {
    for (final data in items) {
      originDataArray.add(data);
      _notifyDataAdd(originDataArray.length - 1);
    }
  }

  @override
  void setData(List<RequestListData>? dataArray) {
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

/// 新闻数据源类
class NewsDataSource implements CommonDataSource<NewsModel> {
  final List<DataChangeListener> _listeners = [];
  @override
  List<NewsModel> originDataArray = [];

  @override
  int totalCount() {
    return originDataArray.length;
  }

  @override
  List<NewsModel> getAllData() {
    return List.unmodifiable(originDataArray);
  }

  @override
  NewsModel? getData(int index) {
    if (index < 0 || index >= originDataArray.length) {
      return null;
    }
    return originDataArray[index];
  }

  @override
  void addData(int index, NewsModel data) {
    if (index < 0 || index > originDataArray.length) {
      return;
    }
    originDataArray.insert(index, data);
    _notifyDataAdd(index);
  }

  @override
  void pushData(NewsModel data) {
    originDataArray.add(data);
    _notifyDataAdd(originDataArray.length - 1);
  }

  @override
  void pushDataArray(List<NewsModel> items) {
    for (final data in items) {
      originDataArray.add(data);
      _notifyDataAdd(originDataArray.length - 1);
    }
  }

  @override
  void setData(List<NewsModel>? dataArray) {
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
