import '../base/base_model.dart';
import 'author_response.dart';
import 'news_response.dart';

/// 作者信息类，实现AuthorResponse接口
class AuthorInfo implements AuthorResponse {
  /// 作者id
  @override
  String authorId = '';

  /// 作者昵称
  @override
  String authorNickName = '';

  /// 作者icon
  @override
  String authorIcon = '';

  /// 作者简介
  @override
  String authorDesc = '';

  /// 作者ip
  @override
  String authorIp = '';

  /// 关注的人数
  @override
  int watchersCount = 0;

  /// 粉丝数量
  @override
  int followersCount = 0;

  /// 获赞数量
  @override
  int likeNum = 0;

  /// 关注的人id集合
  @override
  List<String>? watchers;

  /// 粉丝id集合
  @override
  List<String>? followers;

  /// 手机号
  @override
  String? authorPhone;

  /// 默认构造函数（添加这一行）
  AuthorInfo();

  factory AuthorInfo.fromJson(Map<String, dynamic> json) {
    final authorInfo = AuthorInfo();
    authorInfo.authorId = json['authorId'] as String? ?? '';
    authorInfo.authorNickName = json['authorNickName'] as String? ?? '';
    authorInfo.authorIcon = json['authorIcon'] as String? ?? '';
    authorInfo.authorDesc = json['authorDesc'] as String? ?? '';
    authorInfo.authorIp = json['authorIp'] as String? ?? '';
    authorInfo.watchersCount = json['watchersCount'] as int? ?? 0;
    authorInfo.followersCount = json['followersCount'] as int? ?? 0;
    authorInfo.likeNum = json['likeNum'] as int? ?? 0;
    authorInfo.watchers = json['watchers'] != null
        ? List<String>.from(json['watchers'] as List<dynamic>)
        : null;
    authorInfo.followers = json['followers'] != null
        ? List<String>.from(json['followers'] as List<dynamic>)
        : null;
    authorInfo.authorPhone = json['authorPhone'] as String?;
    return authorInfo;
  }

  /// 转换为JSON格式
  @override
  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorNickName': authorNickName,
      'authorIcon': authorIcon,
      'authorDesc': authorDesc,
      'authorIp': authorIp,
      'watchersCount': watchersCount,
      'followersCount': followersCount,
      'likeNum': likeNum,
      'watchers': watchers,
      'followers': followers,
      'authorPhone': authorPhone,
    };
  }

  static AuthorInfo fromAuthorResponse(AuthorResponse value) {
    final AuthorInfo authorInfo = AuthorInfo();
    authorInfo.authorId = value.authorId;
    authorInfo.authorNickName = value.authorNickName;
    authorInfo.authorIcon = value.authorIcon;
    authorInfo.authorDesc = value.authorDesc;
    authorInfo.authorIp = value.authorIp;
    authorInfo.watchersCount = value.watchersCount;
    authorInfo.followersCount = value.followersCount;
    authorInfo.likeNum = value.likeNum;
    authorInfo.watchers = value.watchers;
    authorInfo.followers = value.followers;
    authorInfo.authorPhone = value.authorPhone;
    return authorInfo;
  }
}

class FlexLayoutModel {
  final NavInfo navInfo;
  final List<String> articles;
  final Map<String, dynamic> extraInfo;

  FlexLayoutModel({
    required this.navInfo,
    required this.articles,
    required this.extraInfo,
  });

  factory FlexLayoutModel.fromJson(Map<String, dynamic> json) {
    return FlexLayoutModel(
      navInfo: NavInfo(),
      articles: List<String>.from(json['articles'] as List<dynamic>),
      extraInfo: json['extraInfo'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'navInfo': {'setting': navInfo.setting},
      'articles': articles,
      'extraInfo': extraInfo,
    };
  }
}

/// 请求列表数据类
class RequestListData {
  /// 样式信息
  NavInfo navInfo = NavInfo();

  /// 文章列表
  List<NewsResponse> articles = [];

  /// 额外信息
  Map<String, dynamic>? extraInfo;

  RequestListData({
    required this.navInfo,
    required this.articles,
    this.extraInfo,
  });

  factory RequestListData.fromJson(Map<String, dynamic> json) {
    return RequestListData(
      articles: (json['articles'] as List<dynamic>? ?? [])
          .map((e) => NewsResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      extraInfo: json['extraInfo'] as Map<String, dynamic>? ?? {},
      navInfo: NavInfo(),
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'navInfo': {'setting': navInfo.setting},
      'articles': articles.map((e) => e.toJson()).toList(),
      'extraInfo': extraInfo,
    };
  }
}

/// 布局设置类
class LayoutSetting {
  String type = '';
  Map<String, dynamic> style = {};
  String showType = '';
  List<LayoutSetting> children = [];

  LayoutSetting();

  factory LayoutSetting.fromJson(Map<String, dynamic> json) {
    final setting = LayoutSetting();
    setting.type = json['type'] as String? ?? '';
    setting.style = json['style'] as Map<String, dynamic>? ?? {};
    setting.showType = json['showType'] as String? ?? '';
    setting.children = (json['children'] as List<dynamic>? ?? [])
        .map((e) => LayoutSetting.fromJson(e as Map<String, dynamic>))
        .toList();
    return setting;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'style': style,
      'showType': showType,
      'children': children.map((e) => e.toJson()).toList(),
    };
  }
}

/// 布局样式类
class LayoutStyle {
  String backgroundColor = '';
  int borderRadius = 0;
  int space = 0;
  dynamic paddingLeft = 0;
  dynamic paddingRight = 0;
  dynamic paddingBottom = 0;
  dynamic paddingTop = 0;

  /// 默认构造函数
  LayoutStyle();

  /// 从JSON数据创建LayoutStyle实例
  factory LayoutStyle.fromJson(Map<String, dynamic> json) {
    final style = LayoutStyle();
    style.backgroundColor = json['backgroundColor'] as String? ?? '';
    style.borderRadius = json['borderRadius'] as int? ?? 0;
    style.space = json['space'] as int? ?? 0;
    style.paddingLeft = json['paddingLeft'];
    style.paddingRight = json['paddingRight'];
    style.paddingBottom = json['paddingBottom'];
    style.paddingTop = json['paddingTop'];
    return style;
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'borderRadius': borderRadius,
      'space': space,
      'paddingLeft': paddingLeft,
      'paddingRight': paddingRight,
      'paddingBottom': paddingBottom,
      'paddingTop': paddingTop,
    };
  }
}

/// 布局参数类
class LayoutParams {
  NewsResponse nativeCardData;
  int currentIndex = 0;
  Map<String, dynamic> extraInfo = {};
  LayoutSetting layout = LayoutSetting();

  /// 创建一个LayoutParams实例
  LayoutParams(
    this.nativeCardData,
    this.currentIndex,
    this.extraInfo,
    this.layout,
  );

  /// 从JSON数据创建LayoutParams实例
  factory LayoutParams.fromJson(Map<String, dynamic> json) {
    return LayoutParams(
      NewsResponse.fromJson(json['nativeCardData'] as Map<String, dynamic>),
      json['currentIndex'] as int? ?? 0,
      json['extraInfo'] as Map<String, dynamic>? ?? {},
      LayoutSetting.fromJson(json['layout'] as Map<String, dynamic>),
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'nativeCardData': nativeCardData.toJson(),
      'currentIndex': currentIndex,
      'extraInfo': extraInfo,
      'layout': layout.toJson(),
    };
  }
}
