import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import '../constants/constants.dart';

class EmptyBuilderParams {
  final String? text;
  final String? img;
  final double? fontSizeRatio;
  final double? space;
  const EmptyBuilderParams({
    this.text,
    this.img,
    this.fontSizeRatio,
    this.space,
  });
}

class EmptyBuilder extends StatelessWidget {
  final EmptyBuilderParams? params;
  const EmptyBuilder({super.key, this.params});
  @override
  Widget build(BuildContext context) {
    final String text = params?.text ?? '暂无内容';
    final String imgPath = params?.img ?? Constants.emptyContentImg;
    final double fontSizeRatio = params?.fontSizeRatio ?? 1.0;
    final double space = params?.space ?? CommonConstants.SPACE_S;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          imgPath,
          width: Constants.EMPTY_IMG_W.toDouble(),
          fit: BoxFit.contain,
        ),
        SizedBox(height: space),
        Text(
          text,
          style: TextStyle(
            fontSize: 14 * fontSizeRatio,
            color: const Color(CommonConstants.COLOR_FONT_SECONDARY),
          ),
        ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  final String? text;
  final String? img;
  final double? fontSizeRatio;
  final double? space;
  const EmptyState({
    super.key,
    this.text,
    this.img,
    this.fontSizeRatio,
    this.space,
  });

  @override
  Widget build(BuildContext context) {
    final params = EmptyBuilderParams(
      text: text,
      img: img,
      fontSizeRatio: fontSizeRatio,
      space: space,
    );
    return EmptyBuilder(params: params);
  }
}
