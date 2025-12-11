import 'package:get/get.dart';
import 'package:lib_common/lib_common.dart';
import '../types/types.dart';

/// 播放与网络设置ViewModel
class SettingNetworkVM extends GetxController {
  late final SettingModel settingInfo;

  final WindowModel windowModel = StorageUtils.connect(
    create: () => WindowModel(),
    type: StorageType.appStorage,
  );

  final isLoading = false.obs;

  late final Rx<SettingItem> item1;
  late final Rx<SettingItem> item2;
  late final Rx<SettingItem> item3;
  late final Rx<SettingItem> item4;
  late final Rx<SettingItem> item5;
  late final Rx<SettingItem> item6;

  late final RxList<SettingItem> list1;
  late final RxList<SettingItem> list2;

  // 响应式开关状态
  final improveExperienceWithMobileData = false.obs;
  final autoSlideDown = false.obs;
  final autoPlayRecommended = false.obs;

  @override
  void onInit() {
    super.onInit();
    settingInfo = StorageUtils.connect(
      create: () => SettingModel.getInstance(),
      type: StorageType.persistence,
    );

    item1 = SettingItem(
      typeSelect: true,
      label: '非WLAN网络流量',
      selectTitle: '非WLAN网络流量',
      selectOptions: [
        ISelectOption(id: 0, label: '最佳效果（下载大图）'),
        ISelectOption(id: 1, label: '较省流量（智能下载）'),
        ISelectOption(id: 2, label: '极省流量（不下载图）'),
      ],
      selectV: settingInfo.network.downloadWithoutWlan,
      onSelect: (option) {
        settingInfo.network.downloadWithoutWlan = (option as ISelectOption).id;
        item1.value.selectV = settingInfo.network.downloadWithoutWlan;
      },
    ).obs;

    item2 = SettingItem(
      typeSelect: true,
      label: '非WLAN网络播放提醒',
      selectTitle: '非WLAN网络播放提醒',
      selectOptions: [
        ISelectOption(id: 0, label: '提醒一次'),
        ISelectOption(id: 1, label: '每次提醒'),
      ],
      selectV: settingInfo.network.remindWithoutWlan,
      onSelect: (option) {
        settingInfo.network.remindWithoutWlan = (option as ISelectOption).id;
        item2.value.selectV = settingInfo.network.remindWithoutWlan;
      },
    ).obs;

    item3 = SettingItem(
      typeSwitch: true,
      label: '非WLAN网络下自动播放直播',
      switchV: settingInfo.network.liveAutoplayWithoutWlan,
      onClick: (isOn) {
        settingInfo.network.liveAutoplayWithoutWlan = isOn as bool;
      },
    ).obs;

    item4 = SettingItem(
      typeSwitch: true,
      label: '使用移动网络改善内容浏览体验',
      subLabel: '如Wi-Fi网络质量差，将使用移动网络改善',
      switchV: settingInfo.network.optimizeWith4G,
      onClick: (isOn) {
        settingInfo.network.optimizeWith4G = isOn as bool;
      },
    ).obs;

    item5 = SettingItem(
      typeSwitch: true,
      label: '视频自动下滑',
      subLabel: '视频观看结束将自动下滑至下一个视频',
      switchV: settingInfo.network.autoPlayNext,
      onClick: (isOn) {
        settingInfo.network.autoPlayNext = isOn as bool;
      },
    ).obs;

    item6 = SettingItem(
      typeSwitch: true,
      label: '推荐频道自动播放视频',
      switchV: settingInfo.network.autoPlayTabRecommend,
      onClick: (isOn) {
        settingInfo.network.autoPlayTabRecommend = isOn as bool;
      },
    ).obs;

    list1 = <SettingItem>[
      item1.value,
      item2.value,
      item4.value,
    ].obs;

    list2 = <SettingItem>[
      item5.value,
      item6.value,
    ].obs;

    improveExperienceWithMobileData.value = settingInfo.network.optimizeWith4G;
    autoSlideDown.value = settingInfo.network.autoPlayNext;
    autoPlayRecommended.value = settingInfo.network.autoPlayTabRecommend;
  }

  String get nonWlanTrafficText {
    final options = ['最佳效果（下载大图）', '较省流量（智能下载）', '极省流量（不下载图）'];
    final index = settingInfo.network.downloadWithoutWlan;
    return index < options.length ? options[index] : options[0];
  }

  void selectNonWlanTraffic(Function(int) onSelected) {
    onSelected(settingInfo.network.downloadWithoutWlan);
  }

  void selectNonWlanTrafficOption(int index) {
    settingInfo.network.downloadWithoutWlan = index;
    item1.value.selectV = index;
  }

  String get nonWlanPlayReminderText {
    final options = ['提醒一次', '每次提醒'];
    final index = settingInfo.network.remindWithoutWlan;
    return index < options.length ? options[index] : options[0];
  }

  void selectNonWlanPlayReminder(Function(int) onSelected) {
    onSelected(settingInfo.network.remindWithoutWlan);
  }

  void selectNonWlanPlayReminderOption(int index) {
    settingInfo.network.remindWithoutWlan = index;
    item2.value.selectV = index;
  }

  void toggleImproveExperience(bool value) {
    settingInfo.network.optimizeWith4G = value;
    improveExperienceWithMobileData.value = value;
    item4.value.switchV = value;
  }

  void toggleAutoSlideDown(bool value) {
    settingInfo.network.autoPlayNext = value;
    autoSlideDown.value = value;
    item5.value.switchV = value;
  }

  void toggleAutoPlayRecommended(bool value) {
    settingInfo.network.autoPlayTabRecommend = value;
    autoPlayRecommended.value = value;
    item6.value.switchV = value;
  }
}
