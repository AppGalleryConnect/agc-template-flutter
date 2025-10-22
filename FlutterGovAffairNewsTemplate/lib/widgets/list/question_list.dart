import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../cards/question_card.dart';
import '../../constants.dart';

class QuestionList extends StatelessWidget {
  final List<PostModel> items;
  final String? highlightKeyword;
  final bool isScrollable;

  const QuestionList({
    super.key,
    required this.items,
    this.highlightKeyword,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // 根据isScrollable参数决定滚动行为
      physics: isScrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      shrinkWrap: !isScrollable, // 在不可滚动模式下需要shrinkWrap
      itemCount: items.length,
      itemBuilder: (context, index) {
        return QuestionCard(
          item: items[index],
          highlightKeyword: highlightKeyword,
        );
      },
      // 和背景色一致，如果不需要可去除,并改为ListView.builder
      separatorBuilder: (BuildContext context, int index) {
        return Container(color: AppConstants.backgroundColor, height: 8.0);
      },
    );
  }
}
