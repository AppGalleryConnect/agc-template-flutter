import '../constants/constants.dart';
import '../database/news_type.dart';
import '../params/request/common_request.dart';
import '../utils/utils.dart';
import 'mine_service.dart';
import 'mockdata/mock_post.dart';
import 'base_news_service.dart';
import '../params/response/news_response.dart';
import '../params/base/base_model.dart';

/// 新闻-动态服务类（不继承，使用组合）
class PostService {
  static PostService? _instance;
  PostService._internal();
  factory PostService() {
    _instance ??= PostService._internal();
    return _instance!;
  }

  /// 查询推荐动态列表
  List<NewsResponse> queryPostRecommendList() {
    final posts = MockPost.list
        .map((post) => BaseNewsService().queryNews(post.id))
        .where((v) => v != null)
        .cast<NewsResponse>()
        .toList();
    if (posts.length > 3) {
      final newPosts = posts.sublist(0, 3);
      final oldPosts = posts.sublist(3);
      return [...newPosts, ...Utils.shuffleArray(oldPosts)];
    }
    return posts;
  }

  /// 查询关注的动态列表
  List<NewsResponse> queryPostFollowList() {
    final myUserInfo = MineServiceApi.queryAuthorRaw();
    if (myUserInfo == null) return [];
    final posts = MockPost.list
        .where((v) => myUserInfo.watchers.contains(v.authorId))
        .map((post) => BaseNewsService().queryNews(post.id))
        .where((v) => v != null)
        .cast<NewsResponse>()
        .toList();
    return Utils.shuffleArray(posts);
  }

  /// 查询附近的动态列表
  List<NewsResponse> queryPostNearList() {
    return [];
  }

  /// 发布动态
  void publishPost(PostRequest post) {
    final authorInfo = MineServiceApi.queryAuthorInfo();
    if (authorInfo == null) return;
    final postInfo = BaseNews(
      id: 'post_${Utils.randomArticleId()}',
      type: NewsEnum.post,
      title: post.postBody,
      authorId: authorInfo.authorId,
      createTime: DateTime.now().millisecondsSinceEpoch,
      commentCount: 0,
      markCount: 0,
      likeCount: 0,
      shareCount: 0,
      isLiked: false,
      isMarked: false,
      recommends: [
        SimpleNews(newsId: 'article_9', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_11', newsType: NewsEnum.article),
      ],
      postImgList: post.postImgList,
      navInfo: NavInfo(),
    );
    MockPost.list.insert(0, postInfo);
  }
}

/// 全局单例实例，供外部调用
final PostServiceApi = PostService();
