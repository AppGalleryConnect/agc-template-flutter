import 'package:flutter/material.dart';
import '../common/constants.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';

class SettingList extends StatelessWidget {
  final List<ISettingItem> list;
  final Function(RouterMap)? onItemTap;

  const SettingList({
    super.key,
    this.list = const [],
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.SPACE_10,
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: Constants.SPACE_12),
        itemBuilder: (context, index) {
          final item = list[index];
          return InkWell(
            onTap: item.routerName != null
                ? () => onItemTap?.call(item.routerName!)
                : null,
            borderRadius: BorderRadius.circular(Constants.SPACE_16),
            child: Container(
              padding: const EdgeInsets.all(Constants.SPACE_4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.SPACE_16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Constants.SPACE_8,
                          horizontal: Constants.SPACE_8),
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: Constants.SPACE_16,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: Constants.SPACE_8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

