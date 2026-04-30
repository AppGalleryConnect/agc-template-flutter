import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lib_account/services/account_api.dart';
import 'package:lib_account/utils/login_sheet_utils.dart';
import 'package:lib_common/constants/pop_view_utils.dart';
import 'package:lib_common/dialogs/common_confirm_dialog.dart';
import 'package:lib_common/lib_common.dart';
import '../types/types.dart';
import '../utils/app_gallery_utils.dart';
import '../utils/cache_utils.dart';

class SettingViewModel extends GetxController {
  final isLoading = false.obs;
  final cacheSize = '0'.obs;
  final isUserLoggedIn = false.obs;
  final isLoggingOut = false.obs;
  final isCheckingUpdate = false.obs;
  final appVersion = '1.0.0'.obs;

  late final Rx<SettingItem> cacheSettingItem;
  late final Rx<SettingItem> colorSettingItem;
  late final Rx<SettingItem> pushSettingItem;

  late final RxList<SettingItem> list1;
  late final RxList<SettingItem> list2;
  late final RxList<SettingItem> list3;
  late final RxList<SettingItem> list4;

  late final UserInfoModel userInfoModel;
  late final SettingModel settingInfo;

  final WindowModel windowModel = StorageUtils.connect(
    create: () => WindowModel(),
    type: StorageType.appStorage,
  );

  @override
  void onInit() {
    super.onInit();

    userInfoModel = AccountApi.getInstance().userInfoModel;
    settingInfo = StorageUtils.connect(
      create: () => SettingModel.getInstance(),
      type: StorageType.persistence,
    );

    userInfoModel.addListener(_updateLoginStatus);
    _updateLoginStatus();


    cacheSettingItem = SettingItem(
      label: '清理缓存',
      extraLabel: '0M',
      onClick: (_) => clearCache(),
    ).obs;

    colorSettingItem = SettingItem(
      label: '夜间模式',
      tag: SettingItemTag.darkMode,
      typeSelect: true,
    ).obs;

    pushSettingItem = SettingItem(
      label: '通知开关',
      tag: SettingItemTag.notification,
      typeSwitch: true,
      switchV: settingInfo.pushSwitch,
      onClick: (isOn) {
        settingInfo.pushSwitch = isOn as bool;
        pushSettingItem.value.switchV = isOn;
        pushSettingItem.refresh();
      },
    ).obs;

    list1 = <SettingItem>[
      SettingItem(
        label: '个人信息',
        routerName: RouterMap.SETTING_PERSONAL,
        onClick: (_) {
          if (userInfoModel.isLogin) {
            try {
              RouterUtils.of.pushPathByName(RouterMap.SETTING_PERSONAL);
            } catch (e) {
              toast('跳转失败');
            }
          } else {
            LoginSheetUtils.showLoginSheet(GlobalContext.context);
          }
        },
      ),
      SettingItem(
        label: '隐私设置',
        routerName: RouterMap.SETTING_PRIVACY,
        onClick: (_) {
          RouterUtils.of.pushPathByName(RouterMap.SETTING_PRIVACY);
        },
      ),
    ].obs;

    list2 = <SettingItem>[
      pushSettingItem.value,
      SettingItem(
        label: '播放与网络设置',
        routerName: RouterMap.SETTING_NETWORK,
        onClick: (_) {
          RouterUtils.of.pushPathByName(RouterMap.SETTING_NETWORK);
        },
      ),
      cacheSettingItem.value,
    ].obs;

    list3 = <SettingItem>[
      colorSettingItem.value,
      SettingItem(
        label: '字体大小',
        routerName: RouterMap.SETTING_FONT,
        onClick: (_) {
          RouterUtils.of.pushPathByName(RouterMap.SETTING_FONT);
        },
      ),
    ].obs;

    list4 = <SettingItem>[
      SettingItem(
        label: '检测版本',
        onClick: (_) {
          checkAppVersion();
        },
      ),
      SettingItem(
        label: '关于我们',
        routerName: RouterMap.SETTING_ABOUT,
        onClick: (_) {
          RouterUtils.of.pushPathByName(RouterMap.SETTING_ABOUT);
        },
      ),
    ].obs;

    getCache();
  }

  void _updateLoginStatus() {
    isUserLoggedIn.value = userInfoModel.isLogin;
  }

  @override
  void onClose() {
    userInfoModel.removeListener(_updateLoginStatus);
    super.onClose();
  }

  void setColorMode(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
      ),
    );
  }

  Future<void> getCache() async {
    try {
      final cacheSizeBytes = await CacheUtils.getCache();
      cacheSize.value = cacheSizeBytes;
      final newItem = SettingItem(
        label: '清理缓存',
        extraLabel: cacheSize.value,
        onClick: (_) => clearCache(),
      );

      cacheSettingItem.value = newItem;
      list2[2] = newItem;
      list2.refresh();
      update();
    } catch (e) {
      cacheSize.value = '0.00';
    }
  }


  String getLocalCacheLabel() {
    return cacheSize.value;
  }

  void onSignOutBtnClick(BuildContext context) {
    CommonConfirmDialog.show(
      context,
      IConfirmDialogParams(
        content: '确定退出登录吗？',
        priBtnV: '取消',
        secBtnV: '确定',
        confirm: () {
          isLoggingOut.value = true;
          userInfoModel.clearUserInfo();
          isUserLoggedIn.value = false;
          isLoggingOut.value = false;
          toast('已退出登录');
          RouterUtils.of.pushPathByName(RouterMap.MINE_PAGE);
          RouterUtils.of.clearStack();
        },
      ),
    );
  }

  String get signOutBtnLabel {
    if (isLoggingOut.value) {
      return '正在退出登录...';
    }
    return '退出登录';
  }

  void openPersonalInfo() {
    RouterUtils.of.pushPathByName(RouterMap.SETTING_PERSONAL);
  }

  void openPrivacySettings() {
    RouterUtils.of.pushPathByName(RouterMap.SETTING_PRIVACY);
  }

  void openPlayNetSettings() {
    RouterUtils.of.pushPathByName(RouterMap.SETTING_NETWORK);
  }

  void openFontSizeSettings() {
    RouterUtils.of.pushPathByName(RouterMap.SETTING_FONT);
  }

  void openAbout() {
    RouterUtils.of.pushPathByName(RouterMap.SETTING_ABOUT);
  }

  void toggleNotification(bool value) {
    settingInfo.pushSwitch = value;
    pushSettingItem.value.switchV = value;
    pushSettingItem.refresh();
  }

  void toggleDarkMode(bool value) {
    settingInfo.darkSwitch = value;
    colorSettingItem.value.switchV = value;
    colorSettingItem.refresh();
    setColorMode(value);
  }

  Future<void> clearCache() async {
    try {
      CacheUtils.clearCache();
      Future.delayed(const Duration(seconds: 1), () async {
        await getCache();
        toast('清除缓存成功');
      });

    } catch (e) {
      toast('清除缓存失败');
    }
  }

  Future<void> checkAppVersion() async {
    try {
      final bool hasUpdate = await AppGalleryUtils.checkAppUpdate();
      if (hasUpdate) {
        await AppGalleryUtils.showUpdateDialog();
      } else {
        toast('已是最新版本');
      }
    } catch (e) {
      toast('检测版本失败');
    }
  }

  Future<void> checkUpdate() async {
    await checkAppVersion();
  }

  Future<void> logout(BuildContext context) async {
    onSignOutBtnClick(context);
  }

  String get logoutButtonLabel => signOutBtnLabel;
}
