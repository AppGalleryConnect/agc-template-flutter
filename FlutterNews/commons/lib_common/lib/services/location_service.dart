import 'package:module_newsfeed/components/native_navigation_utils.dart';

/// 位置服务工具类，用于封装位置相关的功能
class LocationService {
  /// 获取位置信息
  static Future<String?> getLocation() async {
    try {
      String? result = await NativeNavigationUtils.getLocation();
      if (result.isNotEmpty) {
        String cityName = result;
        if (cityName.endsWith('市')) {
          cityName = cityName.substring(0, cityName.length - 1);
        }
        return cityName;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// 获取默认位置信息
  static String getDefaultLocation() {
    return "南京";
  }

  /// 获取错误位置信息
  static String getErrorLocation() {
    return "定位失败";
  }

  /// 处理TabInfo列表中的位置标签更新
  static bool updateLocationInTabList(List tabsList,
      {String locationId = 'location', String? location}) {
    if (tabsList.isEmpty) {
      return false;
    }

    bool updated = false;
    for (var i = 0; i < tabsList.length; i++) {
      if (tabsList[i] != null && tabsList[i].id == locationId) {
        tabsList[i].text = location ?? getDefaultLocation();
        updated = true;
        break;
      }
    }

    return updated;
  }
}
