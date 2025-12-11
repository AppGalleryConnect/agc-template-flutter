import 'package:business_mine/components/message_bottom.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/dialogs/common_toast_dialog.dart';
import 'package:provider/provider.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:lib_common/models/window_model.dart';
import 'package:lib_news_api/services/message_service.dart';
import '../common/observed_model.dart';
import '../viewmodels/message_system_vm.dart';
import '../utils/font_scale_utils.dart';
import '../constants/constants.dart';

class MsgSystemPage extends StatefulWidget {
  const MsgSystemPage({super.key});

  @override
  State<MsgSystemPage> createState() => _MsgSystemPageState();
}

class _MsgSystemPageState extends State<MsgSystemPage> {
  late MsgSystemViewModel vm;
  final WindowModel windowModel = WindowModel();

  @override
  void initState() {
    super.initState();
    vm = MsgSystemViewModel();
    messageServiceApi.setSystemRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider(
        create: (context) => vm,
        child: Consumer<MsgSystemViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                NavHeaderBar(
                  title: '系统消息',
                  showBackBtn: true,
                  windowModel: windowModel,
                  onBack: () {
                    RouterUtils.of.pop();
                  },
                  backButtonBackgroundColor: const Color(0xFFF0F0F0),
                  backButtonPressedBackgroundColor: const Color(0xFFE0E0E0),
                  customTitleSize: 20 * FontScaleUtils.fontSizeRatio,
                  rightPartBuilder: (context) => Container(
                    alignment: Alignment.centerRight,
                    width: 60,
                    child: GestureDetector(
                      onTap: () {
                        viewModel.onClickShow(!viewModel.isShowSelect);
                      },
                      child: viewModel.isShowSelect
                          ? Text(
                              '取消',
                              style: TextStyle(
                                  fontSize: 16 * FontScaleUtils.fontSizeRatio),
                            )
                          : Image.asset(
                              Constants.icMessageBatchDelete,
                              width: 40,
                              height: 40,
                              // color: Colors.red,
                            ),
                    ),
                  ),
                ),

                // 消息列表
                Expanded(
                  child: _buildMessageList(viewModel),
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
                                fontSize: 16 * FontScaleUtils.fontSizeRatio),
                          ),
                          content: Text(
                            '确定要删除这些系统消息吗？',
                            style: TextStyle(
                                fontSize: 14 * FontScaleUtils.fontSizeRatio),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(
                                '取消',
                                style: TextStyle(
                                    fontSize:
                                        14 * FontScaleUtils.fontSizeRatio),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop(false);
                                await viewModel.deleteAllSyetem();
                                viewModel.onClickShow(false);
                                CommonToastDialog.show(
                                  ToastDialogParams(message: '系统消息已删除'),
                                );
                              },
                              child: Text(
                                '删除',
                                style: TextStyle(
                                    fontSize:
                                        14 * FontScaleUtils.fontSizeRatio),
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageList(MsgSystemViewModel viewModel) {
    if (vm.list.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: CommonConstants.PADDING_PAGE,
        vertical: CommonConstants.SPACE_S,
      ),
      itemCount: vm.list.length,
      itemBuilder: (context, index) {
        final item = vm.list[index];
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (viewModel.isShowSelect) return;
            setState(() {
              item.isDelete = details.delta.dx < 0;
            });
          },
          child: Container(
            child: Row(
              children: [
                if (vm.isShowSelect) _leftBuilder(item),
                Expanded(
                  child: _buildSystemMessageItem(item),
                ),
                if (item.isDelete) _rightBuilder(item),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSystemMessageItem(SystemMessageInfo item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CommonConstants.PADDING_M),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(CommonConstants.PADDING_M),
        margin: const EdgeInsets.symmetric(
          horizontal: CommonConstants.PADDING_M,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 消息头部（头像和标题）
            Row(
              children: [
                Image.asset(
                  Constants.icSystemAvatar,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: CommonConstants.SPACE_S),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '系统消息',
                      style: TextStyle(
                        fontSize: 16 * FontScaleUtils.fontSizeRatio,
                        color: const Color(CommonConstants.COLOR_FONT_PRIMARY),
                      ),
                    ),
                    const SizedBox(height: CommonConstants.SPACE_XXS),
                    Text(
                      TimeUtils.handleMsgTimeDiff(item.createTime),
                      style: TextStyle(
                        fontSize: 12 * FontScaleUtils.fontSizeRatio,
                        color:
                            const Color(CommonConstants.COLOR_FONT_SECONDARY),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // 分割线
            const Divider(height: 16, thickness: 0.5, color: Color(0xFFEEEEEE)),

            // 消息内容
            Text(
              item.content,
              style: TextStyle(
                fontSize:
                    CommonConstants.TITLE_S * FontScaleUtils.fontSizeRatio,
                color: const Color(CommonConstants.COLOR_FONT_PRIMARY),
              ),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _leftBuilder(SystemMessageInfo item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          item.isSelect = !item.isSelect;
        });
      },
      child: SizedBox(
        width: 54,
        height: 100,
        child: Center(
          child: Image.asset(
            item.isSelect
                ? Constants.icMessageUnselect
                : Constants.icMessageSelect,
            width: 18,
            height: 18,
          ),
        ),
      ),
    );
  }

  Widget _rightBuilder(SystemMessageInfo item) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text('确认删除',
                style: TextStyle(fontSize: 16 * FontScaleUtils.fontSizeRatio)),
            content: Text('确定要删除这条系统消息吗？',
                style: TextStyle(fontSize: 14 * FontScaleUtils.fontSizeRatio)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('取消',
                    style:
                        TextStyle(fontSize: 14 * FontScaleUtils.fontSizeRatio)),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(false);
                  await vm.deleteSystemIm(item.id);
                  vm.onClickShow(false);
                  CommonToastDialog.show(
                    ToastDialogParams(message: '系统消息已删除'),
                  );
                },
                child: Text('删除',
                    style:
                        TextStyle(fontSize: 14 * FontScaleUtils.fontSizeRatio)),
              ),
            ],
          ),
        );
      },
      child: Container(
        color: Colors.grey[300],
        width: 72,
        height: 180,
        child: Center(
          child: Image.asset(
            Constants.icMessageDelete,
            width: 40,
            height: 40,
            // color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Constants.icMessageSystem,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: CommonConstants.PADDING_M),
            child: Text(
              '暂无系统消息',
              style: TextStyle(
                fontSize: CommonConstants.TITLE_S,
                color: Color(CommonConstants.COLOR_FONT_SECONDARY),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 页面构建器函数
dynamic msgSystemPageBuilder() {
  return const MsgSystemPage();
}
