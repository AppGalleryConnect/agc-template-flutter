import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_news_api/observedmodels/news_model.dart';
import 'package:lib_widget/components/empty_builder.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';
import '../viewmodels/like_vm.dart';
import '../viewmodels/mark_vm.dart';
import 'uniform_news_card.dart';
import 'package:provider/provider.dart';
import 'package:lib_common/utils/pop_view_utils.dart';
import '../utils/content_navigation_utils.dart';
import '../constants/constants.dart';

class BaseMarkLikePage extends StatefulWidget {
  final ChangeNotifier vm;
  final Widget Function(BuildContext context) emptyStateBuilder;

  const BaseMarkLikePage({
    super.key,
    required this.vm,
    this.emptyStateBuilder = defaultEmptyStateBuilder,
  });

  static Widget defaultEmptyStateBuilder(BuildContext context) {
    return EmptyState(
      fontSizeRatio: FontScaleUtils.fontSizeRatio,
    );
  }

  @override
  _BaseMarkLikePageState createState() => _BaseMarkLikePageState();
}

class _BaseMarkLikePageState extends State<BaseMarkLikePage> {
  @override
  void initState() {
    super.initState();
    widget.vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    PopViewUtils.instance.init(context);
  }

  @override
  void dispose() {
    widget.vm.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.vm,
      child: Consumer<ChangeNotifier>(
        builder: (context, vm, child) {
          final list = _getList();

          return list.isNotEmpty
              ? ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return contentItemBuilder(item);
                  },
                  padding: const EdgeInsets.only(
                    left: CommonConstants.PADDING_PAGE,
                    right: CommonConstants.PADDING_PAGE,
                    top: CommonConstants.SPACE_M,
                  ),
                  physics: const BouncingScrollPhysics(),
                )
              : Container(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: widget.emptyStateBuilder(context),
                );
        },
      ),
    );
  }

  List<NewsModel> _getList() {
    if (widget.vm is LikeViewModel) {
      return (widget.vm as LikeViewModel).list;
    } else if (widget.vm is MarkViewModel) {
      return (widget.vm as MarkViewModel).list;
    }
    return [];
  }

  Widget contentItemBuilder(NewsModel v) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: CommonConstants.PADDING_M,
      ),
      child: GestureDetector(
        onTap: () {
          ContentNavigationUtils.navigateToContentDetail(v);
        },
        child: UniformNewsCard(
          newsInfo: v,
          customStyle: const UniformNewsStyle(
            bodyFg: 16 * 1.0,
          ),
          operateBuilder: () => operateBuilder(v),
        ),
      ),
    );
  }

  Widget operateBuilder(NewsModel v) {
    return GestureDetector(
      onTap: () {
        if (widget.vm is LikeViewModel) {
          (widget.vm as LikeViewModel).popDialog(context, v);
        } else if (widget.vm is MarkViewModel) {
          (widget.vm as MarkViewModel).popDialog(context, v);
        }
      },
      child: Image.asset(
        Constants.icPublicEllipsisCircle,
        width: CommonConstants.MEDIUM_IMG_WIDTH,
        height: CommonConstants.MEDIUM_IMG_WIDTH,
        color: Colors.grey,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}
