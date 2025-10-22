// 任务模型：用于构建帮办事务
class TaskModel {
  final String id;
  final String title;
  final String content;
  final DateTime publishTime;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.content,
    required this.publishTime,
    this.isCompleted = false,
  });
}
