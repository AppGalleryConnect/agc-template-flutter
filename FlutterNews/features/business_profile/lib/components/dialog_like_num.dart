import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';
import '../common/constants.dart';

class DialogLikeNum extends StatelessWidget {
  final AuthorModel params;

  const DialogLikeNum({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        margin:
            const EdgeInsets.symmetric(horizontal: CommonConstants.PADDING_L),
        padding: const EdgeInsets.all(CommonConstants.PADDING_L),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constants.dialogBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              params.authorNickName,
              style: const TextStyle(
                fontSize: Constants.authorNameFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: CommonConstants.SPACE_M),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '共获得',
                  style: TextStyle(
                    fontSize: Constants.textFontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  params.likeNum.toString(),
                  style: const TextStyle(
                    fontSize: Constants.textFontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                  ),
                ),
                const Text(
                  '个赞',
                  style: TextStyle(
                    fontSize: Constants.textFontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            const SizedBox(height: CommonConstants.SPACE_XL),
            // 图标部分
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Constants.LIKE_ICON_PATH,
                    width: Constants.likeImageWidth,
                    height: Constants.likeImageHeight,
                  ),
                ],
              ),
            ),
            const SizedBox(height: CommonConstants.SPACE_XXL),
            // 按钮
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: CommonConstants.PADDING_L),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.LIKE_BUTTON_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.buttonBorderRadius),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: CommonConstants.SPACE_M),
                ),
                child: const Text(
                  '好的',
                  style: TextStyle(
                    fontSize: Constants.textFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
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
