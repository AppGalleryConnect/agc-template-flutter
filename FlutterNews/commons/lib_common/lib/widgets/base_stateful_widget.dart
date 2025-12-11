import 'package:flutter/material.dart';
import '../models/setting_model.dart';

/// 基础 StatefulWidget 状态类
abstract class BaseStatefulWidgetState<T extends StatefulWidget>
    extends State<T> {
  /// 全局设置模型
  late final SettingModel settingInfo;

  @override
  void initState() {
    super.initState();
    try {
      settingInfo = SettingModel.getInstance();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          settingInfo.addListener(_onSettingChanged);
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    try {
      settingInfo.removeListener(_onSettingChanged);
    } catch (e) {
      //移除监听时可能会抛出异常，这里简单忽略
    }
    super.dispose();
  }

  /// 设置变化回调
  void _onSettingChanged() {
    if (mounted) {
      try {
        setState(() {});
      } catch (e) {
        // setState 可能会抛出异常，这里简单忽略
      }
    }
  }
}
