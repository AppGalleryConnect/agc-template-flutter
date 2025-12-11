import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';

// 监听器类型定义
typedef FoldStatusListener = void Function(bool isFolded,
    {required bool isHover90Degree});
typedef LegacyFoldStatusListener = void Function(bool isFolded);

class FoldScreenUtils {
  static const MethodChannel _methodChannel =
      MethodChannel('com.example.fold_screen');
  static bool _isFoldableDevice = false;
  static bool _isInFoldMode = false;
  static bool _isHover90Degree = false; // 标识是否处于90度悬停状态
  static bool _isHarmonyOS = false; // 标识是否为鸿蒙系统

  // 获取是否为鸿蒙系统的公开方法
  static bool get isHarmonyOS => _isHarmonyOS;
  static StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  static double _currentAngle = 0.0;
  static final List<dynamic> _foldStatusListeners = [];
  static int _angleSampleCount = 0; // 用于跟踪角度采样次数
  static final List<double> _recentAngles = []; // 用于存储最近的角度值，实现平滑处理

  // 初始化折叠屏检测
  static Future<void> initialize(BuildContext context) async {
    // 保留初始化开始的日志
    // print('===== FoldScreenUtils.initialize() 开始初始化 =====');
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    // 检测是否为鸿蒙设备 - 统一的检测入口
    _isHarmonyOS = await _detectHarmonyOS(context, deviceInfo);

    if (_isHarmonyOS) {
      // print('===== 检测到鸿蒙系统 =====');
      // 继续执行鸿蒙设备相关初始化
      await _initializeHarmonyDevice(context, deviceInfo);
    } else {
      print('非鸿蒙设备，跳过折叠屏特殊处理');
    }

    // 初始化完成后，强制更新一次当前状态
    // print('===== FoldScreenUtils.initialize() 初始化完成 =====');
    print('初始化结果 - 鸿蒙设备: $_isHarmonyOS, 折叠屏设备: $_isFoldableDevice');
  }

  // 专门用于检测鸿蒙系统的方法
  static Future<bool> _detectHarmonyOS(
      BuildContext context, DeviceInfoPlugin deviceInfo) async {
    // 多维度检测策略
    try {
      // 1. 平台类型检测 - 最直接准确的方式
      if (Theme.of(context).platform == TargetPlatform.ohos) {
        // print('检测1 - 通过TargetPlatform.ohos确认鸿蒙系统');
        return true;
      }

      // 2. 华为设备检测 - 对于华为设备默认启用鸿蒙模式
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        final manufacturer = androidInfo.manufacturer.toLowerCase() ?? '';

        if (manufacturer.contains('huawei') || manufacturer.contains('honor')) {
          // 收集设备信息用于更精确的判断
          final model = androidInfo.model.toLowerCase() ?? '';
          final version = androidInfo.version.release ?? '';

          print('检测2 - 识别华为设备: 厂商=$manufacturer, 型号=$model, 系统版本=$version');

          // 华为设备型号关键词库
          final harmonyDeviceKeywords = [
            'harmony', // 系统名称
            'mate x', 'mate xs', 'mate x2', 'mate x3', 'mate x5', // Mate X系列
            'pocket', 'p50 pocket', 'p60 pocket', // 口袋系列
            'magic v', 'magic vs', 'magic v2', // 荣耀折叠屏
            'foldable', // 通用折叠屏标识
            'fold', // 折叠屏标识
          ];

          // 检查型号是否包含鸿蒙折叠屏关键词
          for (var keyword in harmonyDeviceKeywords) {
            if (model.contains(keyword) || version.contains(keyword)) {
              // print('检测3 - 设备型号或系统包含鸿蒙折叠屏关键词: $keyword');
              return true;
            }
          }

          // 华为设备默认使用鸿蒙兼容模式
          // print('检测4 - 华为设备强制启用鸿蒙兼容模式');
          return true;
        }
      }
    } catch (e) {
      print('鸿蒙系统检测出错: $e');
    }

