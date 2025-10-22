import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../constants.dart';

class QuestionCard extends StatelessWidget {
  final PostModel item;
  final String? highlightKeyword;

  const QuestionCard({
    super.key,
    required this.item,
    this.highlightKeyword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // margin: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        key: ValueKey(item.id),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 政务号信息行
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage(item.account.avatar),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppConstants.accountTextStyle,
                      children: item.highlightText(item.account.name,
                          highlightKeyword, AppConstants.accountTextStyle),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 标题行 - 关键词高亮支持
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                    text: item.category,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(width: 2, height: 18, color: Colors.red),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppConstants.headlineTextStyle,
                      children: item.highlightText(item.title, highlightKeyword,
                          AppConstants.headlineTextStyle),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 内容 - 关键词高亮支持
            RichText(
              text: TextSpan(
                style: AppConstants.defaultTextStyle,
                children: item.highlightText(item.content, highlightKeyword,
                    AppConstants.defaultTextStyle),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (item.image != null) const SizedBox(height: 12),
            // 图片显示
            if (item.image != null)
              SizedBox(
                height: 200,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 16 / 9, // 根据实际图片比例调整
                      child: Image.asset(
                        item.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // 评论 - 高亮支持
            if (item.replyText != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppConstants.commentTextStyle,
                        children: [
                          TextSpan(
                            text: item.account.name,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: ' 回复 ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          ...item.highlightText(
                            ': ${item.replyText}',
                            highlightKeyword,
                            AppConstants.commentTextStyle,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.isReplied
                                ? Colors.green[50]
                                : Colors.red[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.isReplied ? '已回复' : '已跟进',
                            style: TextStyle(
                              color: item.isReplied
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.replyTime?.year}-${item.replyTime?.month.toString().padLeft(2, '0')}-${item.replyTime?.day.toString().padLeft(2, '0')}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
