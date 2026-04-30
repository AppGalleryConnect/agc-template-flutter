import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:provider/provider.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';
import '../components/message_item.dart';
import '../components/set_read_icon.dart';
import '../viewmodels/message_vm.dart';

class MessagePage extends StatefulWidget {
  final Map<String, dynamic>? params;

  const MessagePage({super.key, this.params});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final WindowModel windowModel = WindowModel();

  @override
  Widget build(BuildContext context) {
    final settingInfo = SettingModel.getInstance();
    return ChangeNotifierProvider(
      create: (context) => MessageViewModel(),
      child: Consumer<MessageViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                NavHeaderBar(
                  title: '消息',
                  windowModel: windowModel,
                  titleColor:
                      ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                  bgColor:
                      ThemeColors.getBackgroundColor(settingInfo.darkSwitch),
                  backButtonBackgroundColor:
                      ThemeColors.getCompBackgroundSecondary(
                          settingInfo.darkSwitch),
                  backButtonPressedBackgroundColor:
                      ThemeColors.getCompBackgroundSecondary(
                          settingInfo.darkSwitch),
                  customTitleSize: 20 * FontScaleUtils.fontSizeRatio,
                  rightPartBuilder: (context) => Container(
                    alignment: Alignment.centerRight,
                    width: 60,
                    child: SetReadIcon(
                      enable: viewModel.allowClean,
                      confirm: viewModel.setAllRead,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color:
                        ThemeColors.getBackgroundColor(settingInfo.darkSwitch),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: viewModel.menuInfoList.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: Color(0xFFF0F0F0),
                      ),
                      itemBuilder: (context, index) {
                        final menuItem = viewModel.menuInfoList[index];
                        return GestureDetector(
                          onTap: () {
                            RouterUtils.of.pushPathByName(
                              menuItem.routerName,
                              onPop: (dynamic _) =>
                                  menuItem.routerOnPop?.call(),
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: MsgMenuItem(
                            info: menuItem,
                            fontSizeRatio: FontScaleUtils.fontSizeRatio,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 页面构建器函数
Widget messagePageBuilder(BuildContext context, Map<String, dynamic>? params) {
  return const MessagePage();
}
