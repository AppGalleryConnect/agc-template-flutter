import 'package:flutter/material.dart';
import '../constants/constants.dart';

class IConfirmDialogParams {
  final String? primaryTitle;
  final String? secondaryTitle;
  final String content;
  final String? priBtnV;
  final String? secBtnV;
  final Color? priBtnFg;
  final Color? secBtnFg;
  final Function? confirm;
  final Function? cancel;

  IConfirmDialogParams({
    this.primaryTitle,
    this.secondaryTitle,
    required this.content,
    this.priBtnV,
    this.secBtnV,
    this.priBtnFg,
    this.secBtnFg,
    this.confirm,
    this.cancel,
  });
}

class CommonConfirmDialog {
  static void show(BuildContext context, IConfirmDialogParams param, bool isDark) {
    String priBtnV = param.priBtnV ?? '取消';
    String secBtnV = param.secBtnV ?? '确定';
    Color priBtnFg = param.priBtnFg ?? Constants.appTheme;
    Color secBtnFg = param.secBtnFg ?? Constants.appTheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Constants.getBackgroundColor(isDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.SPACE_36),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Constants.SPACE_24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (param.primaryTitle != null) ...[
                  Text(
                    param.primaryTitle!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Constants.FONT_20,
                      color: Constants.getFontPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: Constants.SPACE_8),
                ],
                if (param.secondaryTitle != null) ...[
                  Text(
                    param.secondaryTitle!,
                    style: TextStyle(
                      fontSize: Constants.FONT_14,
                      color: Constants.getFontSecondary(isDark),
                    ),
                  ),
                  const SizedBox(height: Constants.SPACE_16),
                ],
                Text(
                  param.content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Constants.FONT_16,
                    color: Constants.getFontPrimary(isDark),
                    height: Constants.SPACE_1_5,
                  ),
                ),
                const SizedBox(height: Constants.SPACE_24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (param.cancel != null) {
                            param.cancel!();
                          }
                        },
                        style: TextButton.styleFrom(
                          // 对齐鸿蒙：透明背景
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: Constants.SPACE_12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Constants.SPACE_8),
                          ),
                        ),
                        child: Text(
                          priBtnV,
                          style: TextStyle(
                            color: priBtnFg,
                            fontSize: Constants.FONT_16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Constants.SPACE_8),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (param.confirm != null) {
                            param.confirm!();
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: Constants.SPACE_12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Constants.SPACE_8),
                          ),
                        ),
                        child: Text(
                          secBtnV,
                          style: TextStyle(
                            color: secBtnFg,
                            fontSize: Constants.FONT_16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
