import 'package:flutter/material.dart';
import '../constants/constants.dart';

class MessageBottom extends StatelessWidget {
  final bool isSelectAll;
  final int deleteCount;
  final double fontSizeRatio;

  final Function(bool isSelectAll) onSelectAll;
  final Function() onDelete;

  const MessageBottom({
    super.key,
    this.fontSizeRatio = 1.0,
    this.isSelectAll = false,
    this.deleteCount = 0,
    required this.onSelectAll,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Constants.messageBottomSpacing +
          Constants.messageBottomContainerHeight +
          Constants.messageBottomSpacing +
          MediaQuery.of(context).padding.bottom,
      child: Column(
        children: [
          const SizedBox(
            height: Constants.messageBottomSpacing,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: Constants.messageBottomSpacing,
            ),
            height: Constants.messageBottomContainerHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => onSelectAll(isSelectAll),
                  child: Container(
                    width: Constants.messageBottomContainerWidth,
                    decoration: BoxDecoration(
                      color: Constants.messageBottomSelectAllBgColor,
                      borderRadius: BorderRadius.circular(
                        Constants.messageBottomContainerRadius,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isSelectAll ? '取消全选' : '全选',
                        style: TextStyle(
                          fontSize:
                              Constants.messageBottomTextSize * fontSizeRatio,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (deleteCount < 1) return;
                    onDelete();
                  },
                  child: Container(
                    width: Constants.messageBottomContainerWidth,
                    decoration: BoxDecoration(
                      color: deleteCount == 0
                          ? Constants.messageBottomDeleteDisabledColor
                          : Constants.messageBottomDeleteEnabledColor,
                      borderRadius: BorderRadius.circular(
                        Constants.messageBottomContainerRadius,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        deleteCount == 0 ? '删除' : '删除($deleteCount)',
                        style: TextStyle(
                          fontSize:
                              Constants.messageBottomTextSize * fontSizeRatio,
                          color: Constants.buttonTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Constants.messageBottomSpacing +
                MediaQuery.of(context).padding.bottom,
          ),
        ],
      ),
    );
  }
}
