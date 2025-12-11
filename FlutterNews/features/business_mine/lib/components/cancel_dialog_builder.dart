import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/utils/pop_view_utils.dart';

class CancelDialogParams {
  String btnText;
  VoidCallback onCancel;

  CancelDialogParams({
    required this.btnText,
    VoidCallback? onCancel,
  }) : onCancel = onCancel ?? PopViewUtils.closePopView;
}

Widget cancelDialogBuilder(BuildContext context, CancelDialogParams params) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(
      left: CommonConstants.PADDING_PAGE,
      right: CommonConstants.PADDING_PAGE,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: CommonConstants.DIALOG_MAX_WIDTH),
          child: Container(
            padding: const EdgeInsets.only(
              top: CommonConstants.PADDING_L,
              bottom: CommonConstants.PADDING_L,
              left: CommonConstants.PADDING_XXL,
              right: CommonConstants.PADDING_XXL,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    params.onCancel();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    fixedSize: const Size(
                        double.infinity, CommonConstants.MEDIUM_IMG_WIDTH),
                  ),
                  child: Text(
                    params.btnText,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    PopViewUtils.closePopView();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    fixedSize: const Size(
                        double.infinity, CommonConstants.MEDIUM_IMG_WIDTH),
                  ),
                  child: const Text(
                    '取消',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
