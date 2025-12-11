import 'package:flutter/material.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';
import 'package:lib_common/constants/common_constants.dart';
import '../components/watch_button.dart';
import '../viewmodels/follower_page_vm.dart';
import '../viewmodels/watch_page_vm.dart';

class AuthorItem extends StatelessWidget {
  final AuthorModel author;
  final Function()? onWatchStatusChanged;
  final double fontSizeRatio;
  final dynamic viewModel;

  const AuthorItem({
    super.key,
    required this.author,
    this.onWatchStatusChanged,
    this.fontSizeRatio = 1.0,
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    String pageType = 'normal';
    if (viewModel != null) {
      if (viewModel is FollowerPageViewModel) {
        pageType = 'follower';
      } else if (viewModel is WatchPageViewModel) {
        pageType = 'watch';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CommonConstants.PADDING_PAGE,
        vertical: CommonConstants.SPACE_M,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundImage: author.authorIcon.isNotEmpty
                ? NetworkImage(author.authorIcon)
                : null,
            radius: 24 * fontSizeRatio,
          ),
          const SizedBox(width: CommonConstants.SPACE_M),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author.authorNickName,
                  style: TextStyle(
                    fontSize: 16 * fontSizeRatio,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  author.authorDesc,
                  style: TextStyle(
                    fontSize: 12 * fontSizeRatio,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            children: [
              WatchButton(
                author: author,
                onWatchStatusChanged: onWatchStatusChanged,
                pageType: pageType,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
