import 'package:flutter/material.dart';
import 'package:lib_common/dialogs/common_confirm_dialog.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart';
import '../constants/constants.dart';

class SetReadIcon extends StatelessWidget {
  final bool enable;
  final VoidCallback confirm;

  const SetReadIcon({
    super.key,
    this.enable = true,
    required this.confirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.setReadIconSize,
      height: Constants.setReadIconSize,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          if (enable) {
            CommonConfirmDialog.show(
                context,
                IConfirmDialogParams(
                  primaryTitle: '温馨提示',
                  content: '您确定将全部未读消息标记为已读？',
                  secBtnV: '确定',
                  confirm: () {
                    confirm();
                  },
                ));
          } else {
            CommonToastDialog.show(
              ToastDialogParams(
                message: '暂无未读消息',
                duration: Constants.toastDuration,
              ),
            );
          }
        },
        child: Image.asset(
          Constants.icPublicClean,
          width: Constants.setReadIconSize,
          height: Constants.setReadIconSize,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: Constants.setReadIconPlaceholderSize,
              height: Constants.setReadIconPlaceholderSize,
              color: Constants.setReadIconPlaceholderColor,
              alignment: Alignment.center,
              child: const Icon(Icons.mark_email_read,
                  size: Constants.setReadIconPlaceholderIconSize,
                  color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}
