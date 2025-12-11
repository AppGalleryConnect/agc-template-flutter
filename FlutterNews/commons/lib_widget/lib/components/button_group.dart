import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';

class ButtonItem {
  final String id;
  final String label;

  const ButtonItem({required this.id, required this.label});
}

class ButtonGroup extends StatefulWidget {
  final List<ButtonItem> buttonList;
  final String selectedId;
  final Function(String) onSelectedIdChanged;
  const ButtonGroup({
    super.key,
    this.buttonList = const [],
    this.selectedId = '',
    required this.onSelectedIdChanged,
  });

  @override
  State<ButtonGroup> createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex =
        widget.buttonList.indexWhere((item) => item.id == widget.selectedId);
    if (currentIndex == -1) {
      currentIndex = 0;
    }
  }

  @override
  void didUpdateWidget(covariant ButtonGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId) {
      final newIndex =
          widget.buttonList.indexWhere((item) => item.id == widget.selectedId);
      if (newIndex != -1) {
        setState(() {
          currentIndex = newIndex;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomSegment(
            currentIndex: currentIndex,
            buttonList: widget.buttonList,
            onChange: (index) {
              if (index >= 0 && index < widget.buttonList.length) {
                widget.onSelectedIdChanged(widget.buttonList[index].id);
              }
            },
          ),
        ),
      ],
    );
  }
}

class CustomSegment extends StatelessWidget {
  final int currentIndex;
  final List<ButtonItem> buttonList;
  final Function(int) onChange;
  const CustomSegment({
    super.key,
    required this.currentIndex,
    required this.buttonList,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(CommonConstants.COLOR_PAGE_BACKGROUND),
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: const EdgeInsets.symmetric(
          horizontal: CommonConstants.PADDING_L,
          vertical: CommonConstants.PADDING_S),
      child: Row(
        children: buttonList.map((item) {
          int index = buttonList.indexOf(item);
          bool isSelected = index == currentIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChange(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: CommonConstants.PADDING_S),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                  border: isSelected
                      ? Border.all(
                          width: 2,
                          color: const Color(
                              CommonConstants.COLOR_PAGE_BACKGROUND))
                      : null,
                ),
                child: Center(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: CommonConstants.TITLE_S,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                      color: isSelected
                          ? const Color(CommonConstants.COLOR_FONT_PRIMARY)
                          : const Color(CommonConstants.COLOR_FONT_SECONDARY),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