    return false;
  }

  // 鸿蒙设备初始化方法
  static Future<void> _initializeHarmonyDevice(
      BuildContext context, DeviceInfoPlugin deviceInfo) async {
    try {
      // 1. 尝试使用原生API检测折叠屏
      bool isFoldable = await _detectFoldableDeviceWithNativeAPI();

      // 2. 如果原生API失败，使用屏幕尺寸检测作为备选
      if (!isFoldable) {
        Size screenSize = MediaQuery.of(context).size;
        isFoldable = _detectHarmonyFoldableDimensions(screenSize);
      }

      _isFoldableDevice = isFoldable;
      // print('最终折叠屏设备检测结果: $_isFoldableDevice');

      // 仅在确认是折叠屏设备时继续初始化
      if (_isFoldableDevice) {
        // print('鸿蒙折叠屏设备已确认，开始监听折叠状态');

        // 设置原生回调处理器
        _setupHarmonyNativeCallbacks();

        // 启动加速计监听
        _startAccelerometerListening(isHarmonyOS: true);

        // 立即触发一次状态检查
        _manualCheckHoverState();

        // 设置定时状态检查，提高灵敏度
        // print('设置定时状态检查，每500ms执行一次');
        Timer.periodic(const Duration(milliseconds: 500), (timer) {
          _manualCheckHoverState();
        });
      }
    } catch (e) {
      print('鸿蒙设备初始化出错: $e');
    }
  }

  // 使用原生API检测折叠屏设备
  static Future<bool> _detectFoldableDeviceWithNativeAPI() async {
    try {
      // 优先尝试鸿蒙特定API
      try {
        bool result = await _methodChannel.invokeMethod('FolderStack');
        // print('原生API检测1 (FolderStack): $result');
        return result;
      } catch (e) {
        // print('原生API (FolderStack) 不可用: $e');

        // 回退到通用折叠屏检测API
        try {
          bool result = await _methodChannel.invokeMethod('isFoldableDevice');
          // print('原生API检测2 (isFoldableDevice): $result');
          return result;
        } catch (innerE) {
          // print('原生API (isFoldableDevice) 不可用: $innerE');
          return false;
        }
      }
    } catch (e) {
      // print('原生API检测失败: $e');
      return false;
    }
  }

  // 设置鸿蒙原生回调处理器
  static void _setupHarmonyNativeCallbacks() {
    try {
      //  print('设置鸿蒙原生回调处理器');
      _methodChannel.setMethodCallHandler((call) async {
        try {
          if (call.method == 'onHarmonyFoldStatusChanged' ||
              call.method == 'onFoldStatusChanged') {
            // 安全解析参数
            bool isFolded =
                call.arguments is Map && call.arguments.containsKey('isFolded')
                    ? call.arguments['isFolded'] ?? false
                    : false;

            bool isHover90 =
                call.arguments is Map && call.arguments.containsKey('isHover90')
                    ? call.arguments['isHover90'] ?? false
                    : false;

            // 更新状态
            if (isHover90) {
              _isInFoldMode = true;
              _isHover90Degree = true;
            } else {
              _isInFoldMode = isFolded;
              _isHover90Degree = false;
            }

            // 通知所有监听器
            _notifyFoldStatusListeners(_isInFoldMode);
          }
        } catch (e) {
          print('处理原生回调出错: $e');
        }
      });
    } catch (e) {
      print('设置鸿蒙原生回调处理器失败: $e');
    }
  }

  // 检测鸿蒙设备折叠屏尺寸特征
  static bool _detectHarmonyFoldableDimensions(Size screenSize) {
    double width = screenSize.width;
    double height = screenSize.height;
    double aspectRatio = screenSize.aspectRatio;

    // 规范化尺寸，确保宽小于高（便于统一判断）
    if (width > height) {
      double temp = width;
      width = height;
      height = temp;
      aspectRatio = width / height;
    }

    // print('屏幕尺寸分析: 宽=$width, 高=$height, 宽高比=$aspectRatio');

    // 1. 华为折叠屏设备特定尺寸特征库
    final List<Map<String, dynamic>> foldableDevicePatterns = [
      // Mate X 系列展开状态
      {'minWidth': 1200, 'maxWidth': 1400, 'minRatio': 0.43, 'maxRatio': 0.55},
      // Mate X 系列折叠状态
      {'minWidth': 350, 'maxWidth': 450, 'minHeight': 700, 'maxHeight': 900},
      // P50/P60 Pocket 系列
      {'minWidth': 370, 'maxWidth': 450, 'minHeight': 750, 'maxHeight': 850},
      // 荣耀 Magic V 系列
      {'minWidth': 650, 'maxWidth': 750, 'minHeight': 1200, 'maxHeight': 1300},
      // 90度悬停状态特征
      {
        'minWidth': 300,
        'maxWidth': 450,
        'minHeight': 700,
        'maxHeight': 850,
        'minRatio': 0.35,
        'maxRatio': 0.65
      }
    ];

    // 检查是否匹配任何已知折叠屏尺寸模式
    for (var pattern in foldableDevicePatterns) {
      if (_matchesDevicePattern(width, height, aspectRatio, pattern)) {
        print('匹配到折叠屏尺寸模式: $pattern');
        return true;
      }
    }

    // 2. 通用折叠屏特征检测 - 大屏且宽高比特殊
    bool isLargeScreen = width >= 700 || height >= 1400;
    bool hasSpecialRatio = aspectRatio >= 0.4 && aspectRatio <= 2.5;
    bool isFoldableGeneral = isLargeScreen && hasSpecialRatio;

    if (isFoldableGeneral) {
      print('匹配通用折叠屏特征');
      return true;
    }

    print('未匹配到折叠屏特征');
    return false;
  }

  // 辅助方法：检查设备尺寸是否匹配指定模式
  static bool _matchesDevicePattern(double width, double height,
      double aspectRatio, Map<String, dynamic> pattern) {
    bool matches = true;

    if (pattern.containsKey('minWidth') && width < pattern['minWidth']) {
      matches = false;
    }
    if (pattern.containsKey('maxWidth') && width > pattern['maxWidth']) {
      matches = false;
    }
    if (pattern.containsKey('minHeight') && height < pattern['minHeight']) {
      matches = false;
    }
    if (pattern.containsKey('maxHeight') && height > pattern['maxHeight']) {
      matches = false;
    }
    if (pattern.containsKey('minRatio') && aspectRatio < pattern['minRatio']) {
      matches = false;
    }
    if (pattern.containsKey('maxRatio') && aspectRatio > pattern['maxRatio']) {
      matches = false;
    }

    return matches;
  }

  // 计算设备角度
  static double _calculateAngle(double x, double y, double z,
      [bool isHarmonyDevice = false]) {
    try {
      // 计算重力向量的大小
      double gravity = sqrt(x * x + y * y + z * z);

      // 防止除以零错误
      if (gravity == 0 || gravity.isNaN || gravity.isInfinite) {
        print('重力加速度为零或无效，返回默认角度90度');
        return 90.0;
      }

      // 归一化重力向量
      double normalizedX = x / gravity;
      double normalizedY = y / gravity;
      double normalizedZ = z / gravity;

      if (isHarmonyDevice) {
        return _calculateHarmonyDeviceAngle(
            normalizedX, normalizedY, normalizedZ);
      } else {
        // 非鸿蒙设备使用标准角度计算
        double angle = acos(normalizedZ.abs()) * 180.0 / pi;
        // 确保角度在合理范围内
        return angle.isNaN || angle.isInfinite ? 0.0 : angle;
      }
    } catch (e) {
      print('计算角度出错: $e');
      return 90.0; // 返回一个合理的默认值
    }
  }

  // 专门用于鸿蒙设备的角度计算方法
  static double _calculateHarmonyDeviceAngle(
      double normalizedX, double normalizedY, double normalizedZ) {
    // 计算水平分量的强度
    double horizontalStrength =
        sqrt(normalizedX * normalizedX + normalizedY * normalizedY);

    // 计算设备与水平面的夹角
    double angle = acos(normalizedZ.abs()) * 180.0 / pi;

    // 特殊情况处理1: 当z值较小时，强制返回接近90度的值
    if (normalizedZ.abs() < 0.5) {
      return 90.0 - (normalizedZ.abs() * 40.0);
    }

    // 特殊情况处理2: 当xy分量足够大且z分量足够小时，直接返回90度附近的值
    double xyStrength =
        sqrt(normalizedX * normalizedX + normalizedY * normalizedY);
    if (xyStrength > 0.7 && normalizedZ.abs() < 0.7) {
      return 90.0 + (Random().nextDouble() - 0.5) * 2.0;
    }

    // 水平分量检测校准
    if (horizontalStrength > 0.1) {
      double adjustmentFactor = min(1.0, (horizontalStrength - 0.1) * 2.5);
      angle = 90.0 + (angle - 90.0) * (1.0 - adjustmentFactor * 0.95);
    }

    // 确保角度在合理范围内
    return angle.isNaN || angle.isInfinite ? 90.0 : angle;
  }

  // 计算平滑后的角度值
  static double _calculateSmoothedAngle(List<double> recentAngles) {
    if (recentAngles.isEmpty) return 0.0;

    // 计算加权平均值
    double sum = 0.0;
    double totalWeight = 0.0;

    for (int i = 0; i < recentAngles.length; i++) {
      double angle = recentAngles[i];
      // 基本时间权重 - 最新的数据权重最高
      double timeWeight = (i + 1) * 2.0;

      // 90度增强权重 - 越接近90度，权重越高
      double angleWeight = 1.0;
      if (angle >= 45 && angle <= 135) {
        double distanceFrom90 = (90.0 - angle).abs();
        angleWeight =
            1.0 + (1.0 - distanceFrom90 / 45.0) * 2.0; // 简化权重范围到1.0-3.0
      }

      // 计算最终权重
      double finalWeight = timeWeight * angleWeight;
      sum += angle * finalWeight;
      totalWeight += finalWeight;
    }

    double weightedAverage = sum / totalWeight;

    // 对于鸿蒙设备接近90度的值，进行适度的平滑处理
    if (_isHarmonyOS && weightedAverage >= 45 && weightedAverage <= 135) {
      double distanceFrom90 = (90.0 - weightedAverage).abs();
      double adjustmentFactor = 1.0 - min(1.0, distanceFrom90 / 60.0);
      double adjustment =
          (90.0 - weightedAverage) * (0.5 + adjustmentFactor * 0.3);
      weightedAverage = weightedAverage + adjustment;
    }

    return weightedAverage;
  }

  // 通知折叠状态监听器
  static void _notifyFoldStatusListeners(bool isFolded) {
    // 仅初始化时打印通知信息
    if (_angleSampleCount < 5) {
      print(
          '通知折叠状态监听器 - 折叠状态: $isFolded, 90度悬停: $_isHover90Degree, 监听器数量: ${_foldStatusListeners.length}');
    }

    // 使用迭代器安全遍历，避免并发修改问题
    List<dynamic> listenersCopy = List.from(_foldStatusListeners);
    for (int i = 0; i < listenersCopy.length; i++) {
      _safeCallListener(listenersCopy[i], isFolded, i);
    }
  }

  // 安全调用监听器方法，避免单个监听器错误影响整个流程
  static void _safeCallListener(dynamic listener, bool isFolded, int index) {
    try {
      // 智能类型检测和调用
      if (listener is FoldStatusListener) {
        // 使用命名参数的新接口
        listener(isFolded, isHover90Degree: _isHover90Degree);
      } else if (listener is LegacyFoldStatusListener) {
        // 传统接口
        listener(isFolded);
      } else if (listener is Function) {
        try {
          // 尝试调用带命名参数的方法
          Function.apply(listener, [isFolded],
              {const Symbol('isHover90Degree'): _isHover90Degree});
        } catch (_) {
          // 回退到传统调用方式
          try {
            Function.apply(listener, [isFolded]);
          } catch (e) {
            if (_angleSampleCount < 5) {
              print('监听器调用失败: $e');
            }
          }
        }
      }
    } catch (e) {
      // 捕获并记录监听器执行错误，但不中断循环
      if (_angleSampleCount < 5) {
        print('监听器[$index]执行出错: $e');
      }
    }
  }

  // 添加折叠状态监听器
  static void addFoldStatusListener(dynamic listener) {
    // 验证监听器类型
    if (listener == null || listener is! Function) {
      print('警告: 尝试添加无效的监听器');
      return;
    }

    // 避免重复添加
    if (!_foldStatusListeners.contains(listener)) {
      _foldStatusListeners.add(listener);
      if (_angleSampleCount < 5) {
        print('添加折叠状态监听器，当前数量: ${_foldStatusListeners.length}');
      }

      // 立即通知当前状态
      _safeCallListener(listener, _isInFoldMode, -1);
    } else if (_angleSampleCount < 5) {
      print('监听器已存在，跳过添加');
    }
  }

  // 移除折叠状态监听器
  static void removeFoldStatusListener(dynamic listener) {
    if (listener == null) {
      print('警告: 尝试移除null监听器');
      return;
    }

    bool removed = _foldStatusListeners.remove(listener);
    if (removed && _angleSampleCount < 5) {
      print('移除折叠状态监听器，剩余数量: ${_foldStatusListeners.length}');
    }
  }

  // 清空所有监听器
  static void clearAllListeners() {
    _foldStatusListeners.clear();
    if (_angleSampleCount < 5) {
      print('所有监听器已清空');
    }
  }

  // 获取当前监听器数量（用于调试）
  static int get listenerCount => _foldStatusListeners.length;

  // 强制设置90度悬停状态（用于调试）
  static void forceSetHover90State(bool isHover90) {
    bool previousState = _isHover90Degree;
    _isHover90Degree = isHover90;
    _isInFoldMode = isHover90;

    print('===== 强制设置90度悬停状态 =====');
    print('从 $previousState 变更为 $isHover90');

    if (previousState != isHover90) {
      _notifyFoldStatusListeners(isHover90);
    }
  }

  // 手动检查悬停状态
  static void _manualCheckHoverState({bool? forceHover}) {
    // 只有初始化阶段保留关键日志
    if (_angleSampleCount < 5) {
      print('FoldScreenUtils: 手动检查悬停状态开始');
    }

    // 如果提供了强制状态，则直接设置
    if (forceHover != null) {
      _updateHoverState(forceHover);
      return;
    }

    // 立即获取一次加速计数据进行实时检测
    getCurrentAccelerometerData().then((data) {
      _analyzeAccelerometerData(data);
    });
  }

  // 更新悬停状态并通知监听器
  static void _updateHoverState(bool newState) {
    bool previousState = _isHover90Degree;
    _isInFoldMode = newState;
    _isHover90Degree = newState;

    if (previousState != newState && _angleSampleCount < 5) {
      print('FoldScreenUtils: 状态变化，通知监听器');
    }

    if (previousState != newState) {
      _notifyFoldStatusListeners(_isInFoldMode);
    }
  }

  // 分析加速计数据并更新状态
  static void _analyzeAccelerometerData(Map<String, double> data) {
    double x = data['x'] ?? 0.0;
    double y = data['y'] ?? 0.0;
    double z = data['z'] ?? 0.0;
    double calculatedAngle = data['calculatedAngle'] ?? 0.0;

    // 检测数据是否异常（全0或非常接近0）
    bool isDataAbnormal = x.abs() < 0.1 && y.abs() < 0.1 && z.abs() < 0.1;

    // 初始化阶段保留部分关键信息日志
    if (isDataAbnormal && _angleSampleCount < 5) {
      print('FoldScreenUtils: 检测到异常数据');
    }

    // 多重检测条件
    bool isNear90Degrees = _isHarmonyOS
        ? (calculatedAngle >= 45 && calculatedAngle <= 135)
        : (calculatedAngle >= 80 && calculatedAngle <= 100);

    // 水平分量检测
    double gravity = sqrt(x * x + y * y + z * z);
    double horizontalStrength = gravity > 0 ? sqrt(x * x + y * y) / gravity : 0;
    bool hasStrongHorizontalComponent = horizontalStrength > 0.6;

    // 综合判断条件
    bool shouldBeHover90 = false;

    // 如果数据异常，采用特殊处理策略
    if (isDataAbnormal) {
      // 对于鸿蒙设备，如果检测到数据异常，采用更保守的策略
      if (_isHarmonyOS) {
        // 如果当前已经是悬停状态，保持悬停状态
        shouldBeHover90 = _isHover90Degree;
      }
    } else {
      // 正常数据的判断逻辑
      shouldBeHover90 =
          _isHarmonyOS && (isNear90Degrees || hasStrongHorizontalComponent);
    }

    // 强制更新状态
    bool previousState = _isHover90Degree;

    // 更新逻辑
    if (shouldBeHover90) {
      _isInFoldMode = true;
      _isHover90Degree = true;
    }
    // 只有在角度完全不符合且水平分量很弱且数据正常时才退出悬停状态
    else if (!isDataAbnormal &&
        _isHarmonyOS &&
        calculatedAngle < 30 &&
        calculatedAngle > 160 &&
        horizontalStrength < 0.3) {
      _isInFoldMode = false;
      _isHover90Degree = false;
    }

    // 通知监听器
    if (previousState != _isHover90Degree) {
      _notifyFoldStatusListeners(_isInFoldMode);
    }
  }

  // 调试方法：获取当前加速计原始数据
  static Future<Map<String, double>> getCurrentAccelerometerData() async {
    try {
      Completer<Map<String, double>> completer = Completer();
      StreamSubscription? subscription;

      // 使用与_startAccelerometerListening方法相同的采样间隔参数
      int sampleInterval = _isHarmonyOS ? 15 : 80;

      // 仅初始化时打印日志，避免高频调用
      if (_angleSampleCount < 5) {
        print('获取加速计数据 - 采样间隔: $sampleInterval ms');
      }

      subscription = accelerometerEventStream(
              samplingPeriod: Duration(milliseconds: sampleInterval))
          .listen((event) {
        _processAccelerometerEvent(event, completer, subscription);
      }, onError: (error) {
        _handleAccelerometerError(error, completer, subscription);
      }, onDone: () {
        _handleAccelerometerStreamDone(completer);
      });

      // 超时处理
      Timer(const Duration(milliseconds: 500), () {
        _handleAccelerometerTimeout(completer, subscription);
      });

      return await completer.future;
    } catch (e) {
      // 捕获所有可能的异常
      if (_angleSampleCount < 5) {
        print('获取加速计数据异常: $e');
      }

      // 返回默认值
      return _getDefaultAccelerometerData();
    }
  }

  // 处理加速计事件
  static void _processAccelerometerEvent(
      AccelerometerEvent event,
      Completer<Map<String, double>> completer,
      StreamSubscription? subscription) {
    // 验证数据有效性
    if (event.x.isNaN ||
        event.y.isNaN ||
        event.z.isNaN ||
        event.x.isInfinite ||
        event.y.isInfinite ||
        event.z.isInfinite) {
      if (_angleSampleCount < 5) {
        print('获取到无效加速计数据，使用默认值');
      }

      completer.complete(_getDefaultAccelerometerData());
      subscription?.cancel();
      return;
    }

    Map<String, double> data = {
      'x': event.x,
      'y': event.y,
      'z': event.z,
      'calculatedAngle':
          _calculateAngle(event.x, event.y, event.z, _isHarmonyOS)
    };

    // 仅初始化时打印详细数据
    if (_angleSampleCount < 5) {
      print('成功获取加速计数据: x=${event.x}, y=${event.y}, z=${event.z}');
    }

    completer.complete(data);
    subscription?.cancel();
  }

  // 处理加速计错误
  static void _handleAccelerometerError(
      dynamic error,
      Completer<Map<String, double>> completer,
      StreamSubscription? subscription) {
    // 错误处理增强
    if (_angleSampleCount < 5) {
      print('加速计数据流错误: $error');
    }

    // 根据当前状态和设备类型返回差异化的默认值
    double defaultAngle = _isHover90Degree ? 90.0 : 0.0;
    double x, y, z;

    // 针对鸿蒙设备使用不同的默认值策略
    if (_isHarmonyOS) {
      // 鸿蒙设备默认更接近90度的状态
      x = _isHover90Degree ? 9.8 : 0.0; // 模拟更真实的重力值
      y = 0.0;
      z = _isHover90Degree ? 0.0 : 9.8;
    } else {
      // 非鸿蒙设备的标准默认值
      x = _isHover90Degree ? 1.0 : 0.0;
      y = _isHover90Degree ? 0.0 : 0.0;
      z = _isHover90Degree ? 0.0 : 1.0;
    }

    completer
        .complete({'x': x, 'y': y, 'z': z, 'calculatedAngle': defaultAngle});
    subscription?.cancel();
  }

  // 处理加速计流关闭
  static void _handleAccelerometerStreamDone(
      Completer<Map<String, double>> completer) {
    // 流意外关闭时的处理
    if (!completer.isCompleted) {
      if (_angleSampleCount < 5) {
        print('加速计数据流意外关闭');
      }

      completer.complete(_getDefaultAccelerometerData());
    }
  }

  // 处理加速计超时
  static void _handleAccelerometerTimeout(
      Completer<Map<String, double>> completer,
      StreamSubscription? subscription) {
    if (!completer.isCompleted) {
      if (_angleSampleCount < 5) {
        print('加速计数据获取超时');
      }

      completer.complete(_getDefaultAccelerometerData());
      subscription?.cancel();
    }
  }

  // 获取默认加速计数据
  static Map<String, double> _getDefaultAccelerometerData() {
    double defaultAngle = _isHover90Degree ? 90.0 : 0.0;
    return {
      'x': _isHover90Degree ? 1.0 : 0.0,
      'y': _isHover90Degree ? 0.0 : 0.0,
      'z': _isHover90Degree ? 0.0 : 1.0,
      'calculatedAngle': defaultAngle
    };
  }

  // 清理资源
  static void dispose() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _foldStatusListeners.clear();
  }

  // 获取当前是否处于折叠模式
  static bool get isInFoldMode => _isInFoldMode;

  // 获取当前设备角度
  static double get currentAngle => _currentAngle;

  // 获取是否为折叠屏设备
  static bool get isFoldableDevice => _isFoldableDevice;

  // 手动更新折叠状态（用于调试或特殊情况）
  static void updateFoldStatus(bool isFolded, {bool? isHover90}) {
    print('===== updateFoldStatus() 手动更新状态 =====');
    bool previousHoverState = _isHover90Degree;

    // 更新折叠状态
    _isInFoldMode = isFolded;

    // 如果提供了isHover90参数，则更新90度悬停状态
    if (isHover90 != null) {
      _isHover90Degree = isHover90;
      print('手动设置90度悬停状态: $isHover90 (之前: $previousHoverState)');
    } else {
      // 当未提供isHover90参数时，默认设置为非悬停状态
      _isHover90Degree = false;
    }

    print('手动更新折叠状态: 折叠=$isFolded, 90度悬停=$_isHover90Degree');

    // 状态发生变化时通知监听器
    if (_isHover90Degree != previousHoverState) {
      print('状态发生变化，通知所有监听器');
      _notifyFoldStatusListeners(_isInFoldMode);
    }
  }

  // 获取是否处于90度悬停状态 - 简化版本，仅在调试模式下打印日志
  static bool get isHover90Degree {
    // 在调试场景下添加详细的状态日志
    if (_angleSampleCount < 5 || _isInFoldMode) {
      print('===== 访问isHover90Degree =====');
      print('当前90度悬停状态: $_isHover90Degree');
      print('设备信息 - 鸿蒙设备: $_isHarmonyOS, 折叠屏设备: $_isFoldableDevice');
      print('当前折叠模式: $_isInFoldMode');
      print('最近角度值: $_currentAngle°');
      print('加速计订阅状态: ${_accelerometerSubscription != null ? "已订阅" : "未订阅"}');
      print('============================');
    }
    return _isHover90Degree;
  }

  // 开始监听加速计
  static void _startAccelerometerListening({bool isHarmonyOS = false}) {
    // 只保留必要的初始化日志
    if (_accelerometerSubscription == null) {
      print('===== FoldScreenUtils: 开始加速计监听 =====');
    }

    // 避免重复订阅
    if (_accelerometerSubscription != null) {
      _accelerometerSubscription?.cancel();
      _recentAngles.clear(); // 清除历史角度数据
      _angleSampleCount = 0;
    }

    // 增强的配置参数
    int sampleInterval = isHarmonyOS ? 15 : 80;
    double lowerThreshold = isHarmonyOS ? 30.0 : 85.0;
    double upperThreshold = isHarmonyOS ? 150.0 : 95.0;
    int stabilityThreshold = isHarmonyOS ? 1 : 2;
    int maxRecentAngles = isHarmonyOS ? 7 : 3;

    // 稳定性参数
    int consecutiveInRangeCount = 0;
    int consecutiveOutOfRangeCount = 0;

    // 使用正确的参数格式调用accelerometerEventStream
    _accelerometerSubscription = accelerometerEventStream(
            samplingPeriod: Duration(milliseconds: sampleInterval))
        .listen((AccelerometerEvent event) {
      _angleSampleCount++;

      // 计算设备与水平面的夹角 - 对于鸿蒙设备使用优化的角度计算
      double angle = _calculateAngle(event.x, event.y, event.z, isHarmonyOS);

      // 添加到历史角度列表，用于平滑处理
      _recentAngles.add(angle);
      if (_recentAngles.length > maxRecentAngles) {
        _recentAngles.removeAt(0);
      }

      // 计算平滑后的角度
      double smoothedAngle = _calculateSmoothedAngle(_recentAngles);
      _currentAngle = smoothedAngle;

      // 检测是否在90度左右
      bool isNear90Degrees =
          smoothedAngle > lowerThreshold && smoothedAngle < upperThreshold;

      // 增强的角度范围检测
      bool isVeryCloseTo90 = smoothedAngle >= 80 && smoothedAngle <= 100;
      bool isExtremelyCloseTo90 = smoothedAngle >= 85 && smoothedAngle <= 95;

      if (isHarmonyOS) {
        // 增强的鸿蒙设备防抖逻辑
        if (isNear90Degrees) {
          consecutiveInRangeCount++;
          consecutiveOutOfRangeCount = 0;

          // 计算水平分量强度
          double horizontalStrength =
              sqrt(event.x * event.x + event.y * event.y);
          double totalStrength =
              sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          double normalizedHorizontal =
              totalStrength > 0 ? horizontalStrength / totalStrength : 0;

          // 状态确认条件
          bool shouldUpdateState =
              consecutiveInRangeCount >= stabilityThreshold ||
                  isVeryCloseTo90 ||
                  isExtremelyCloseTo90 ||
                  normalizedHorizontal > 0.5 ||
                  (_isHover90Degree && isNear90Degrees);

          // 满足稳定性要求，且当前不是90度悬停状态
          if (shouldUpdateState && !_isHover90Degree) {
            _isInFoldMode = true;
            _isHover90Degree = true;
            _notifyFoldStatusListeners(true);
          }
        } else {
          consecutiveOutOfRangeCount++;
          consecutiveInRangeCount = 0;

          // 对于鸿蒙设备，当角度远离90度时的退出条件
          bool isFarFrom90 = (smoothedAngle < 30 || smoothedAngle > 150);
          bool shouldUpdateState =
              consecutiveOutOfRangeCount >= (isFarFrom90 ? 3 : 5) ||
                  isFarFrom90;

          // 满足稳定性要求，且当前是90度悬停状态
          if (shouldUpdateState && _isHover90Degree) {
            _isInFoldMode = false;
            _isHover90Degree = false;
            _notifyFoldStatusListeners(false);
          }
        }
      } else {
        // 非鸿蒙设备使用原有的简单逻辑
        if (_isFoldableDevice && isNear90Degrees && !_isInFoldMode) {
          _isInFoldMode = true;
          _isHover90Degree = true;
          _notifyFoldStatusListeners(true);
        } else if (_isInFoldMode && !isNear90Degrees) {
          _isInFoldMode = false;
          _isHover90Degree = false;
          _notifyFoldStatusListeners(false);
        }
      }
    });
  }
}
