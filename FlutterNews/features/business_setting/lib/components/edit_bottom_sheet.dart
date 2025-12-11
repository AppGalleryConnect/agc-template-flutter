import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_common/lib_common.dart';
import 'package:module_setfontsize/module_setfontsize.dart';
import '../constants/constants.dart';

class EditBottomSheet {
  /// 显示编辑底部弹窗
  static void show({
    required BuildContext context,
    required String title,
    required String hintText,
    required RxString value,
    required Function() onConfirm,
    required VoidCallback onClose,
    int maxLength = 20,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditBottomSheetContent(
        title: title,
        hintText: hintText,
        value: value,
        onConfirm: onConfirm,
        onClose: onClose,
        maxLength: maxLength,
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    ).whenComplete(() {
      onClose();
    });
  }
}

class _EditBottomSheetContent extends StatefulWidget {
  final String title;
  final String hintText;
  final RxString value;
  final Function() onConfirm;
  final VoidCallback onClose;
  final int maxLength;
  final int maxLines;
  final TextInputType keyboardType;

  const _EditBottomSheetContent({
    required this.title,
    required this.hintText,
    required this.value,
    required this.onConfirm,
    required this.onClose,
    required this.maxLength,
    required this.maxLines,
    required this.keyboardType,
  });

  @override
  State<_EditBottomSheetContent> createState() =>
      _EditBottomSheetContentState();
}

class _EditBottomSheetContentState
    extends BaseStatefulWidgetState<_EditBottomSheetContent> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.value.value);
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.value.value.length),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: ThemeColors.getCardBackground(settingInfo.darkSwitch),
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Constants.SPACE_16)),
        ),
        child: Column(
          children: [
            // 顶部拖动指示器
            Container(
              margin: const EdgeInsets.only(top: Constants.SPACE_8),
              width: Constants.SPACE_36,
              height: Constants.SPACE_4,
              decoration: BoxDecoration(
                color: ThemeColors.getDivider(settingInfo.darkSwitch),
                borderRadius: BorderRadius.circular(Constants.SPACE_2),
              ),
            ),
            // 标题栏
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.SPACE_16, vertical: Constants.SPACE_12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize:
                          Constants.FONT_18 * FontScaleUtils.fontSizeRatio,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: Constants.SPACE_24,
                      color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                    ),
                    onPressed: () {
                      widget.onClose();
                      RouterUtils.of.pop();
                    },
                  ),
                ],
              ),
            ),
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.SPACE_16,
                ),
                child: Column(
                  children: [
                    Obx(
                      () {
                        if (_textController.text != widget.value.value) {
                          _textController.text = widget.value.value;
                          _textController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset: widget.value.value.length,
                            ),
                          );
                        }
                        return TextField(
                          controller: _textController,
                          onChanged: (newValue) =>
                              widget.value.value = newValue,
                          maxLength: widget.maxLength,
                          maxLines: widget.maxLines,
                          keyboardType: widget.keyboardType,
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                              color: ThemeColors.getFontSecondary(
                                  settingInfo.darkSwitch),
                            ),
                            filled: true,
                            fillColor: ThemeColors.getBackgroundTertiary(
                                settingInfo.darkSwitch),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Constants.SPACE_8,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            counterText:
                                '${widget.value.value.length}/${widget.maxLength}',
                            counterStyle: TextStyle(
                              color: ThemeColors.getFontSecondary(
                                  settingInfo.darkSwitch),
                            ),
                            suffixIcon: widget.value.value.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      size: Constants.SPACE_20,
                                      color: ThemeColors.getFontSecondary(
                                          settingInfo.darkSwitch),
                                    ),
                                    onPressed: () {
                                      widget.value.value = '';
                                      _textController.clear();
                                    },
                                  )
                                : null,
                          ),
                          style: TextStyle(
                            fontSize: Constants.FONT_16 *
                                FontScaleUtils.fontSizeRatio,
                            color: ThemeColors.getFontPrimary(
                                settingInfo.darkSwitch),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: Constants.SPACE_16,
                right: Constants.SPACE_16,
                top: Constants.SPACE_16,
                bottom: Constants.SPACE_16 + keyboardHeight,
              ),
              decoration: BoxDecoration(
                color: ThemeColors.getCardBackground(
                  settingInfo.darkSwitch,
                ),
                border: Border(
                  top: BorderSide(
                    color: ThemeColors.getDivider(
                      settingInfo.darkSwitch,
                    ),
                    width: Constants.SPACE_0_5,
                  ),
                ),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: Constants.SPACE_48,
                  child: ElevatedButton(
                    onPressed: () {
                      final result = widget.onConfirm();
                      if (result is bool && result == true) {
                        RouterUtils.of.pop();
                      } else if (result == null) {
                        RouterUtils.of.pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.appTheme,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Constants.SPACE_24,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      '确定',
                      style: TextStyle(
                        fontSize:
                            Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
