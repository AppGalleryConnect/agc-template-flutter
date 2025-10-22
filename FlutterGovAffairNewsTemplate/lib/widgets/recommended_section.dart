import 'package:flutter/material.dart';
import 'cards/account_horizontal_card.dart';
import 'list/news_list.dart';
import '../data/mock_data.dart';

class RecommendedSection extends StatelessWidget {
  final VoidCallback onMorePressed;

  const RecommendedSection({
    super.key,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red[100]!,
            Colors.grey[200]!,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 推荐关注标题栏
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  '推荐关注',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    onMorePressed();
                  },
                  child: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
          // 政务号横向滚动卡片
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              itemCount: MockData.accountItems2.length,
              itemBuilder: (context, index) {
                return AccountHorizontalCard(
                    account: MockData.accountItems2[index]);
              },
            ),
          ),
          // 新闻列表
          NewsList(
            posts: MockData.postItems,
            onFollowChanged: (accountId, isFollowed) {
              // 可以在这里处理关注状态变化
              // 例如更新数据库或发送网络请求
            },
          ),
        ],
      ),
    );
  }
}
