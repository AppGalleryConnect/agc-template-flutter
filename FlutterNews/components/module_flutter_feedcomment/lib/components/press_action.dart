import 'package:flutter/material.dart';
import 'package:module_flutter_feedcomment/constants/constants.dart';

class BuilderParamsImpl {
  final void Function() reply;
  final void Function() delete;
  final void Function() cancel;
  final bool isCommentOwner;
  final double fontSizeRatio;

  BuilderParamsImpl({
    required this.reply,
    required this.delete,
    required this.cancel,
    required this.isCommentOwner,
    required this.fontSizeRatio,
  });
}

Widget confirmDialogView(BuildContext context, BuilderParamsImpl params) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Constants.SPACE_24),
      color: Colors.white,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            params.reply();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Constants.SPACE_12),
            alignment: Alignment.center,
            child: Text(
              '回复',
              style: TextStyle(
                fontSize: Constants.FONT_16 * params.fontSizeRatio,
                color: Colors.black,
              ),
            ),
          ),
        ),
        if (params.isCommentOwner)
          GestureDetector(
            onTap: () {
              params.delete();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Constants.SPACE_12),
              alignment: Alignment.center,
              child: Text(
                '删除',
                style: TextStyle(
                  fontSize: Constants.FONT_16 * params.fontSizeRatio,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            params.cancel();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Constants.SPACE_12),
            alignment: Alignment.center,
            child: Text(
              '取消',
              style: TextStyle(
                fontSize: Constants.FONT_16 * params.fontSizeRatio,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
