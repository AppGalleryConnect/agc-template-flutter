import 'package:flutter/material.dart';

class DialogUtils {
  static void showCustomDialog(
      BuildContext context,
      Widget child, {
        bool barrierDismissible = true, 
      }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        child: child,
      ),
    );
  }
}