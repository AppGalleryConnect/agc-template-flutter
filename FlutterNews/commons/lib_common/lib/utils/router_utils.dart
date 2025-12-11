import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_account/pages/huawei_login_page.dart';
import 'package:lib_account/constants/Types.dart';

const String TAG = '[RouterUtils]';

/// 路由栈枚举
enum StackEnum {
  main,
}

/// 弹窗信息
class PopInfo {
  final dynamic result;
  final String? path;

  PopInfo({required this.result, this.path});
}

/// 导航路径栈
class NavPathStack {
  final List<String> _paths = [];
  final Map<String, List<dynamic>> _params = {};
  final Map<String, Function(PopInfo)?> _callbacks = {};

  /// 按名称推入路径
  void pushPathByName(String name, dynamic param, dynamic animatedOrCallback,
      [bool? animated]) {
    final path = name;
    _paths.add(path);

    if (param != null) {
      if (!_params.containsKey(path)) {
        _params[path] = [];
      }
      _params[path]?.add(param);
    }

    if (animatedOrCallback is Function(PopInfo)) {
      _callbacks[path] = animatedOrCallback;
    } else if (animatedOrCallback is bool) {
      animated = animatedOrCallback;
    }

    Navigator.of(GlobalContext.context).pushNamed(
      path,
      arguments: param,
    );
  }

  /// 按名称替换路径
  void replacePathByName(
    String name,
    dynamic param,
    bool animated,
  ) {
    final path = name;

    if (_paths.isNotEmpty) {
      _paths.removeLast();
    }
    _paths.add(path);

    if (param != null) {
      _params[path] = [param];
    }

    Navigator.of(GlobalContext.context).pushReplacementNamed(
      path,
      arguments: param,
    );
  }

  /// 仅添加路径信息到栈中，不执行导航
  void addPathInfo(String name, dynamic param, Function(PopInfo)? onPop) {
    final path = name;
    _paths.add(path);

    if (param != null) {
      if (!_params.containsKey(path)) {
        _params[path] = [];
      }
      _params[path]?.add(param);
    }

    if (onPop != null) {
      _callbacks[path] = onPop;
    }
  }

  /// 弹出当前页面
  void pop(dynamic resultOrAnimated, [bool? animated]) {
    if (_paths.isEmpty) return;

    final lastPath = _paths.last;
    final callback = _callbacks[lastPath];

    if (resultOrAnimated is bool) {
      animated = resultOrAnimated;
    } else if (resultOrAnimated != null) {
      Navigator.of(GlobalContext.context).pop(resultOrAnimated);

      if (callback != null) {
        callback(PopInfo(result: resultOrAnimated, path: lastPath));
      }

      _paths.removeLast();
      _callbacks.remove(lastPath);
      return;
    }

    Navigator.of(GlobalContext.context).pop();
    _paths.removeLast();
    _callbacks.remove(lastPath);
  }

  /// 弹出到指定页面
  void popToName(RouterMap name, dynamic resultOrAnimated, [bool? animated]) {
    final targetPath = name.toString().split('.').last;
    final index = _paths.indexOf(targetPath);

    if (index == -1) return;

    while (_paths.length > index + 1) {
      final pathToRemove = _paths.last;
      _paths.removeLast();
      _callbacks.remove(pathToRemove);
    }

    if (resultOrAnimated is bool) {
      animated = resultOrAnimated;
    } else if (resultOrAnimated != null) {
      Navigator.of(GlobalContext.context).popUntil((route) {
        return route.settings.name == targetPath;
      });
      return;
    }

    Navigator.of(GlobalContext.context).popUntil((route) {
      return route.settings.name == targetPath;
    });
  }

  /// 按名称获取参数
  List<dynamic> getParamByName(RouterMap name) {
    final path = name.toString().split('.').last;
    return _params[path] ?? [];
  }

  /// 按名称获取参数
  List<dynamic> getParamByNameWithString(String name) {
    return _params[name] ?? [];
  }

  /// 清空栈
  void clear([bool? animated]) {
    _paths.clear();
    _params.clear();
    _callbacks.clear();

    Navigator.of(GlobalContext.context).popUntil((route) => route.isFirst);
  }
}

/// 路由管理类
class RouterUtils {
  static final RouterUtils _instance = RouterUtils._();
  static RouterUtils get of => _instance;

  /// 路由栈Map
  final Map<String, NavPathStack> _stackMap = {
    StackEnum.main.toString().split('.').last: NavPathStack(),
  };

  RouterUtils._();

