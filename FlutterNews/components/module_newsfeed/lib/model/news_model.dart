// 1. 图文组模型：绑定“单张图片”和“对应内容”
class NewsImageTextGroup {
  final String content; // 该图片对应的内容
  final String imageUrl; // 该内容对应的图片（允许为空，兼容纯文字组）
  final bool isImageFirst; // 控制该组是“图在前”还是“文在前”

  NewsImageTextGroup({
    required this.content,
    this.imageUrl = '', 
    this.isImageFirst = true, // 默认“图在前，文在后”
  });
}

// 2. 新闻主模型：包含标题、作者等基础信息 + 多组图文
class NewsModel {
  final String title;
  final String author;
  final String publishTime;
  final List<NewsImageTextGroup> imageTextGroups;
  final int commentCount;
  final int likeCount;

  NewsModel({
    required this.title,
    required this.author,
    required this.publishTime,
    this.imageTextGroups = const [],
    this.commentCount = 0,
    this.likeCount = 0,
  });
}