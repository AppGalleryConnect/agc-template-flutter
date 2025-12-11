import 'package:flutter/material.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import '../components/base_mark_like_page.dart';
import '../viewmodels/like_vm.dart';
import 'package:lib_common/models/window_model.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  final LikeViewModel _vm = LikeViewModel();
  late WindowModel _windowModel;

  @override
  void initState() {
    super.initState();
    _windowModel = WindowModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          NavHeaderBar(
            title: '我的点赞',
            windowModel: _windowModel,
            backButtonBackgroundColor: const Color(0xFFF0F0F0),
            backButtonPressedBackgroundColor: const Color(0xFFE0E0E0),
            customTitleSize: 20 * FontScaleUtils.fontSizeRatio,
          ),
          Expanded(
            child: BaseMarkLikePage(
              vm: _vm,
            ),
          ),
        ],
      ),
    );
  }
}

Widget likePageBuilder(BuildContext context) {
  return const LikePage();
}
