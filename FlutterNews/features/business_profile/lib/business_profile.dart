
import 'business_profile_platform_interface.dart';
export 'package:business_profile/pages/person_home_page.dart';

class BusinessProfile {
  Future<String?> getPlatformVersion() {
    return BusinessProfilePlatform.instance.getPlatformVersion();
  }
}
