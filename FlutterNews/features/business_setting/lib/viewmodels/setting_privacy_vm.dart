import 'package:get/get.dart';
import 'package:lib_common/lib_common.dart';
import '../types/types.dart';
import '../data/protocol_data_harmonyos.dart';

/// 隐私设置ViewModel
class SettingPrivacyVM extends GetxController {
  late final SettingModel settingInfo;
  final WindowModel windowModel = StorageUtils.connect(
    create: () => WindowModel(),
    type: StorageType.appStorage,
  );
  final isLoading = false.obs;
  late final RxBool personalizedRecommendationEnabled;
  late final RxList<SettingItem> list1;
  late final RxList<SettingItem> list2;
  late final RxList<SettingItem> list3;

  @override
  void onInit() {
    super.onInit();
    settingInfo = StorageUtils.connect(
      create: () => SettingModel.getInstance(),
      type: StorageType.persistence,
    );
    personalizedRecommendationEnabled = settingInfo.personalizedPush.obs;
    list1 = <SettingItem>[
      SettingItem(
        label: '个性化推荐',
        subLabel: '推荐符合我的个性化内容',
        typeSwitch: true,
        switchV: settingInfo.personalizedPush,
        onClick: (isOn) {
          settingInfo.personalizedPush = isOn as bool;
        },
      ),
    ].obs;

    list2 = <SettingItem>[
      SettingItem(
        label: '用户协议',
        onClick: (_) {
          openUserAgreement();
        },
      ),
      SettingItem(
        label: '隐私政策',
        onClick: (_) {
          openPrivacyPolicy();
        },
      ),
    ].obs;
    list3 = <SettingItem>[
      SettingItem(
        label: '第三方信息共享清单',
        onClick: (_) {
          openThirdPartyInfo();
        },
      ),
      SettingItem(
        label: '个人信息收集清单',
        onClick: (_) {
          openPersonalInfoCollection();
        },
      ),
    ].obs;
  }

  void togglePersonalizedRecommendation(bool value) {
    personalizedRecommendationEnabled.value = value;
    settingInfo.personalizedPush = value;
  }

  void openUserAgreement() {
    RouterUtils.of.push(RouterMap.PROTOCOL_WEB_VIEW, arguments: {
      'content': ProtocolDataHarmonyOS.userProtocol,
      'title': '用户协议',
    });
  }

  void openPrivacyPolicy() {
    RouterUtils.of.push(RouterMap.PROTOCOL_WEB_VIEW, arguments: {
      'content': ProtocolDataHarmonyOS.privacyProtocol,
      'title': '隐私政策',
    });
  }

  void openThirdPartyInfo() {
    RouterUtils.of.push(RouterMap.PROTOCOL_WEB_VIEW, arguments: {
      'content': ProtocolDataHarmonyOS.thirdPartyInfo,
      'title': '第三方信息共享清单',
    });
  }

  void openPersonalInfoCollection() {
    RouterUtils.of.push(RouterMap.PROTOCOL_WEB_VIEW, arguments: {
      'content': ProtocolDataHarmonyOS.personalInfoCollection,
      'title': '个人信息收集清单',
    });
  }
}
