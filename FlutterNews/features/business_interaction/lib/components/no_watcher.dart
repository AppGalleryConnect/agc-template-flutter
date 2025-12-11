import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:module_setfontsize/module_setfontsize.dart';
import 'package:lib_account/utils/login_sheet_utils.dart';
import '../constants/constants.dart';

/// 无关注者组件
class NoWatcher extends StatefulWidget {
  const NoWatcher({super.key});

  @override
  State<NoWatcher> createState() => _NoWatcherState();
}

class _NoWatcherState extends BaseStatefulWidgetState<NoWatcher> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Constants.noWatchImage,
            width: Constants.SPACE_92,
            height: Constants.SPACE_77,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.people_outline,
                size: Constants.SPACE_77,
                color: Colors.grey,
              );
            },
          ),
          const SizedBox(height: Constants.SPACE_12),
          Text(
            '没有数据',
            style: TextStyle(
              fontSize: Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
              color: ThemeColors.getFontSecondary(settingInfo.darkSwitch),
            ),
          ),
        ],
      ),
    );
  }
}

class NoLoginWidget extends StatefulWidget {
  const NoLoginWidget({super.key});

  @override
  State<NoLoginWidget> createState() => _NoLoginWidget();
}

class _NoLoginWidget extends BaseStatefulWidgetState<NoLoginWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: Constants.SPACE_100,
              height: Constants.SPACE_100,
              child: Image.asset(Constants.noLoginImage)),
          const SizedBox(
            height: Constants.SPACE_20,
          ),
          const Text("暂未登录，登录后查看更多精彩内容",
              style:
                  TextStyle(fontSize: Constants.FONT_13, color: Colors.grey)),
          const SizedBox(
            height: Constants.SPACE_10,
          ),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              onPressed: () {
                LoginSheetUtils.showLoginSheet(context);
              },
              child: const Text(
                "登录",
                style:
                    TextStyle(fontSize: Constants.FONT_13, color: Colors.white),
              ))
        ],
      ),
    );
  }
}
