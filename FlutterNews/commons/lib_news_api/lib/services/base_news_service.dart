import 'dart:convert';
import 'mockdata/mock_post.dart';
import 'mockdata/mock_video.dart';
import '../utils/time_utils.dart';
import 'package:get/get.dart';
import '../database/news_type.dart';
import 'mockdata/mock_article.dart';
import 'author_service.dart';
import 'comment_service.dart';
import '../params/response/layout_response.dart';
import '../params/response/news_response.dart';
import '../params/base/base_model.dart';
import '../constants/constants.dart';

/// 新闻基础服务类
class BaseNewsService {
  /// 查询数据库字段
  BaseNews? queryRawNews(String newsId) {
    final list = [...MockArticle.list, ...MockVideo.list, ...MockPost.list];
    return list.firstWhereOrNull((v) => v.id == newsId);
  }

  /// 数据库字段转换成接口字段
  NewsResponse handleRawNews(BaseNews item, [bool ignoreRec = false]) {
    // 深拷贝对象
    final copyItem = NewsResponse.fromJson(
        json.decode(json.encode(item.toJson())) as Map<String, dynamic>);

    final authorInfo = authorServiceApi.queryAuthorInfo(item.authorId);
    if (authorInfo != null) {
      copyItem.author = authorInfo;
    }
    copyItem.commentCount = CommentServiceApi.queryTotalCommentCount(item.id);
    copyItem.comments = [];
    copyItem.relativeTime = TimeUtils.getDateDiff(copyItem.createTime);
    if (copyItem.recommends != null &&
        copyItem.recommends!.isNotEmpty &&
        !ignoreRec) {
      copyItem.recommends = (item.recommends ?? [])
          .map((SimpleNews news) {
            final raw = queryRawNews(news.newsId);
            if (raw != null) {
              return handleRawNews(raw, true);
            }
            return null;
          })
          .where((v) => v != null)
          .cast<NewsResponse>()
          .toList();
    }
    return copyItem;
  }

  /// 查询新闻
  NewsResponse? queryNews(String newsId) {
    final item = queryRawNews(newsId);
    if (item != null) {
      return handleRawNews(item, false);
    }
    return null;
  }

  /// 查询作者的所有创作内容
  List<NewsResponse> queryAllNews(String userId) {
    return [...MockArticle.list, ...MockVideo.list, ...MockPost.list]
        .where((v) => v.authorId == userId)
        .map((v) => handleRawNews(v, true))
        .toList();
  }

  /// 查询所有文章、动态、详情
  List<NewsResponse> queryAllNewsList() {
    return [...MockArticle.list, ...MockVideo.list, ...MockPost.list]
        .map((v) => handleRawNews(v, true))
        .toList();
  }

  /// 查询搜索结果列表
  List<RequestListData> querySearchResultList(String search) {
    return [...MockArticle.list, ...MockVideo.list, ...MockPost.list]
        .where((v) => v.title.contains(search))
        .map((v) => handleRawNews(v))
        .map((v) => layoutTrans(v))
        .toList();
  }

  /// 转换成动态布局的结构
  RequestListData layoutTrans(NewsResponse news) {
    NavInfo navInfo = news.navInfo ?? NavInfo();
    if (navInfo.parsedSetting == null ||
        navInfo.parsedSetting!.showType == null) {
      String defaultSetting;
      if (news.type == NewsEnum.video) {
        defaultSetting =
            '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"TopTextBottomVideoCard","name":"上文下图"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}';
      } else if (news.type == NewsEnum.article || news.type == NewsEnum.post) {
        final imageCount = news.postImgList?.length ?? 0;
        if (imageCount > 1) {
          defaultSetting =
              '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"TopTextBottomImageCard","name":"上文下图"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}';
        } else {
          defaultSetting =
              '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"LeftTextRightImageCard","name":"左文右图"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}';
        }
      } else {
        defaultSetting =
            '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"LeftTextRightImageCard","name":"左文右图"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}';
      }
      navInfo = NavInfo(setting: defaultSetting);
    }

    return RequestListData(
      navInfo: navInfo,
      articles: [news],
      extraInfo: news.extraInfo ?? {},
    );
  }

  /// 查询用户发布的文章
  List<RequestListData> queryAuthorArticles(String userId) {
    final list = MockArticle.list
        .where((v) => v.authorId == userId)
        .map((v) => handleRawNews(v))
        .map((v) => layoutTrans(v))
        .toList();
    list.sort((a, b) =>
        (b.articles.first.createTime) - (a.articles.first.createTime));
    return list;
  }

  /// 查询用户发布的视频
  List<RequestListData> queryAuthorVideos(String userId) {
    final list = MockVideo.list
        .where((v) => v.authorId == userId)
        .map((v) => handleRawNews(v))
        .map((v) => layoutTrans(v))
        .toList();
    list.sort((a, b) =>
        (b.articles.first.createTime) - (a.articles.first.createTime));
    return list;
  }

  /// 查询用户发布的动态
  List<RequestListData> queryAuthorPosts(String userId) {
    final list = MockPost.list
        .where((v) => v.authorId == userId)
        .map((v) => handleRawNews(v))
        .map((v) => layoutTrans(v))
        .toList();
    list.sort((a, b) =>
        (b.articles.first.createTime) - (a.articles.first.createTime));
    return list;
  }

  /// 收藏
  void addMark(String newsId) {
    final news = queryRawNews(newsId);
    if (news != null) {
      news.isMarked = true;
      news.markCount += 1;
    }
  }

  /// 取消收藏
  void cancelMark(String newsId) {
    final news = queryRawNews(newsId);
    if (news != null) {
      news.isMarked = false;
      news.markCount -= 1;
    }
  }
}

// 单例实例
final BaseNewsServiceApi = BaseNewsService();
