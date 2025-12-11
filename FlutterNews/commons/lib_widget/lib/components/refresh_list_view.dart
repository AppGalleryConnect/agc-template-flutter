import 'package:flutter/material.dart';
import 'empty_builder.dart';

/// 下拉刷新和加载更多的列表视图
class RefreshListView<T> extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Future<void> Function()? onLoadMore;
  final List<T> data;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final bool isLoading;
  final bool hasMore;
  final String emptyMessage;
  final Widget? header;
  final EdgeInsetsGeometry? padding;
  const RefreshListView({
    super.key,
    required this.onRefresh,
    this.onLoadMore,
    required this.data,
    required this.itemBuilder,
    this.isLoading = false,
    this.hasMore = true,
    this.emptyMessage = '暂无数据',
    this.header,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: data.isEmpty && !isLoading
          ? ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: EmptyState(text: emptyMessage),
                  ),
                ),
              ],
            )
          : ListView.builder(
              padding: padding,
              itemCount:
                  data.length + (hasMore ? 1 : 0) + (header != null ? 1 : 0),
              itemBuilder: (context, index) {
                // 显示头部
                if (header != null && index == 0) {
                  return header!;
                }
                final dataIndex = header != null ? index - 1 : index;
                if (dataIndex < data.length) {
                  return itemBuilder(context, dataIndex, data[dataIndex]);
                }
                if (hasMore && onLoadMore != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!isLoading) {
                      onLoadMore!();
                    }
                  });
                  return Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    '没有更多了',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
