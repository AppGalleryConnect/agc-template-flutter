import 'package:flutter/material.dart';
import '../constants/common_constants.dart';
import '../utils/pop_view_utils.dart';

/// Loading 视图组件
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(themeColor),
            strokeWidth: 4,
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: CommonConstants.spaceM),
          Text(
            '加载中',
            style: TextStyle(
              color: themeColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 全局 Loading 弹窗工具类
class CommonLoadingDialog {
  static void show() {
    PopViewUtils.showPopView(
      contentView: const LoadingView(),
      barrierColor: Colors.transparent,
      barrierDismissible: false,
    );
  }

  /// 关闭 Loading 弹窗
  static void close() {
    PopViewUtils.closePopView();
  }
}

/// 弹窗配置项
class PopViewOptions {
  final Color? maskColor;
  const PopViewOptions({this.maskColor});
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
