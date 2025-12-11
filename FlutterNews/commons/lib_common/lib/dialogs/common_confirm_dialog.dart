import 'package:flutter/material.dart';
import '../utils/theme_colors.dart';
import '../models/setting_model.dart';

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
  static void show(BuildContext context, IConfirmDialogParams param) {
    final settingModel = SettingModel.getInstance();
    final isDark = settingModel.darkSwitch;
    String priBtnV = param.priBtnV ?? '取消';
    String secBtnV = param.secBtnV ?? '确定';
    Color priBtnFg = param.priBtnFg ?? ThemeColors.appTheme;
    Color secBtnFg = param.secBtnFg ?? ThemeColors.appTheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ThemeColors.getBackgroundColor(isDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (param.primaryTitle != null) ...[
                  Text(
                    param.primaryTitle!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: ThemeColors.getFontPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (param.secondaryTitle != null) ...[
                  Text(
                    param.secondaryTitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeColors.getFontSecondary(isDark),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  param.content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: ThemeColors.getFontPrimary(isDark),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          priBtnV,
                          style: TextStyle(
                            color: priBtnFg,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          secBtnV,
                          style: TextStyle(
                            color: secBtnFg,
                            fontSize: 16,
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
