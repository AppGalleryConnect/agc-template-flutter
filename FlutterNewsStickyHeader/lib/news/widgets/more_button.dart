import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class MoreButton extends StatelessWidget {
  final String sectionTitle;
  final VoidCallback onPressed;

  const MoreButton({
    super.key,
    required this.sectionTitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: AppConstants.kMoreButtonHeight, //“查看更多”横条的高度
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '查看更多',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_circle_down,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
