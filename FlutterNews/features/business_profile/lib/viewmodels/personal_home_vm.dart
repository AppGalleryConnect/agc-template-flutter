import 'package:lib_common/utils/base_view_model.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_news_api/services/author_service.dart';
import 'package:lib_news_api/services/base_news_service.dart';
import 'package:lib_news_api/params/response/layout_response.dart'; // 添加这行导入
import '../common/news_data_source.dart';

class PersonalPageViewModel extends BaseViewModel {
  String userId = '';
  AuthorInfo? userInfo;
  String titleText = '';
  int curIndex = 0;
  int targetIndex = 0;
  bool loading = false;
  LayoutNewsDataSource articleDataSource = LayoutNewsDataSource();
  LayoutNewsDataSource videoDataSource = LayoutNewsDataSource();
  LayoutNewsDataSource postDataSource = LayoutNewsDataSource();
  List<dynamic> dataSource = [];

  PersonalPageViewModel() {
    dataSource = [articleDataSource, videoDataSource, postDataSource];
    userInfoModel.addListener(_onUserInfoChanged);
  }

  void _onUserInfoChanged() {
    bool isCurrentUser = userId == userInfoModel.authorId ||
        (userId == '001' && userInfoModel.authorId.isEmpty);

    if (isCurrentUser) {
      queryAuthorInfo();
    }
  }

  @override
  void dispose() {
    userInfoModel.removeListener(_onUserInfoChanged);
    super.dispose();
  }

  @override
  void init() {
    if (userId.isEmpty) {
      userId = userInfoModel.authorId.isEmpty ? '001' : userInfoModel.authorId;
    }
    queryAuthorInfo();
    queryArticleList();
    queryVideoList();
    queryPostList();
  }

  void queryAuthorInfo() {
    bool isCurrentUser = userId == userInfoModel.authorId ||
        (userId == '001' && userInfoModel.authorId.isEmpty);

    if (isCurrentUser && userInfoModel.isLogin) {
      userInfo = AuthorInfo()
        ..authorId = userInfoModel.authorId
        ..authorNickName = userInfoModel.authorNickName
        ..authorIcon = userInfoModel.authorIcon
        ..authorDesc = userInfoModel.authorDesc
        ..authorIp = userInfoModel.authorIp
        ..watchersCount = userInfoModel.watchersCount > 0
            ? userInfoModel.watchersCount
            : userInfoModel.watchers.length
        ..followersCount = userInfoModel.followersCount > 0
            ? userInfoModel.followersCount
            : userInfoModel.followers.length
        ..likeNum = userInfoModel.likeNum
        ..watchers = userInfoModel.watchers
        ..followers = userInfoModel.followers
        ..authorPhone = userInfoModel.authorPhone;
    } else {
      final authorResponse = authorServiceApi.queryAuthorInfo(userId);
      if (authorResponse != null) {
        userInfo = AuthorInfo.fromAuthorResponse(authorResponse);
      } else {
        userInfo = AuthorInfo()
          ..authorId = userId
          ..authorNickName = '默认用户'
          ..authorIcon = 'https://picsum.photos/200/200'
          ..authorDesc = '这是一个默认用户的个人简介'
          ..authorIp = ''
          ..watchersCount = 100
          ..followersCount = 200
          ..likeNum = 300
          ..watchers = []
          ..followers = []
          ..authorPhone = null;
      }
    }
    notifyListeners();
  }

  void queryArticleList() {
    final list = BaseNewsServiceApi.queryAuthorArticles(userId);
    articleDataSource.setData(list);
  }

  void queryVideoList() {
    final list = BaseNewsServiceApi.queryAuthorVideos(userId);
    videoDataSource.setData(list);
  }

  void queryPostList() {
    final list = BaseNewsServiceApi.queryAuthorPosts(userId);
    for (var item in list) {
      item.extraInfo ??= {};
      item.extraInfo!['showUserBar'] = false;
      item.extraInfo!['showTimeBottom'] = true;
      item.extraInfo!['authorId'] = userId;
    }
    postDataSource.setData(list);
  }

  void onTabChange(int index) {
    curIndex = index;
    notifyListeners();
  }

  Future<void> onRefreshing() async {
    loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300), () {
      init();
      loading = false;
      notifyListeners();
    });
  }

  void jumpChatPage() {
    if (userInfo != null) {
      RouterUtils.of
          .pushPathByName(RouterMap.MINE_MSG_IM_CHAT_PAGE, param: userInfo);
    }
  }

  bool get isMyself {
    return userInfoModel.authorId == userInfo?.authorId;
  }
}
