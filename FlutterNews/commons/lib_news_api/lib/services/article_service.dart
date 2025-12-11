import '../utils/utils.dart';
import '../constants/constants.dart';
import '../database/news_type.dart';
import 'mockdata/mock_article.dart';
import 'mockdata/mock_flex_layout.dart';
import '../params/base/base_model.dart';
import '../params/response/layout_response.dart';
import 'base_news_service.dart';
import 'mine_service.dart';

/// 新闻-文章类
class ArticleService extends BaseNewsService {
  /// 添加文章
  BaseNews addArticle(String title, String content, String setting,
      List<PostImgList> postImgList) {
    final authorInfo = MineServiceApi.queryAuthorInfo();

    final articleInfo = BaseNews(
      id: 'article_${Utils.randomArticleId()}',
      type: NewsEnum.article,
      title: title,
      authorId: authorInfo?.authorId ?? '',
      markCount: 0,
      postImgList: postImgList,
      recommends: [
        SimpleNews(newsId: 'article_6', newsType: NewsEnum.video),
        SimpleNews(newsId: 'article_8', newsType: NewsEnum.video),
      ],
      richContent: content,
      createTime: DateTime.now().millisecondsSinceEpoch,
      commentCount: 0,
      likeCount: 0,
      shareCount: 0,
      isLiked: false,
      isMarked: false,
      articleFrom: authorInfo?.authorNickName,
      navInfo: NavInfo(setting: setting),
    );
    MockArticle.list.insert(0, articleInfo);
    return articleInfo;
  }

  void addFlexLayout(String articleId, String setting) {
    final flexInfo = FlexLayoutModel(
      navInfo: NavInfo(setting: setting),
      articles: [articleId],
      extraInfo: {
        'flexId': 'flexId_${Utils.randomArticleId()}',
        'isNeedAuthor': false,
      },
    );
    MockFlexLayout.recommendList.insert(1, flexInfo);
  }
}

final ArticleServiceApi = ArticleService();
