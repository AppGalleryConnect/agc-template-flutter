class NewsSection {
  final String title;
  final List<NewsItem> items;
  final bool showMore;
  final int limit;

  NewsSection(
    this.title,
    this.items, {
    //默认不显示"查看更多"
    this.showMore = false,
    //默认显示数量
    this.limit = 5,
  });
}

class NewsItem {
  final String id;
  final String title;
  final String author;
  final DateTime? publishTime;

  // 新闻类型可以分为多种，设置对应不同的高度，可用于整体高度计算
  final NewsType type;
  final String? imageUrl;

  NewsItem({
    required this.id,
    required this.title,
    required this.author,
    this.publishTime,
    required this.type,
    this.imageUrl,
  }) {
    if (id.isEmpty) {
      throw ArgumentError('id不能为空');
    }
    if (title.isEmpty) {
      throw ArgumentError('标题不能为空');
    }
    if (author.isEmpty) {
      throw ArgumentError('作者不能为空');
    }
  }
}

// todo 可进行类型扩展
enum NewsType {
  article,
  video,
}
