import 'package:lib_common/models/setting_model.dart';

/// 字体缩放工具类，与鸿蒙原生完全一致
/// 鸿蒙实现：fontSize(this.labelSize * this.settingInfo.fontSizeRatio)
/// 完全对齐鸿蒙，直接从 SettingModel 单例获取 fontSizeRatio
class FontScaleUtils {
  FontScaleUtils._();

  /// 获取当前字体缩放比例，与鸿蒙 settingInfo.fontSizeRatio 一致
  /// 完全对齐鸿蒙：直接使用全局单例 SettingModel.getInstance().fontSizeRatio
  static double get fontSizeRatio {
    try {
      return SettingModel.getInstance().fontSizeRatio;
    } catch (e) {
      // 如果获取失败，返回默认值
      return 1.0;
    }
  }
}
