enum VideoEnum {
  /// 直播
  Live,
  /// 视频
  Video,
  /// 广告
  Ad,
}

class VideoModel {
  String title;
  String id;
  String coverUrl;
  String videoUrl;
  int videoDuration;

  int createTime;
  String author;

  String authorIcon;
  bool isFollow;
  bool isLike;
  int likeCount;
  int commentCount;
  bool isCollect;
  int collectCount;
  int currentDuration;

  VideoEnum videoType;


  VideoModel({
    this.title = '', 
    required this.id, 
    required this.coverUrl, 
    required this.videoUrl, 
    this.videoDuration = 0,
    this.createTime = 0,
    this.author = '',

    this.isLike = false,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isCollect = false,
    this.collectCount = 0,

    this.authorIcon = '',
    this.isFollow = false,
    this.currentDuration = 0,

    this.videoType = VideoEnum.Video,
  });

  static VideoModel fromJson(Map<String, dynamic> json) {
    return VideoModel(
      title: json['title'],
      id : json['id'],
      coverUrl: json['coverUrl'],
      videoUrl: json['videoUrl'],
      videoDuration: json['videoDuration'],
      createTime: json['createTime'],
      isLike: json['isLiked'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      isCollect: json['isMarked'],
      collectCount: json['markCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'title' : title,
      'videoUrl' : videoUrl,
      'coverUrl' : coverUrl,
      'videoDuration' : videoDuration,
      'createTime' : createTime,
      'author' : author,
      'likeCount' : likeCount,
      'isLike' : isLike,
      'commentCount' : commentCount,
      'collectCount' : collectCount,
      'isCollect' : isCollect,
      'authorIcon' : authorIcon,
      'isFollow' : isFollow,
      'currentDuration' : currentDuration,
    };
  }  
}

