import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:lib_common/models/window_model.dart';
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
                  backButtonBackgroundColor: const Color(0xFFF0F0F0),
                  backButtonPressedBackgroundColor: const Color(0xFFE0E0E0),
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
                      }),
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
