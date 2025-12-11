
import 'business_video_platform_interface.dart';
export 'package:business_video/pages/video_page.dart';

class BusinessVideo {
  Future<String?> getPlatformVersion() {
    return BusinessVideoPlatform.instance.getPlatformVersion();
  }
}
