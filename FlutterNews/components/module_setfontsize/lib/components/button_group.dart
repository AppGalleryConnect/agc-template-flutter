import 'package:flutter/material.dart';
import 'package:module_setfontsize/constants/constants.dart';

/// 按钮组组件
class ButtonGroup extends StatelessWidget {
  final List<ButtonItem> buttonList;
  final String selectedId;
  final Function(String) onSelected;
  final bool isDark; 

  const ButtonGroup({
    super.key,
    required this.buttonList,
    required this.selectedId,
    required this.onSelected,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.SPACE_40,
      decoration: BoxDecoration(
        color: isDark
            ? Constants.DARK_BACKGROUND_COLOR  
            : Constants.BACKGROUND_COLOR, 
        borderRadius: BorderRadius.circular(Constants.SPACE_20),
      ),
      child: Row(
        children: buttonList.map((item) {
          final isSelected = selectedId == item.id;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(item.id),
              child: Container(
                height: Constants.SPACE_35,
                margin: const EdgeInsets.all(Constants.SPACE_2_5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                      ? Constants.COMP_BACKGROUND_COLOR  
                      : Colors.white) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(Constants.SPACE_20),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: Constants.FONT_14,
                    color: isSelected
                        ? (isDark
                        ? Constants.WHITE_COLOR  
                        : Colors.black) 
                        : (isDark
                        ? Constants.TEXT_DARK_COLOR  
                        : Constants.TEXT_COLOR),
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
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
