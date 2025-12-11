
import 'business_mine_platform_interface.dart';
export 'package:business_mine/pages/mine_page.dart';

class BusinessMine {
  Future<String?> getPlatformVersion() {
    return BusinessMinePlatform.instance.getPlatformVersion();
  }
}
