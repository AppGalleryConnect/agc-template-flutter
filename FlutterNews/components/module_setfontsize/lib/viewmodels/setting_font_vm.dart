import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_common/constants/pop_view_utils.dart';
import 'package:lib_common/lib_common.dart';

import '../constants/constants.dart';

/// 字体大小设置ViewModel
class SettingFontViewModel extends GetxController {
  static const List<ButtonItem> buttonList = [
    ButtonItem(id: '1', label: '列表页'),
    ButtonItem(id: '2', label: '详情页'),
  ];

  static const List<FontSizeItem> fontSizeList = [
    FontSizeItem(id: 0, value: FontSizeEnum.small, label: '小'),
    FontSizeItem(id: 1, value: FontSizeEnum.normal, label: '标准'),
    FontSizeItem(id: 2, value: FontSizeEnum.large, label: '大'),
    FontSizeItem(id: 3, value: FontSizeEnum.xl, label: '特大'),
  ];

  final selectedId = '1'.obs;

  final currentRatio = 1.0.obs;

  PreferenceUtils? _prefs;

  final WindowModel windowModel = StorageUtils.connect(
    create: () => WindowModel(),
    type: StorageType.appStorage,
  );

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 100), () {
      _prefs = PreferenceUtils.getInstance(fileName: 'font_size_settings');
      _loadSettings();
    });
  }

  /// 加载设置
  Future<void> _loadSettings() async {
    final savedRatio = SettingModel.getInstance().fontSizeRatio;
    currentRatio.value = savedRatio;

    if (_prefs != null) {
      final savedSelectedId = _prefs!.get('selected_id', defaultValue: '1');
      selectedId.value = savedSelectedId;
    }
  }

  /// 保存设置
  Future<void> _saveSettings() async {
    if (_prefs != null) {
      await _prefs!.put('font_size_ratio', currentRatio.value);
      await _prefs!.put('selected_id', selectedId.value);
    }
  }

  /// 切换按钮
  void switchButton(String id) {
    selectedId.value = id;
    _saveSettings();
  }

  /// 更新字体比例
  void updateFontRatio(double ratio) {
    currentRatio.value = ratio;
    _saveSettings();
  }

  /// 确认字体大小设置
  void confirm(double ratio) {
    currentRatio.value = ratio;
    SettingModel.getInstance().fontSizeRatio = ratio;
    _saveSettings();
    Navigator.of(GlobalContext.context).pop();
    toast('字号设置已成功');
  }

  /// 显示列表样例
  bool get showListSample => selectedId.value == '1';

  /// 获取字体大小
  FontSizeEnum getFontSize(int index) {
    if (index >= 0 && index < fontSizeList.length) {
      return fontSizeList[index].value;
    }
    return FontSizeEnum.normal;
  }

  /// 获取字体大小标签
  String getFontSizeLabel(int index) {
    if (index >= 0 && index < fontSizeList.length) {
      return fontSizeList[index].label;
    }
    return '标准';
  }

  /// 根据比例获取字体大小索引
  int getRatioIndex(double ratio) {
    for (int i = 0; i < fontSizeList.length; i++) {
      if ((fontSizeList[i].value.value - ratio).abs() < 0.01) {
        return i;
      }
    }
    return 1; 
  }
}
