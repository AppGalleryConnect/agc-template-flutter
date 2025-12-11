import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import '../common/constants.dart';

class TabBar extends StatelessWidget {
  final int selectedId;
  final double fontSizeRatio;
  final ValueChanged<int> onClickBar;

  const TabBar({
    super.key,
    this.selectedId = 0,
    this.fontSizeRatio = 1,
    required this.onClickBar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tabList.map((v) {
        return GestureDetector(
          onTap: () => onClickBar(v.id),
          child: Padding(
            padding: const EdgeInsets.only(
              top: CommonConstants.SPACE_L,
              bottom: CommonConstants.SPACE_S,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  v.label,
                  style: TextStyle(
                    fontSize: 16 * fontSizeRatio,
                    color: selectedId == v.id
                        ? Theme.of(context).primaryTextTheme.bodyMedium?.color
                        : Theme.of(context).hintColor,
                    fontWeight: selectedId == v.id
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: CommonConstants.SPACE_S),
                Container(
                  width: 16,
                  height: 2,
                  color: Theme.of(context).primaryColor,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                  ),
                ).visible(selectedId == v.id),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

extension WidgetVisibility on Widget {
  Widget visible(bool visible) {
    return visible ? this : const SizedBox.shrink();
  }
}
