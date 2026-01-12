import 'package:flutter/material.dart';
import '../constants/grid_row_col_setting.dart';
import '../constants/common_constants.dart';
import '../utils/pop_view_utils.dart';

/// 弹窗参数接口
abstract class ITipDialogParams {
  String? primaryTitle;
  String? secondaryTitle;
  String? content;
  String? priBtnV;
  VoidCallback? confirm;
}

/// 弹窗参数实现类
class TipDialogParams implements ITipDialogParams {
  @override
  String? primaryTitle;
  @override
  String? secondaryTitle;
  @override
  String? content;
  @override
  String? priBtnV;
  @override
  VoidCallback? confirm;

  TipDialogParams(ITipDialogParams item)
      : content = item.content,
        primaryTitle = item.primaryTitle,
        secondaryTitle = item.secondaryTitle,
        priBtnV = item.priBtnV ?? '取消',
        confirm = item.confirm ?? (() {} as VoidCallback);
}

/// 通用提示弹窗组件
class CommonTipView extends StatelessWidget {
  final TipDialogParams params;

  const CommonTipView({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    const borderRadius = BorderRadius.all(Radius.circular(16.0));
    return Container(
      width: CommonConstants.fullPercent,
      padding: const EdgeInsets.symmetric(
        horizontal: CommonConstants.paddingPage,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: CommonConstants.fullPercent,
            constraints: const BoxConstraints(
              maxWidth: GridRowColSetting.dialogMaxWidth,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: borderRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (params.primaryTitle != null ||
                    params.secondaryTitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 8),
                    child: Column(
                      children: [
                        if (params.primaryTitle != null)
                          Text(
                            params.primaryTitle!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (params.secondaryTitle != null)
                          Text(
                            params.secondaryTitle!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                // 内容区域
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    params.content!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                // 按钮区域
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: themeColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    onPressed: () {
                      PopViewUtils.closePopView();
                      params.confirm?.call();
                    },
                    child: Text(params.priBtnV ?? '取消'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 通用通知弹窗工具类
class CommonTipDialog {
  /// 打开弹窗
  static void show(ITipDialogParams param) {
    final params = TipDialogParams(param);
    PopViewUtils.showPopView(
      contentView: CommonTipView(params: params),
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
    );
  }
}
