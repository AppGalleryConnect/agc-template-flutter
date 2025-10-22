import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final TextStyle textStyle;
  final Color lineColor;

  const SectionTitle({
    super.key,
    required this.title,
    this.textStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    this.lineColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.kSectionTitleHeight, //分区标题高度
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 20,
            color: lineColor,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
