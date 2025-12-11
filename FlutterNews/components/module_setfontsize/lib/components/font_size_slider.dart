import 'package:flutter/material.dart';
import 'package:module_setfontsize/constants/constants.dart';
import '../viewmodels/setting_font_vm.dart';

/// 自定义轨道形状
class InsetSliderTrackShape extends RoundedRectSliderTrackShape {
  const InsetSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2.0,
  }) {
    final Rect calculateTrackRect = getPreferredRect(
      isDiscrete: isDiscrete,
      parentBox: parentBox,
      offset: offset,
      isEnabled: isEnabled,
      sliderTheme: sliderTheme,
    );

    final activeTrackColor = sliderTheme.activeTrackColor!;
    final inactiveTrackColor = sliderTheme.inactiveTrackColor!;
    final trackHeight = sliderTheme.trackHeight!;
    final thumbBgRadius = trackHeight / 2;

    final Paint inactivePaint = Paint()..color = inactiveTrackColor;
    final Rect inactiveTrackRect = Rect.fromLTRB(
      thumbCenter.dx,
      calculateTrackRect.center.dy - trackHeight / 2,
      calculateTrackRect.right,
      calculateTrackRect.center.dy + trackHeight / 2,
    );
    final RRect inactiveRRect = RRect.fromRectAndRadius(
      inactiveTrackRect,
      Radius.circular(trackHeight / 2),
    );
    context.canvas.drawRRect(inactiveRRect, inactivePaint);

    final Paint activePaint = Paint()
      ..color = activeTrackColor
      ..style = PaintingStyle.fill;

    final Path bluePath = Path();

    bluePath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          calculateTrackRect.left,
          calculateTrackRect.center.dy - trackHeight / 2,
          thumbCenter.dx + thumbBgRadius,
          calculateTrackRect.center.dy + trackHeight / 2,
        ),
        Radius.circular(trackHeight / 2),
      ),
    );

    bluePath.addOval(
      Rect.fromCircle(
        center: thumbCenter,
        radius: thumbBgRadius,
      ),
    );

    context.canvas.drawPath(bluePath, activePaint);
  }
}

/// 字体大小滑块组件
class FontSizeSlider extends StatelessWidget {
  final double currentRatio;
  final Function(FontSizeEnum) onRatioChanged;

  const FontSizeSlider({
    super.key,
    required this.currentRatio,
    required this.onRatioChanged,
  });

  @override
  Widget build(BuildContext context) {
    int currentIndex = 1;
    for (int i = 0; i < SettingFontViewModel.fontSizeList.length; i++) {
      if (SettingFontViewModel.fontSizeList[i].value.value == currentRatio) {
        currentIndex = i;
        break;
      }
    }

    return Column(
      children: [
        SizedBox(
          height: Constants.SPACE_40,
          child: Row(
            children: [
              Text(
                'A',
                style: TextStyle(
                  fontSize: Constants.FONT_14 * FontSizeEnum.small.value,
                  color: Constants.SLIDER_TEXT_COLOR,
                ),
              ),
              const SizedBox(width: Constants.SPACE_20),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: Constants.SPACE_20,
                    activeTrackColor: currentIndex == 0
                        ? Constants.ACTIVE_TRACK_SELECT_COLOR
                        : Constants.ACTIVE_TRACK_COLOR,
                    inactiveTrackColor: Constants.INACTIVE_TRACK_COLOR,
                    thumbColor: Colors.white,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6.0,
                      elevation: 2.0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 0,
                    ),
                    trackShape: const InsetSliderTrackShape(),
                    valueIndicatorShape:
                        const PaddleSliderValueIndicatorShape(),
                    showValueIndicator: ShowValueIndicator.never,
                    activeTickMarkColor: Colors.transparent,
                    inactiveTickMarkColor: Colors.transparent,
                  ),
                  child: Slider(
                    value: currentIndex.toDouble(),
                    min: 0,
                    max: 3,
                    divisions: 3,
                    onChanged: (value) {
                      final index = value.toInt();
                      onRatioChanged(
                          SettingFontViewModel.fontSizeList[index].value);
                    },
                  ),
                ),
              ),
              const SizedBox(width: Constants.SPACE_20),
              Text(
                'A',
                style: TextStyle(
                  fontSize: Constants.FONT_14 * FontSizeEnum.xl.value,
                  color: Constants.SLIDER_TEXT_COLOR,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Constants.SPACE_2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_42),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: SettingFontViewModel.fontSizeList.map((item) {
              return Text(
                item.label,
                style: const TextStyle(
                  fontSize: Constants.FONT_10,
                  color: Constants.SLIDER_TEXT_COLOR,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
