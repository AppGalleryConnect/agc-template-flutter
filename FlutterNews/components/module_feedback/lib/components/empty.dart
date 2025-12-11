import 'package:flutter/material.dart';
import 'package:module_feedback/common/constants.dart';

class Empty extends StatelessWidget {
  final String text;
  final double fontSizeRatio;

  const Empty({super.key, this.text = '暂无记录', this.fontSizeRatio = 1.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          Constants.emptyImage,
          width: Constants.SPACE_200,
          height: Constants.SPACE_200,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: Constants.SPACE_12),
        Text(
          text,
          style: TextStyle(
            fontSize: Constants.FONT_14 * fontSizeRatio,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