  /// 创建新栈
  NavPathStack createStack(String stackName, {bool isNew = false}) {
    if (!_stackMap.containsKey(stackName) || isNew) {
      _stackMap[stackName] = NavPathStack();
    }
    return getStack(stackName);
  }

  /// 删除栈
  void deleteStack(String stackName) {
    if (_stackMap.containsKey(stackName)) {
      _stackMap.remove(stackName);
    }
  }

  /// 获取栈
  NavPathStack getStack([String? name]) {
    if (name != null && _stackMap.containsKey(name)) {
      return _stackMap[name]!;
    }
    return _stackMap[StackEnum.main.toString().split('.').last]!;
  }

  /// 简单页面跳转
  void push(String routeName, {dynamic arguments}) {
    Navigator.of(GlobalContext.context)
        .pushNamed(routeName, arguments: arguments);
  }

  /// 简单页面返回
  void pop() {
    Navigator.of(GlobalContext.context).pop();
  }

  /// 跳转页面
  void pushPathByName(String name,
      {dynamic param,
      Function(PopInfo)? onPop,
      bool animated = true,
      String stackName = 'main'}) {
    Logger.info(TAG, 'RouterUtil route: $name, param: $param');

    // 特殊处理半模态登录页面，添加底部滑入动画
    bool isHalfModal = false; // 默认不使用半模态模式
    if (param is Map && param.containsKey('isHalfModal')) {
      isHalfModal = param['isHalfModal'] as bool;
    } else if (param is LoginRouterParams) {
      isHalfModal = param.isHalfModal;
    }

    if (name == RouterMap.HUAWEI_LOGIN_PAGE && isHalfModal) {
      // 创建LoginRouterParams实例，确保类型正确
      LoginRouterParams loginParams;
      if (param is LoginRouterParams) {
        // 确保isHalfModal被设置为true
        loginParams = LoginRouterParams(
          isSheet: param.isSheet,
          keepVM: param.keepVM,
        );
      } else {
        loginParams = LoginRouterParams(
          isSheet: false,
          keepVM: false,
        );
      }
      loginParams.isHalfModal = true;
      Navigator.of(GlobalContext.context)
          .push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.black.withOpacity(0.5),
          barrierDismissible: true,
          pageBuilder: (context, animation, secondaryAnimation) {
            return HuaweiLoginPage(params: loginParams);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);
            final scaleTween = Tween<double>(begin: 0.98, end: 1.0);
            final scaleAnimation = animation.drive(scaleTween);
            return SlideTransition(
              position: offsetAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        ),
      )
          .then((result) {
        if (onPop != null) {
          onPop(PopInfo(result: result, path: name));
        }
      });
      getStack(stackName).addPathInfo(name, param, onPop);
    } else {
      if (onPop != null) {
        getStack(stackName).pushPathByName(name, param, onPop, animated);
      } else {
        getStack(stackName).pushPathByName(name, param, animated);
      }
    }
  }

  /// 更换页面
  void replacePathByName(String name,
      {dynamic param, bool animated = true, String stackName = 'main'}) {
    getStack(stackName).replacePathByName(name, param, animated);
  }

  /// 获取当前路由参数
  dynamic currentRouteArguments(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments;
  }

  /// 返回上一级
  void popWithResult(
      {dynamic result, bool? animated, String stackName = 'main'}) {
    if (result != null) {
      getStack(stackName).pop(result, animated);
    } else {
      getStack(stackName).pop(animated);
    }
  }

  /// 返回指定页面
  void popToName(RouterMap name,
      {dynamic result, bool? animated, String stackName = 'main'}) {
    if (result != null) {
      getStack(stackName).popToName(name, result, animated);
    } else {
      getStack(stackName).popToName(name, animated);
    }
  }

  /// 获取路由参数 - RouterMap版本
  T? getParamByName<T>(RouterMap name, {String stackName = 'main'}) {
    final params = getStack(stackName).getParamByName(name);
    if (params.isNotEmpty && params.last is T) {
      return params.last as T;
    }
    return null;
  }

  /// 获取路由参数 - 字符串版本（兼容旧代码）
  T? getParamByNameWithString<T>(String name, {String stackName = 'main'}) {
    final params = getStack(stackName).getParamByNameWithString(name);
    if (params.isNotEmpty && params.last is T) {
      return params.last as T;
    }
    return null;
  }

  /// 清空栈
  void clearStack({bool? animated, String stackName = 'main'}) {
    getStack(stackName).clear(animated);
  }
}
