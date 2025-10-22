import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class TopicIntroWidget extends StatelessWidget {
  const TopicIntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.kTopicIntroHeight, // 专区介绍高度
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 专题标题
          const Text(
            '专题标题',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // 专题描述
          const Text(
            '这是一个非常重要的专题，包含了多个分类的新闻内容。'
            '用户可以通过滑动查看不同分类的新闻，专题介绍板块会在滚动时消失，'
            '分区头会吸附在导航栏下方。',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 16),

          // 专题图片
          Flexible(
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/intro.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
