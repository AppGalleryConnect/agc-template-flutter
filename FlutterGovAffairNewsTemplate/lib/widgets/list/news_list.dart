import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../bar/account_follow_bar.dart';

class NewsList extends StatelessWidget {
  final List<PostModel> posts;
  final Function(String, bool)? onFollowChanged;

  const NewsList({
    super.key,
    required this.posts,
    this.onFollowChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            for (int i = 0; i < posts.length; i++) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _buildNewsItem(posts[i]),
              ),
              if (i < posts.length - 1)
                const Divider(height: 1, color: Colors.grey, thickness: 0.5),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem(PostModel post) {
    return Column(
      children: [
        // 政务号信息和关注按钮
        AccountFollowBar(
          avatarUrl: post.account.avatar,
          name: post.account.name,
          initialFollowed: false,
          onFollowChanged: (isFollowed) {
            if (onFollowChanged != null) {
              onFollowChanged!(post.account.id, isFollowed);
            }
          },
        ),
        const SizedBox(height: 8),
        // 新闻内容和图片
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 文本部分：标题+发布时间
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${post.publishTime.year}-${post.publishTime.month}-${post.publishTime.day}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // 图片部分
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // 可替换为网络请求的图片
              child: Image.asset(
                'assets/images/information.jpg',
                fit: BoxFit.cover,
                width: 120,
                height: 70,
                errorBuilder: (_, __, ___) => Container(
                  width: 120,
                  height: 70,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
