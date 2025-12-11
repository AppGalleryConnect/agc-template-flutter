import 'dart:async';

/// 不需要异步处理的方法名列表
const List<String> excludeMethods = [
  'queryRootComment',
];

/// 异步操作工具类
class AsyncUtils {
  static Future<T> wrapAsync<T>(T Function() func, {int delay = 200}) async {
    return Future.delayed(
      Duration(milliseconds: delay),
      () => func(),
    );
  }

  static Future<T> wrapAsyncWithArgs<T, A>(T Function(A) func, A args,
      {int delay = 200}) async {
    return Future.delayed(
      Duration(milliseconds: delay),
      () => func(args),
    );
  }
}

/// 异步方法包装器混合类
mixin AsyncWrapper {
  Future<T> asAsync<T>(String methodName, T Function() method,
      {int delay = 200}) async {
    if (excludeMethods.contains(methodName)) {
      return method();
    }
    return Future.delayed(
      Duration(milliseconds: delay),
      () => method(),
    );
  }
}

/// 异步类生成器
class AsyncClassFactory {
  static T createAsyncInstance<T>(T instance, List<String> asyncMethods,
      {int delay = 200}) {
    return instance;
  }
}

/// 异步方法装饰器函数
Future<T> asyncFunc<T>(T Function() func, {int delay = 200}) async {
  return Future.delayed(
    Duration(milliseconds: delay),
    () => func(),
  );
}
