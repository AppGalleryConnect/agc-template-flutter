import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:module_newsfeed/constants/constants.dart';

class DeleteCommentDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onCancel;
  final String? title;

  const DeleteCommentDialog({
    super.key,
    required this.onDelete,
    required this.onCancel,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final settingInfo = SettingModel.getInstance();
    return AlertDialog(
      backgroundColor: ThemeColors.getBackgroundColor(settingInfo.darkSwitch),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.SPACE_20),
      ),
      content: Text(
        title ?? "确定要删除此评论？",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: Constants.FONT_18,
          fontWeight: FontWeight.normal,
          color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
        ),
      ),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: (){
                  onCancel();
                },
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                    fontSize: Constants.FONT_16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  onDelete();
                },
                child: const Text(
                  '确定',
                  style: TextStyle(
                    color: Constants.TEXT_COLOR,
                    fontSize: Constants.FONT_16,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  static void show(BuildContext context, {required VoidCallback onDelete,required VoidCallback onCancel, String? title}) {
    showDialog(
      context: context,
      builder: (context) => DeleteCommentDialog(onDelete: onDelete,onCancel: onCancel,title: title,),
    );
  }
}
