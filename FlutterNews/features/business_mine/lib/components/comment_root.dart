import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/utils/time_utils.dart';
import '../common/observed_model.dart';
import 'uniform_news_card.dart';
import '../utils/content_navigation_utils.dart';

class CommentRoot extends StatelessWidget {
  final AggregateNewsCommentModel data;
  final double fontSizeRatio;
  final VoidCallback onReply;

  const CommentRoot({
    super.key,
    required this.data,
    this.fontSizeRatio = 1.0,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 作者信息行
        GestureDetector(
          onTap: () {
            RouterUtils.of.pushPathByName(RouterMap.PROFILE_HOME,
                param: data.author?.authorId ?? '');
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: data.author?.authorIcon != null
                    ? NetworkImage(data.author!.authorIcon)
                    : null,
                child: data.author?.authorIcon == null
                    ? Text(
                        data.author?.authorNickName != null
                            ? data.author!.authorNickName.substring(0, 1)
                            : '',
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
              ),
              const SizedBox(width: CommonConstants.SPACE_S),
              Text(
                data.author?.authorNickName ?? '',
                style: TextStyle(
                  fontSize: 12 * fontSizeRatio,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),

        // 评论内容
        Padding(
          padding: const EdgeInsets.only(left: CommonConstants.PADDING_XXL),
          child: Text(
            data.commentBody,
            style: TextStyle(
              fontSize: 14 * fontSizeRatio,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),

        // 评论时间
        Padding(
          padding: const EdgeInsets.only(left: CommonConstants.PADDING_XXL),
          child: Text(
            TimeUtils.getDateDiff(data.createTime),
            style: TextStyle(
              fontSize: 10 * fontSizeRatio,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ),

        // 引用新闻
        Padding(
          padding: const EdgeInsets.only(left: CommonConstants.PADDING_XXL),
          child: GestureDetector(
            onTap: () {
              ContentNavigationUtils.navigateFromCommentToDetail(
                  data.newsDetailInfo);
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(CommonConstants.RADIUS_M),
              ),
              padding: const EdgeInsets.all(CommonConstants.PADDING_S),
              child: UniformNewsCard(
                newsInfo: data.newsDetailInfo,
                customStyle: UniformNewsStyle(
                  bodyFg: 12 * fontSizeRatio,
                  bodyFgColor: Theme.of(context).textTheme.bodyMedium?.color,
                  imgRatio: 2.0,
                ),
                showAuthorInfoBottom: false,
                operateBuilder: () => const SizedBox.shrink(),
              ),
            ),
          ),
        ),

        // 回复按钮
        Padding(
          padding: const EdgeInsets.only(left: CommonConstants.PADDING_XXL),
          child: GestureDetector(
            onTap: onReply,
            child: Text(
              '回复',
              style: TextStyle(
                fontSize: 10 * fontSizeRatio,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
