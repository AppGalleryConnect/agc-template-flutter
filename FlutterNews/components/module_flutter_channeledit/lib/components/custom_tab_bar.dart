import 'package:flutter/material.dart';
import 'package:module_flutter_channeledit/model/model.dart';
import 'package:module_flutter_channeledit/constants/constants.dart';

class CustomTabBar extends StatefulWidget {
  final int currentIndex;
  final List<TabInfo> myChannels;
  final Function(int, TabInfo) onIndexChange;
  final double fontSizeRatio;
  final ScrollController listScroller;
  final bool isShowEdit;
  final bool isDark;
  final int index;
  const CustomTabBar({
    super.key,
    this.currentIndex = 1,
    this.myChannels = const [],
    this.fontSizeRatio = 1.0,
    required this.listScroller,
    required this.onIndexChange,
    required this.isShowEdit,
    this.isDark = false,
    this.index = 0,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.SPACE_60,
      color: widget.isDark ? Colors.black : Colors.transparent,
      child: ListView.builder(
        controller: widget.listScroller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
        itemCount: widget.myChannels.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: Constants.SPACE_16),
            child: _tabBuilder(index, widget.myChannels[index]),
          );
        },
      ),
    );
  }

  Widget _tabBuilder(int index, TabInfo item) {
    final isSelected = widget.currentIndex == index;
    return GestureDetector(
      onTap: () {
        widget.onIndexChange(index, item);
      },
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              item.text,
              style: TextStyle(
                color: isSelected
                    ? (widget.currentIndex < widget.index
                        ? Colors.white
                        : Constants.TAB_BAR_TEXT_COLOR)
                    : (widget.currentIndex < widget.index
                        ? Colors.grey
                        : (widget.isDark ? Colors.white : Colors.black)),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: Constants.FONT_16 * widget.fontSizeRatio,
              ),
            ),
            if (!widget.isShowEdit)
              const SizedBox(
                height: Constants.SPACE_4,
              ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 1 : 0,
              child: Container(
                width: Constants.SPACE_16,
                height: Constants.SPACE_2,
                color: widget.currentIndex < widget.index
                    ? Colors.white
                    : Constants.SORT_EDIT_TEXT_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
