// RecommendModel.dart
// FeedCardInfoModel 类
import 'package:lib_news_api/constants/constants.dart';
import 'package:lib_news_api/observedmodels/comment_model.dart';
import 'package:lib_news_api/params/base/base_model.dart';
import 'package:lib_news_api/params/response/layout_response.dart';
import 'package:lib_news_api/params/response/news_response.dart';

class FeedCardInfoModel {
  String id = '';
  NewsEnum type = NewsEnum.article;
  String title = '';
  AuthorInfo author = AuthorInfo();
  int createTime = 0;
  List<CommentModel> comments = [];
  int commentCount = 0;
  int markCount = 0;
  int likeCount = 0;
  int shareCount = 0;
  bool isLiked = false;
  bool isMarked = false;
  String? relativeTime = '';
  String? richContent;
  String? videoUrl;
  String? coverUrl;
  int? videoDuration;
  String? postBody;
  List<PostImgList> postImgList = [];
  int? totalCount;
  bool? isWatch = false;

  FeedCardInfoModel({
    String? id,
    NewsEnum? type,
    String? title,
    AuthorInfo? author,
    int? createTime,
    List<CommentModel>? comments,
    int? commentCount,
    int? markCount,
    int? likeCount,
    int? shareCount,
    bool? isLiked,
    bool? isMarked,
    this.relativeTime,
    this.richContent,
    this.videoUrl,
    this.coverUrl,
    this.videoDuration,
    this.postBody,
    List<PostImgList>? postImgList,
    this.totalCount,
    this.isWatch,
  }) {
    this.id = id ?? '';
    this.type = type ?? NewsEnum.article;
    this.title = title ?? '';
    this.author = author ?? AuthorInfo();
    this.createTime = createTime ?? 0;
    this.comments = comments ?? [];
    this.commentCount = commentCount ?? 0;
    this.markCount = markCount ?? 0;
    this.likeCount = likeCount ?? 0;
    this.shareCount = shareCount ?? 0;
    this.isLiked = isLiked ?? false;
    this.isMarked = isMarked ?? false;
    this.postImgList = postImgList ?? [];
    isWatch = isWatch ?? false;
    relativeTime = relativeTime ?? '';
  }

  FeedCardInfoModel.fromFeedCardInfoModel(FeedCardInfoModel? value) {
    id = value?.id ?? '';
    type = value?.type ?? NewsEnum.article;
    title = value?.title ?? '';
    author = value?.author ?? AuthorInfo();
    createTime = value?.createTime ?? 0;
    comments = value?.comments ?? [];
    commentCount = value?.commentCount ?? 0;
    markCount = value?.markCount ?? 0;
    likeCount = value?.likeCount ?? 0;
    shareCount = value?.shareCount ?? 0;
    isLiked = value?.isLiked ?? false;
    isMarked = value?.isMarked ?? false;
    postImgList = value?.postImgList ?? [];
    isWatch = value?.isWatch ?? false;
    relativeTime = value?.relativeTime ?? '';
  }

  FeedCardInfoModel.fromNewsResponse(NewsResponse? value) {
    id = value?.id ?? '';
    type = value?.type ?? NewsEnum.article;
    title = value?.title ?? '';
    author = value?.author != null
        ? AuthorInfo.fromAuthorResponse(value!.author!)
        : AuthorInfo();
    createTime = value?.createTime ?? 0;
    comments = value?.comments.map((e) => CommentModel(e)).toList() ?? [];
    commentCount = value?.commentCount ?? 0;
    markCount = value?.markCount ?? 0;
    likeCount = value?.likeCount ?? 0;
    shareCount = value?.shareCount ?? 0;
    isLiked = value?.isLiked ?? false;
    isMarked = value?.isMarked ?? false;
    postImgList = value?.postImgList ?? [];
    isWatch = false;
    relativeTime = value?.relativeTime ?? '';
  }
}
