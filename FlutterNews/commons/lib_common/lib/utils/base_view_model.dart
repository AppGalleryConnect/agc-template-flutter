import 'package:flutter/foundation.dart';
import '../models/break_point_model.dart';
import '../models/nav_route_model.dart';
import '../models/network_model.dart';
import '../models/setting_model.dart';
import '../models/tab_model.dart';
import '../models/window_stage_model.dart';
import '../models/userInfo_model.dart';
import '../models/window_model.dart';
import 'storage_utils.dart';
import 'package:lib_account/services/account_api.dart';

/// 所有 ViewModel 的基类
abstract class BaseViewModel with ChangeNotifier {
  /// 窗口信息模型
  final WindowModel windowModel = StorageUtils.connect(
    create: () => WindowModel(),
    type: StorageType.appStorage,
  );

  /// 用户信息模型
  UserInfoModel get userInfoModel => AccountApi.getInstance().userInfoModel;

  /// Tab 模型
  final TabModel tabModel = StorageUtils.connect(
    create: () => TabModel(),
    type: StorageType.appStorage,
  );

  /// 导航路由模型
  final NavRouteModel navRouteModel = StorageUtils.connect(
    create: () => NavRouteModel(),
    type: StorageType.appStorage,
  );

  /// 设置信息模型
  final SettingModel settingInfo = StorageUtils.connect(
    create: () => SettingModel.getInstance(),
    type: StorageType.persistence,
  );

  /// 窗口生命周期模型
  final WindowStageModel windowStageModel = StorageUtils.connect(
    create: () => WindowStageModel(),
    type: StorageType.appStorage,
  );

  /// 断点模型
  final BreakpointModel breakPointModel = StorageUtils.connect(
    create: () => BreakpointModel(),
    type: StorageType.appStorage,
  );

  /// 网络模型
  final NetworkModel networkModel = StorageUtils.connect(
    create: () => NetworkModel.getInstance(),
    type: StorageType.appStorage,
  );

  void init() {}
}
