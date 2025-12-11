
library business_setting;

// Types - 对齐鸿蒙原生
export 'types/types.dart';

// ViewModels - 对齐鸿蒙原生
export 'viewmodels/setting_vm.dart';
export 'viewmodels/setting_network_vm.dart';
export 'viewmodels/setting_privacy_vm.dart';
export 'viewmodels/setting_personal_vm.dart';


// Pages - 对齐鸿蒙原生
export 'pages/setting_page.dart';
export 'pages/setting_network.dart';
export 'pages/setting_privacy.dart';
export 'pages/setting_personal.dart';
export 'pages/setting_about.dart';

// Components - 对齐鸿蒙原生
export 'components/setting_card.dart';


// Data
export 'data/protocol_data.dart';
export 'data/protocol_data_harmonyos.dart';


import 'business_setting_platform_interface.dart';


class BusinessSetting {
  Future<String?> getPlatformVersion() {
    return BusinessSettingPlatform.instance.getPlatformVersion();
  }
}

