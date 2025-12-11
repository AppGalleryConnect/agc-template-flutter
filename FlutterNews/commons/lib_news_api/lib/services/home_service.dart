import 'mockdata/mock_article.dart';
import 'mockdata/mock_post.dart';
import 'mockdata/mock_video.dart';
import 'mockdata/mock_flex_layout.dart';
import '../params/response/layout_response.dart';
import '../params/response/news_response.dart';
import 'mine_service.dart';
import 'mockdata/mock_user.dart';
import '../utils/utils.dart';
import 'dart:math';
import '../constants/constants.dart';
import 'base_news_service.dart';

/// 首页服务类
class HomeService {
  static HomeService? _instance;
  HomeService._internal();
  factory HomeService() {
    _instance ??= HomeService._internal();
    return _instance!;
  }

  double fontSizeRatio = 1.0;

  /// 查询首页推荐流
  Future<List<RequestListData>> queryHomeRecommendList(String postType,
      {int currentIndex = 10, int currentPage = 0}) async {
    List<RequestListData> postList = [];
    switch (postType) {
      case 'recommend':
        postList = getRecommendList(MockFlexLayout.recommendList);
        break;
      case 'hotService':
        postList = getRecommendList(MockFlexLayout.hotList);
        break;
      case 'hotTopChart':
        postList = getRecommendList(MockFlexLayout.hotTopChart);
        break;
      default:
        postList = Utils.shuffleArray(
            getRecommendList(MockFlexLayout.recommendList).sublist(1));
        break;
    }
    int end = min(currentPage + currentIndex, postList.length);
    int start = min(currentPage, end);
    return postList.sublist(start, end);
  }

  Future<List<RequestListData>> queryNextPageData(
      String postType, int currentIndex, int currentPage) async {
    List<RequestListData> postList;
    if (postType == 'follow') {
      postList = queryHomeFollowList([NewsEnum.article],
          currentIndex: currentIndex, currentPage: currentPage);
    } else {
      postList = await queryHomeRecommendList(postType,
          currentIndex: currentIndex, currentPage: currentPage);
    }
    return postList;
  }

  List<RequestListData> getRecommendList(List<FlexLayoutModel> recommendList) {
    return recommendList.map((item) {
      final flexData = item.articles
          .map((articleId) {
            final raw = BaseNewsServiceApi.queryRawNews(articleId);
            if (raw != null) {
              return BaseNewsServiceApi.handleRawNews(raw);
            }
            return null;
          })
          .where((v) => v != null)
          .cast<NewsResponse>()
          .toList();
      final copyItem = RequestListData(
        articles: flexData,
        navInfo: item.navInfo,
        extraInfo: item.extraInfo,
      );
      return copyItem;
    }).toList();
  }

  /// 查询互动关注流
  Future<List<NewsResponse>> queryActionFollowList(int pageIndex) async {
    final myUserInfo = MineServiceApi.queryAuthorRaw();
    final articles = MockArticle.list
        .where((v) =>
            myUserInfo?.watchers.contains(v.authorId) == true &&
            v.type == NewsEnum.post)
        .map((news) => BaseNewsServiceApi.queryNews(news.id))
        .where((v) => v != null)
        .cast<NewsResponse>()
        .toList();
    final videos = MockVideo.list
        .where((v) =>
            myUserInfo?.watchers.contains(v.authorId) == true &&
            v.type == NewsEnum.post)
        .map((news) => BaseNewsServiceApi.queryNews(news.id))
        .where((v) => v != null)
        .cast<NewsResponse>()
        .toList();
    final posts = MockPost.list
        .where((v) =>
            myUserInfo?.watchers.contains(v.authorId) == true &&
            v.type == NewsEnum.post)
        .map((news) => BaseNewsServiceApi.queryNews(news.id))
        .where((v) => v != null)
        .cast<NewsResponse>()
        .toList();
    final result = Utils.shuffleArray([...videos, ...posts, ...articles]);
    return result.sublist(0, min(pageIndex, result.length));
  }

  /// 查询互动推荐
  Future<List<NewsResponse>> queryActionRecommendList() async {
    final videos = MockVideo.list
        .where((v) => v.type == NewsEnum.post)
        .map((news) => BaseNewsServiceApi.queryNews(news.id))
        .where((v) => v != null)
        .cast<NewsResponse>()
        .toList();
    final posts = MockPost.list
        .where((v) => v.type == NewsEnum.post)
        .map((news) => BaseNewsServiceApi.queryNews(news.id))
        .where((v) => v != null)
        .cast<NewsResponse>()
        .toList();
    return Utils.shuffleArray([...videos, ...posts]);
  }

  /// 查询首页关注流
  List<RequestListData> queryHomeFollowList(List<NewsEnum> newsType,
      {int currentIndex = 10, int currentPage = 0}) {
    final myUserInfo = MineServiceApi.queryAuthorRaw();
    final articles = MockArticle.list
        .where((v) =>
            myUserInfo?.watchers.contains(v.authorId) == true &&
            newsType.contains(v.type))
        .map((v) => BaseNewsServiceApi.handleRawNews(v))
        .map((v) => BaseNewsServiceApi.layoutTrans(v))
        .toList();
    final videos = MockVideo.list
        .where((v) =>
            myUserInfo?.watchers.contains(v.authorId) == true &&
            newsType.contains(v.type))
        .map((v) => BaseNewsServiceApi.handleRawNews(v))
        .map((v) => BaseNewsServiceApi.layoutTrans(v))
        .toList();
    final posts = MockPost.list
        .where((v) =>
            (myUserInfo?.watchers.contains(v.authorId) == true &&
                newsType.contains(v.type)) ||
            v.authorId == myUserInfo?.authorId)
        .map((v) => BaseNewsServiceApi.handleRawNews(v))
        .map((v) => BaseNewsServiceApi.layoutTrans(v))
        .toList();
    final result = Utils.shuffleArray([...videos, ...posts, ...articles]);
    int end = min(currentPage + currentIndex, result.length);
    int start = min(currentPage, end);
    return result.sublist(start, end);
  }

  /// 查询服务卡片-新闻列表
  List<NewsResponse?> queryFormNewsList() {
    final articleId = Utils.shuffleArray([...MockArticle.list]).first.id;
    final postId = Utils.shuffleArray([...MockPost.list]).first.id;
    final videoId = Utils.shuffleArray([...MockVideo.list]).first.id;
    final list = [articleId, postId, videoId];
    return list
        .map((v) => BaseNewsServiceApi.queryNews(v))
        .where((v) => v != null)
        .toList();
  }

  /*
   * 根据IP获取当前所在城市
   * IP 地理位置解析接口，这里mock返回南京
   */
  Future<String> queryCityByIP(String? ip) async {
    if (ip != null && ip.isNotEmpty) {
      MockUser.myself.authorIp = '南京';
      return '南京';
    }
    return '';
  }
}

final HomeServiceApi = HomeService();
