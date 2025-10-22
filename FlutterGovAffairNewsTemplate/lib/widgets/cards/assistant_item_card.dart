import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../utils/time_formatter.dart';

class AssistantItemCard extends StatelessWidget {
  final TaskModel item;
  final VoidCallback? onMorePressed;

  const AssistantItemCard({
    super.key,
    required this.item,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 内容区域
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行 - 使用装饰实现左侧红线
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.red,
                        width: 4.0,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      // 优化的三点按钮（不使用IconButton）
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: onMorePressed,
                          child: Container(
                            height: 24,
                            width: 24,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.more_horiz,
                              color: Colors.grey,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 发布时间
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4, bottom: 8),
                  child: Text(
                    formatTime(item.publishTime),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // 任务内容
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Text(
                    item.content,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),

          // 右下角圆形印章
          if (item.isCompleted)
            Positioned(
              right: 40,
              top: 30,
              child: _buildCircularStamp('已办理', Colors.blue),
            ),
          if (!item.isCompleted)
            Positioned(
              right: 40,
              top: 30,
              child: _buildCircularStamp('未办理', Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildCircularStamp(String text, Color color) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        width: 60, // 圆形印章直径
        height: 60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Center(
          child: Transform.rotate(
            angle: -0.2, // 文字倾斜角度
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
