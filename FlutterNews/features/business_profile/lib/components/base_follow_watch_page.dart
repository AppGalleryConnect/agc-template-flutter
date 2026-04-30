import 'package:business_profile/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';
import 'package:lib_widget/components/empty_builder.dart';
import 'author_item.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class BaseFollowWatchPage extends StatelessWidget {
  final dynamic vm;
  const BaseFollowWatchPage({super.key, required this.vm});
  @override
  Widget build(BuildContext context) {
    bool hasData = false;
    List<dynamic>? dataList = [];
    final settingInfo = SettingModel.getInstance();
    if (vm != null) {
      if (vm.dataSource != null && vm.dataSource.originDataArray != null) {
        dataList = vm.dataSource.originDataArray;
        hasData = dataList?.isNotEmpty ?? false;
      } else if (vm.authorList != null) {
        dataList = vm.authorList;
        hasData = dataList?.isNotEmpty ?? false;
      }
    }

    return Container(
      color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
      child: Column(
        children: [
          if (hasData) _buildListContent(context),
          if (!hasData) _buildEmptyContent(context),
        ],
      ),
    );
  }

  Widget _buildListContent(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final breakpointCtrl = Get.find<BreakpointController>();
        final currentLanes = breakpointCtrl.lanes.value;

        return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              vm?.loadMore != null &&
              !(vm?.isLoading ?? true)) {
            vm.loadMore();
          }
          return false;
        },

          child: MasonryGridView.count(
            crossAxisCount: currentLanes,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            itemCount: ((vm?.dataSource?.originDataArray?.length ??
                    vm?.authorList?.length ??
                    0) +
                1),
          padding: EdgeInsets.only(
            left: CommonConstants.PADDING_FSPAGE,
            right: CommonConstants.PADDING_FSPAGE,
            top: CommonConstants.SPACE_XXS,
            bottom: vm?.windowModel?.windowBottomPadding ?? 0,
          ),
            cacheExtent: 1,
            physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            int dataCount = (vm?.dataSource?.originDataArray?.length ??
                vm?.authorList?.length ??
                0);
            if (index == dataCount) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    '--到底啦--',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: (14 * (vm?.settingInfo?.fontSizeRatio ?? 1.0))
                          .toDouble(),
                    ),
                  ),
                ),
              );
            }
            AuthorModel? authorModel;
            if (vm != null &&
                vm.dataSource != null &&
                vm.dataSource.originDataArray != null) {
              authorModel = vm.dataSource.originDataArray[index];
            } else if (vm != null && vm.authorList != null) {
              authorModel = vm.authorList[index];
            }
            if (authorModel != null) {
                return Container(
                  margin: const EdgeInsets.only(bottom: Constants.SPACE_12),
                  padding: const EdgeInsets.all(Constants.SPACE_12),
                  decoration: BoxDecoration(
                    color: ThemeColors.getCardBackground(
                        vm?.settingInfo?.darkSwitch ?? false),
                    borderRadius: BorderRadius.circular(Constants.SPACE_16),
                  ),
                  child: AuthorItem(
                    author: authorModel,
                    fontSizeRatio: vm?.settingInfo?.fontSizeRatio ?? 1.0,
                    viewModel: vm,
                    onWatchStatusChanged: () async {
                      if (authorModel != null) {
                        bool currentWatchStatus = authorModel.isWatchByMe;
                        if (vm != null && vm.handleWatchAction != null) {
                          vm.handleWatchAction(
                            authorModel.authorId,
                            currentWatchStatus,
                          );
                        } else if (vm != null &&
                            vm.handleWatchStatusChanged != null) {
                          vm.handleWatchStatusChanged();
                        }
                      }
                    },
                  ),
              );
            }
            return const SizedBox.shrink();
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyContent(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Center(
          child: EmptyBuilder(
            params: EmptyBuilderParams(
              text: vm?.emptyTip ?? '暂无数据',
              fontSizeRatio: vm?.settingInfo?.fontSizeRatio ?? 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
