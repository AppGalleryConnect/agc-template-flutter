import 'package:business_mine/components/message_bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lib_common/constants/common_constants.dart';
import '../constants/constants.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:lib_widget/components/empty_builder.dart';
import 'package:lib_news_api/services/message_service.dart'
    show messageServiceApi;
import '../components/im_item.dart';
import '../components/set_read_icon.dart';
import '../common/observed_model.dart';
import '../viewmodels/message_im_list_vm.dart';
import 'package:lib_common/models/window_model.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart';
import '../utils/font_scale_utils.dart';

class MsgIMListPage extends StatefulWidget {
  final Map<String, dynamic>? params;

  const MsgIMListPage({super.key, this.params});

  @override
  State<MsgIMListPage> createState() => _MsgIMListPageState();
}

class _MsgIMListPageState extends State<MsgIMListPage> {
  final WindowModel windowModel = WindowModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = MsgIMViewModel();
        viewModel.queryList();
        return viewModel;
      },
      child: Consumer<MsgIMViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                NavHeaderBar(
                  title: '私信',
                  windowModel: windowModel,
                  backButtonBackgroundColor: Constants.messageItemIconBgColor,
                  backButtonPressedBackgroundColor: Constants.dividerColor,
                  customTitleSize:
                      Constants.textHeaderSize * FontScaleUtils.fontSizeRatio,
                  rightPartBuilder: (context) => Container(
                    alignment: Alignment.centerRight,
                    width: Constants.messageBottomContainerWidth * 0.58,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            viewModel.onClickShow(!viewModel.isShowSelect);
                          },
                          child: viewModel.isShowSelect
                              ? Text(
                                  '取消',
                                  style: TextStyle(
                                      fontSize: Constants.textPrimarySize *
                                          FontScaleUtils.fontSizeRatio),
                                )
                              : Image.asset(
                                  Constants.icPublicDelete,
                                  width: Constants.setReadIconSize,
                                  height: Constants.setReadIconSize,
                                ),
                        ),
                        const SizedBox(
                          width: Constants.messageItemTextSpacing * 2.5,
                        ),
                        SetReadIcon(
                          enable: viewModel.allowClean,
                          confirm: viewModel.setAllRead,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: () {
                    if (viewModel.chatList.isEmpty) {
                      return EmptyState(
                        text: '暂无私信',
                        fontSizeRatio: FontScaleUtils.fontSizeRatio,
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: viewModel.chatList.length,
                      itemBuilder: (context, index) {
                        final info = viewModel.chatList[index];
                        return GestureDetector(
                          onTap: () => _goToIMChat(context, viewModel, info),
                          onHorizontalDragUpdate: (details) {
                            if (viewModel.isShowSelect) return;
                            setState(() {
                              info.isDelete = details.delta.dx < 0;
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: Constants.imItemLeftHeight +
                                Constants.messageItemHorizontalSpacing,
                            padding:
                                const EdgeInsets.all(CommonConstants.SPACE_M),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: IMItem(
                              info: info,
                              fontSizeRatio: FontScaleUtils.fontSizeRatio,
                              isShowSelect: viewModel.isShowSelect,
                              onSelect: (isSelect) {
                                setState(() {
                                  info.isSelect = !isSelect;
                                });
                              },
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      '确认删除',
                                      style: TextStyle(
                                          fontSize: Constants.textPrimarySize *
                                              FontScaleUtils.fontSizeRatio),
                                    ),
                                    content: Text(
                                      '确定要删除这条私信吗？',
                                      style: TextStyle(
                                          fontSize:
                                              Constants.textSecondarySize *
                                                  FontScaleUtils.fontSizeRatio),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(
                                          '取消',
                                          style: TextStyle(
                                              fontSize: Constants
                                                      .textSecondarySize *
                                                  FontScaleUtils.fontSizeRatio),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop(false);
                                          await viewModel.deleteIM(
                                              info.chatAuthor.authorId);
                                          viewModel.onClickShow(false);
                                          CommonToastDialog.show(
                                            ToastDialogParams(message: '私信已删除'),
                                          );
                                        },
                                        child: Text(
                                          '删除',
                                          style: TextStyle(
                                              fontSize: Constants
                                                      .textSecondarySize *
                                                  FontScaleUtils.fontSizeRatio),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }(),
                ),
                if (viewModel.isShowSelect)
                  MessageBottom(
                    isSelectAll: viewModel.isSelectAll,
                    deleteCount: viewModel.deleteCount,
                    onSelectAll: (isSelectAll) =>
                        viewModel.onSelectAll(isSelectAll),
                    onDelete: () => {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text(
                            '确认删除',
                            style: TextStyle(
                                fontSize: Constants.textPrimarySize *
                                    FontScaleUtils.fontSizeRatio),
                          ),
                          content: Text(
                            '确定要删除这些私信吗？',
                            style: TextStyle(
                                fontSize: Constants.textSecondarySize *
                                    FontScaleUtils.fontSizeRatio),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(
                                '取消',
                                style: TextStyle(
                                    fontSize: Constants.textSecondarySize *
                                        FontScaleUtils.fontSizeRatio),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop(false);
                                await viewModel.deleteAll();
                                viewModel.onClickShow(false);
                                CommonToastDialog.show(
                                  ToastDialogParams(message: '私信已全部删除'),
                                );
                              },
                              child: Text(
                                '删除',
                                style: TextStyle(
                                    fontSize: Constants.textSecondarySize *
                                        FontScaleUtils.fontSizeRatio),
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  void _goToIMChat(
      BuildContext context, MsgIMViewModel viewModel, BriefIMModel info) {
    if (viewModel.isShowSelect) return;
    messageServiceApi.setSingleChatRead(info.chatAuthor.authorId);
    RouterUtils.of.pushPathByName(
      RouterMap.MINE_MSG_IM_CHAT_PAGE,
      param: {
        'authorId': info.chatAuthor.authorId,
        'authorName': info.chatAuthor.authorNickName,
        'authorIcon': info.chatAuthor.authorIcon,
      },
      onPop: (_) {
        viewModel.queryList();
      },
    );
  }
}

// 页面构建器函数
Widget msgIMListPageBuilder(
    BuildContext context, Map<String, dynamic>? params) {
  return const MsgIMListPage();
}
