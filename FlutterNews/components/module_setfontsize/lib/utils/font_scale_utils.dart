import 'package:lib_common/models/setting_model.dart';

class FontScaleUtils {
  FontScaleUtils._();

  static double get fontSizeRatio {
    try {
      return SettingModel.getInstance().fontSizeRatio;
    } catch (e) {
      return 1.0;
    }
  }
}
