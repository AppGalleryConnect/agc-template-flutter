import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import '../constants/constants.dart';
import '../viewmodels/interaction_view_model.dart';
import 'interaction_feed_card.dart';
import 'no_watcher.dart';

/// 互动标签页内容组件
class InterActionTabContent extends StatefulWidget {
  /// 标签页资源信息
  final TabItem resource;

  /// ViewModel 就绪时的回调函数
  final Function(InteractionViewModel)? onViewModelReady;

  const InterActionTabContent({
    super.key,
    required this.resource,
    this.onViewModelReady,
  });

  @override
  State<InterActionTabContent> createState() => _InterActionTabContentState();
}

class _InterActionTabContentState
    extends BaseStatefulWidgetState<InterActionTabContent>
    with AutomaticKeepAliveClientMixin {
  /// 互动视图模型实例
  late final InteractionViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = InteractionViewModel();
    vm.init(TabEnum.values[widget.resource.id]);
    vm.addListener(_onViewModelChanged);

    // 通知父组件 ViewModel 已就绪
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onViewModelReady?.call(vm);
    });

    // 监听帖子发布成功事件，自动刷新列表
    EventHubUtils.getInstance().on(EventEnum.postPublished, (args) {
      if (mounted) {
        vm.refresh();
      }
    });
  }

  @override
  void dispose() {
    vm.removeListener(_onViewModelChanged);
    vm.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return EasyRefresh(
      controller: vm.controller,
      header: const MaterialHeader(),
      onRefresh: vm.refresh,
      footer: const MaterialFooter(),
      onLoad: vm.onLoad,
      child: widget.resource.id == TabEnum.watch.value &&
              !vm.userInfoModel.isLogin
          ? const NoLoginWidget()
          : (vm.interactionList.isEmpty
              ? const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: Constants.SPACE_500,
                    child: NoWatcher(),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(
                    left: Constants.SPACE_12,
                    right: Constants.SPACE_12,
                    top: Constants.SPACE_16,
                  ),
                  itemCount: vm.interactionList.length,
                  itemBuilder: (context, index) {
                    final item = vm.interactionList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: Constants.SPACE_12),
                      padding: const EdgeInsets.all(Constants.SPACE_12),
                      decoration: BoxDecoration(
                        color: ThemeColors.getCardBackground(
                            settingInfo.darkSwitch),
                        borderRadius: BorderRadius.circular(Constants.SPACE_16),
                      ),
                      child: InteractionFeedCard(
                        cardInfo: item,
                      ),
                    );
                  },
                )),
    );
  }
}
