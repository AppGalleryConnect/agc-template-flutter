import '../models/news_model.dart';

class NewsService {
  List<NewsSection> fetchNewsSections() {
    // 模拟从网络获取初始化数据
    return [
      NewsSection(
        '热门新闻',
        List.generate(
            6,
            (i) => NewsItem(
                  id: 'a$i',
                  title: '新闻标题 A$i 新闻标题',
                  author: '作者$i',
                  publishTime: DateTime.now().subtract(Duration(days: i)),
                  type: NewsType.article,
                  imageUrl: "https://picsum.photos/600/400?random=$i",
                )),
        showMore: true,
        limit: 6,
      ),
      NewsSection(
        '科技新闻',
        List.generate(
            7,
            (i) => NewsItem(
                id: 'b$i',
                title: '新闻标题 B$i 新闻标题 新闻标题',
                author: '作者$i',
                publishTime: DateTime.now().subtract(Duration(days: i)),
                type: NewsType.article,
                imageUrl: "https://picsum.photos/600/400?random=$i")),
        limit: 7,
      ),
      NewsSection(
        '体育新闻',
        List.generate(
            6,
            (i) => NewsItem(
                id: 'c$i',
                title: '新闻标题 C$i 新闻标题',
                author: '作者$i',
                publishTime: DateTime.now().subtract(Duration(days: i)),
                type: NewsType.article,
                imageUrl: "https://picsum.photos/600/400?random=$i")),
        showMore: true,
        limit: 6,
      ),
      NewsSection(
        '娱乐新闻',
        List.generate(
            7,
            (i) => NewsItem(
                id: 'd$i',
                title: '新闻标题 C$i 新闻标题',
                author: '作者$i',
                publishTime: DateTime.now().subtract(Duration(days: i)),
                type: NewsType.article,
                imageUrl: "https://picsum.photos/600/400?random=$i")),
        showMore: true,
        limit: 7,
      ),
    ];
  }

  List<NewsItem> fetchMoreNews(String sectionTitle, int limit) {
    // 模拟从网络获取更多数据
    return List.generate(
      limit,
      (i) => NewsItem(
        id: 'e$i',
        title: '新闻标题 e$i 查看更多新闻',
        author: '作者$i',
        publishTime: DateTime.now().subtract(Duration(days: i)),
        type: NewsType.article,
        imageUrl: "https://picsum.photos/600/400?random=$i",
      ),
    );
  }
}
