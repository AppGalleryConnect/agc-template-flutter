import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../constants/app_constants.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsItem news;

  const NewsItemWidget({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    // 可设置多种新闻类型的组件，进行扩展
    return Container(
      // 新闻项高度，当前只有一种article类型
      height: AppConstants.kNewsItemHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左边的图片部分
          _buildImageSection(),

          const SizedBox(width: 16), // 图片与文本之间的间距

          // 右边的文本部分
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // 让子组件在垂直方向上均匀分布
              children: [
                // 新闻标题
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // 发布者和发布时间
                Row(
                  children: [
                    Text(
                      news.author,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (news.publishTime != null) ...[
                      const SizedBox(width: 4),
                      // 添加竖线分隔符
                      Container(
                        width: 1,
                        height: 16,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(news.publishTime!),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 图片部分的构建方法
  Widget _buildImageSection() {
    if (news.imageUrl == null || news.imageUrl!.isEmpty) {
      return const SizedBox.shrink(); // 如果没有图片，返回空容器
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
            'assets/images/news.jpeg',
            width: 165,
            height: 110,
            fit: BoxFit.cover,
          )
    );
  }

  // 格式化发布时间
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
    }
  }
}
