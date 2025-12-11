import 'business_home_platform_interface.dart';
export 'package:business_home/pages/home_page.dart';
export 'package:business_home/pages/news_search.dart';

class BusinessHome {
  Future<String?> getPlatformVersion() {
    return BusinessHomePlatform.instance.getPlatformVersion();
  }
}
