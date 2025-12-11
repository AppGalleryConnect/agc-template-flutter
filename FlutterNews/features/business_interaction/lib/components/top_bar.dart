import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import '../constants/constants.dart';

/// 顶部标签栏组件
class TopBar extends StatefulWidget {
  /// 当前选中的标签页ID
  final int selectedId;

  /// 标签栏点击事件回调函数
  final Function(int selectedId) onClickBar;

  /// 字体大小比例（默认为1.0）
  final double fontSizeRatio;

  const TopBar({
    super.key,
    this.selectedId = 0,
    required this.onClickBar,
    this.fontSizeRatio = 1.0,
  });

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends BaseStatefulWidgetState<TopBar> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: TAB_LIST.map((v) {
          return GestureDetector(
            onTap: () {
              widget.onClickBar(v.id);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                right: Constants.SPACE_16,
                top: Constants.SPACE_12,
                bottom: Constants.SPACE_8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 显示标签页标题文本
                  Text(
                    v.label,
                    style: TextStyle(
                      fontSize: Constants.FONT_16 * widget.fontSizeRatio,
                      color: widget.selectedId == v.id
                          ? ThemeColors.appTheme
                          : ThemeColors.getFontSecondary(
                              settingInfo.darkSwitch),
                      fontWeight: widget.selectedId == v.id
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: Constants.SPACE_4),
                  // 创建底部指示器（横线）
                  Visibility(
                    visible: widget.selectedId == v.id,
                    child: Container(
                      width: Constants.SPACE_16,
                      height: Constants.SPACE_2,
                      decoration: BoxDecoration(
                        color: ThemeColors.appTheme,
                        borderRadius: BorderRadius.circular(Constants.SPACE_1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
