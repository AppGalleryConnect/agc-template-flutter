import 'package:lib_news_api/constants/constants.dart';
import 'package:lib_news_api/params/response/author_response.dart';
import 'package:lib_news_api/params/response/comment_response.dart';
import 'package:lib_news_api/params/base/base_model.dart';
import 'package:lib_news_api/params/response/news_response.dart';

class VideoNewsData {
  String id = '';
  NewsEnum type = NewsEnum.video;
  String title = '';
  late AuthorResponse? author; 
  List<CommentResponse> comments = [];
  int markCount = 0;
  int likeCount = 0;
  int shareCount = 0;
  bool isLiked = false;
  bool isMarked = false;
  int commentCount = 0;
  String videoUrl = '';
  String coverUrl = '';
  int videoDuration = 0;
  int createTime = 0;
  List<PostImgList>? postImgList;
  int currentDuration;

  VideoNewsData({
    this.id = '',
    this.type = NewsEnum.video,
    this.title = '',
    this.author,
    this.comments = const [],
    this.markCount = 0,
    this.likeCount = 0,
    this.shareCount = 0,
    this.isLiked = false,
    this.isMarked = false,
    this.commentCount = 0,
    this.videoUrl = '',
    this.coverUrl = '',
    this.videoDuration = 0,
    this.createTime = 0,
    this.postImgList = const [],
    this.currentDuration = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'videoUrl': videoUrl,
      'coverUrl': coverUrl,
      'videoDuration': videoDuration,
      'createTime': createTime,
      'author': author,
      'likeCount': likeCount,
      'isLiked': isLiked,
      'comments': comments,
      'commentCount': commentCount,
      'markCount': markCount,
      'isMarked': isMarked,
      'currentDuation': currentDuration,
    };
  }

  static VideoNewsData fromCommentResponse(NewsResponse data) {
    String videoUrlStr = '';
    String coverUrlStr = '';

    if (data.videoUrl == null && data.postImgList?.isNotEmpty == true) {
      final firstImg = data.postImgList!.first;
      videoUrlStr = firstImg.picVideoUrl ?? '';
      coverUrlStr = firstImg.surfaceUrl ?? '';
    } else {
      videoUrlStr = data.videoUrl ?? '';
      coverUrlStr = data.coverUrl ?? '';
    }
    return VideoNewsData(
      id: data.id,
      title: data.title,
      type: data.type,
      author: data.author,
      comments: data.comments,
      markCount: data.markCount,
      likeCount: data.likeCount,
      isLiked: data.isLiked,
      isMarked: data.isMarked,
      commentCount: data.commentCount,
      createTime: data.createTime,
      shareCount: data.shareCount,
      postImgList: data.postImgList,
      videoUrl: videoUrlStr,
      coverUrl: coverUrlStr,
      videoDuration: data.videoDuration ?? 0,
      currentDuration: 0,
    );
  }
}
