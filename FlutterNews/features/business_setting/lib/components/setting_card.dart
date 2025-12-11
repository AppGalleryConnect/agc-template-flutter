import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import '../utils/setting_text_styles.dart';
import '../constants/constants.dart';

class SettingCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const SettingCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  State<SettingCard> createState() => _SettingCardState();
}

class _SettingCardState extends BaseStatefulWidgetState<SettingCard> {
  static const double _switchItemPadding = Constants.SPACE_16;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        _switchItemPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: SettingTextStyles.listItemTitle(
                    settingInfo.darkSwitch,
                  ),
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: Constants.SPACE_4),
                  Text(
                    widget.subtitle!,
                    style: SettingTextStyles.description(
                      settingInfo.darkSwitch,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: widget.value,
              onChanged: widget.onChanged,
              activeColor: Colors.white,
              activeTrackColor: Constants.activeTrackColor,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor:
                  ThemeColors.getBackgroundTertiary(settingInfo.darkSwitch),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              trackOutlineColor: WidgetStateProperty.all(
                Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
