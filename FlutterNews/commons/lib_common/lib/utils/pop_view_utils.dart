import 'package:flutter/material.dart';
import 'logger.dart';
import './global_context.dart';

const String TAG = '[PopViewUtils]';

enum PopViewShowType {
  open,
}

/// 弹窗参数接口
class PopViewModel {
  final Widget content;
  final PopViewShowType popType;

  PopViewModel({required this.content, required this.popType});
}

/// 全局弹窗类
class PopViewUtils {
  static PopViewUtils? _instance;
  final List<PopViewModel> _infoList = [];
  final List<PopViewModel> _sheetList = [];
  BuildContext? _context;

  static PopViewUtils get instance {
    _instance ??= PopViewUtils();
    return _instance!;
  }

  /// 初始化上下文
  void init(BuildContext context) {
    _context = context;
  }

  /// 打开弹窗
  static Future<void> showPopView<T>({
    required Widget contentView,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    Alignment alignment = Alignment.center,
    EdgeInsets? padding,
  }) async {
    BuildContext? context = instance._context;
    if (context == null) {
      context = GlobalContext.context;
      Logger.info(
          TAG, 'Using GlobalContext since instance context is not initialized');
    }

    // 在显示弹窗前先添加到列表中
    instance._infoList.add(
      PopViewModel(
        content: contentView,
        popType: PopViewShowType.open,
      ),
    );

    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: true,
      builder: (BuildContext context) {
        Widget alignWidget = Align(
          alignment: alignment,
          child: contentView,
        );
        if (padding != null) {
          alignWidget = Padding(padding: padding, child: alignWidget);
        }
        return alignWidget;
      },
    );
  }

  /// 关闭弹窗
  static void closePopView() {
    BuildContext? context = instance._context;
    context ??= GlobalContext.context;
    if (instance._infoList.isEmpty) {
      return;
    }

    Navigator.of(context).pop();
    instance._infoList.removeLast();
  }

  /// 打开底部弹窗
  static Future<void> showSheet<T>({
    required Widget contentView,
    double? height,
    bool useRootNavigator = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    Color? backgroundColor,
    Clip clipBehavior = Clip.none,
    ShapeBorder? shape,
  }) async {
    BuildContext? context = instance._context;
    if (context == null) {
      context = GlobalContext.context;
      Logger.info(TAG, 'Using GlobalContext for bottom sheet');
    }

    // 在显示底部弹窗前先添加到列表中
    instance._sheetList.add(
      PopViewModel(
        content: contentView,
        popType: PopViewShowType.open,
      ),
    );

    await showModalBottomSheet(
      context: context,
      useRootNavigator: useRootNavigator,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? Colors.white,
      clipBehavior: clipBehavior,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
      builder: (BuildContext context) {
        if (height != null) {
          return SizedBox(
            height: height,
            child: contentView,
          );
        }
        return contentView;
      },
    );
  }

  /// 关闭底部弹窗
  static void closeSheet() {
    BuildContext? context = instance._context;
    context ??= GlobalContext.context;
    if (instance._sheetList.isEmpty) {
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    instance._sheetList.removeLast();
  }
}
