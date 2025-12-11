import 'package:get/get.dart';
import 'package:lib_common/constants/pop_view_utils.dart';
import 'package:lib_common/lib_common.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../utils/app_gallery_utils.dart';

const String TAG = '[SettingAboutVM]';

class SettingAboutVM extends GetxController {
  final appName = ''.obs;
  final appVersionName = ''.obs;
  final hasNewVersion = false.obs;
  final updateLabel = '检查更新'.obs;
  final hotline = '000000'.obs;
  final loading = false.obs;

  final WindowModel windowModel = StorageUtils.connect(
    create: () => WindowModel(),
    type: StorageType.appStorage,
  );

  @override
  void onInit() {
    super.onInit();
    getBundleInfo();
  }

  Future<void> getBundleInfo() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appName.value =
          packageInfo.appName.isNotEmpty ? packageInfo.appName : '综合新闻模版';
      appVersionName.value =
          packageInfo.version.isNotEmpty ? packageInfo.version : '1.0.0';
    } catch (e) {
      appName.value = '综合新闻模版';
      appVersionName.value = '1.0.0';
    }
  }

  Future<void> checkUpdate() async {
    try {
      loading.value = true;
      final bool resp = await AppGalleryUtils.checkAppUpdate();
      hasNewVersion.value = resp;
      updateLabel.value = hasNewVersion.value ? '存在新版本' : '已是最新版本';
      if (hasNewVersion.value) {
        await AppGalleryUtils.showUpdateDialog();
      } else {
        toast(updateLabel.value);
      }
    } catch (e) {
      toast('检查更新失败');
    } finally {
      loading.value = false;
    }
  }

  Future<void> callHotline() async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: hotline.value);
      final bool canLaunch = await canLaunchUrl(phoneUri);
      if (canLaunch) {
        await launchUrl(phoneUri);
      } else {
        toast('无法拨打电话');
      }
    } catch (error) {
      toast('无法拨打电话');
    }
  }

  Future<void> goWebsite() async {
    try {
      final Uri websiteUri = Uri.parse(
        'https://beian.miit.gov.cn/#/home',
      );
      final bool canLaunch = await canLaunchUrl(
        websiteUri,
      );

      if (canLaunch) {
        await launchUrl(
          websiteUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        toast('无法打开网站');
      }
    } catch (error) {
      toast('无法打开网站');
    }
  }

  /// 检查更新
  void checkForUpdate() {
    checkUpdate();
  }

  String get appVersion => appVersionName.value;
  bool get isCheckingUpdate => loading.value;

  void makePhoneCall() {
    callHotline();
  }
}
