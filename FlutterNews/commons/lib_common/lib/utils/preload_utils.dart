import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:lib_news_api/params/response/layout_response.dart';

/// 预加载工具类
class PreloadUtils {
  static const MethodChannel _preloadChannel =
      MethodChannel('com.news.flutter/preload');

  static Map<String, dynamic> _safeConvertToMap(dynamic data) {
    if (data == null) return {};
    if (data is Map<String, dynamic>) return data;
    try {
      final jsonStr = json.encode(data);
      return json.decode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  // 获取预加载数据
  static Future<List<RequestListData>> getPreloadData() async {
    try {
      final dynamic recommendList =
          await _preloadChannel.invokeMethod('getPreloadData');
      if (recommendList is! List) return <RequestListData>[];

      final List<RequestListData> resultList = [];
      for (final item in recommendList) {
        try {
          final Map<String, dynamic> itemMap = _safeConvertToMap(item);
          resultList.add(RequestListData.fromJson(itemMap));
        } catch (e) {
          continue;
        }
      }
      return resultList;
    } catch (e) {
      return <RequestListData>[];
    }
  }
}
