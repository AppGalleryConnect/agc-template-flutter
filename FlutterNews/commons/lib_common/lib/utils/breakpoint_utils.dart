import 'package:flutter/services.dart';
import 'package:lib_common/lib_common.dart';
import 'package:get/get.dart';

enum BreakpointName { sm, md, lg, xl }

class BreakpointController extends GetxController {
  final Rx<BreakpointName> currentBreakpoint = BreakpointName.sm.obs;
  final RxInt lanes = 1.obs;

  @override
  void onInit() {
    super.onInit();
    ever(currentBreakpoint, (BreakpointName newBreakpoint) {
      lanes.value = _calculateLanes(newBreakpoint);
      Logger.info('【响应式lanes更新】断点=$newBreakpoint，lanes=${lanes.value}');
    });
  }

  int _calculateLanes(BreakpointName breakpoint) {
    switch (breakpoint) {
      case BreakpointName.sm:
        return 1;
      case BreakpointName.md:
        return 2;
      case BreakpointName.lg:
      case BreakpointName.xl:
        return 3;
    }
  }

  bool get isTabVertical {
    return currentBreakpoint.value == BreakpointName.lg ||
        currentBreakpoint.value == BreakpointName.xl;
  }

  void setBreakpointByString(String value) {
    BreakpointName newBreakpoint = BreakpointName.sm;
    Logger.info('currentBreakpoint.value，结果: ${value}');
    switch (value.toLowerCase()) {
      case 'sm':
        newBreakpoint = BreakpointName.sm;
        break;
      case 'md':
        newBreakpoint = BreakpointName.md;
        break;
      case 'lg':
        newBreakpoint = BreakpointName.lg;
        break;
      case 'xl':
        newBreakpoint = BreakpointName.xl;
        break;
    }
    currentBreakpoint.value = newBreakpoint;
  }
}

/// 断点工具类
class BreakponitUtils {
  static const MethodChannel _breakponitChannel =
      MethodChannel('com.news.flutter/breakpointChange');
  static late final BreakpointController breakpointCtrl;

  // 初始化断点
  static Future<void> initBreakponit() async {
    breakpointCtrl = Get.find<BreakpointController>();
    _breakponitChannel.setMethodCallHandler(flutterMethod);
  }

  static Future<void> flutterMethod(
    MethodCall methodCall,
  ) async {
    switch (methodCall.method) {
      case 'breakpointChange':
        Logger.info('currentBreakpoint.value，结果: ${methodCall.arguments}');
        breakpointCtrl.setBreakpointByString(methodCall.arguments);
        break;
      default:
    }
  }
}
