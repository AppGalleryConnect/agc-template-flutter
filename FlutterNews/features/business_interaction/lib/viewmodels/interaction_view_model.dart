import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:lib_account/utils/login_sheet_utils.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_news_api/lib_news_api.dart';
import 'package:module_newsfeed/components/news_detail_page.dart';
import 'package:business_video/models/video_model.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';
import '../constants/constants.dart';
import 'package:lib_account/services/account_api.dart';

/// 互动视图模型类
class InteractionViewModel extends ChangeNotifier {
  /// 作者ID
  String authorId = '';

  /// 是否正在刷新
  bool isRefreshing = false;

  /// 互动列表
  List<NewsResponse> interactionList = [];

  /// 资源ID，当前选中的标签页类型
  TabEnum resourceId = TabEnum.watch;

  final EasyRefreshController controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 用户信息模型（从AccountApi获取全局单例）
  UserInfoModel get userInfoModel => AccountApi.getInstance().userInfoModel;

  /// 设置作者ID
  void setAuthorId(String authorId) {
    this.authorId = authorId;
    notifyListeners();
  }

  /// 检查是否已关注当前作者
  bool isWatch() {
    return userInfoModel.isLogin && userInfoModel.watchers.contains(authorId);
  }

  /// 初始化视图模型
  void init(TabEnum resourceId) {
    // 设置刷新状态为true
    isRefreshing = true;
    // 设置资源ID（标签页类型）
    this.resourceId = resourceId;
    // 设置默认数据获取方法为查询关注列表
    setActionData(() async => PostServiceApi.queryPostFollowList());

    userInfoModel.addListener(_onViewModelChanged);

    notifyListeners();
  }

  void _onViewModelChanged() {
    notifyListeners();
  }

  /// 设置行为数据，通过传入的API方法获取数据
  Future<void> setActionData(
      Future<List<NewsResponse>> Function() actionApi) async {
    try {
      // 调用API方法获取互动列表数据
      interactionList = await actionApi();
      // 设置刷新状态为false，表示数据加载完成
      isRefreshing = false;
      notifyListeners();
    } catch (e) {
      isRefreshing = false;
      notifyListeners();
    }
  }

  /// 标签页切换逻辑
  void tabSwitch() {
    // 根据当前资源ID（标签页类型）执行不同的数据获取操作
    switch (resourceId) {
      // 关注标签页
      case TabEnum.watch:
        setActionData(() async => PostServiceApi.queryPostFollowList());
        break;
      // 推荐标签页
      case TabEnum.recommend:
        setActionData(() async => PostServiceApi.queryPostRecommendList());
        break;
      // 附近标签页
      case TabEnum.nearby:
        // 附近和推荐使用相同的API
        setActionData(() async => PostServiceApi.queryPostRecommendList());
        break;
    }
  }

  /// 刷新数据（重新加载，可能改变顺序）
  Future<void> refresh() async {
    try {
      tabSwitch();
    } catch (e) {
      controller.finishRefresh();
    } finally {
      controller.finishRefresh();
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// 更新状态（只更新收藏、点赞等状态，保持数据顺序不变）
  void updateStates() {
    for (int i = 0; i < interactionList.length; i++) {
      final newsId = interactionList[i].id;
      final updatedNews = BaseNewsServiceApi.queryNews(newsId);
      if (updatedNews != null) {
        interactionList[i].isMarked = updatedNews.isMarked;
        interactionList[i].markCount = updatedNews.markCount;
        interactionList[i].isLiked = updatedNews.isLiked;
        interactionList[i].likeCount = updatedNews.likeCount;
        interactionList[i].commentCount = updatedNews.commentCount;
        interactionList[i].shareCount = updatedNews.shareCount;
      }
    }
    notifyListeners();
  }

  // 上拉加载：获取下一页数据
  Future<void> onLoad() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      controller.finishLoad();
    } catch (e) {
      controller.finishLoad();
    }
  }

  /// 关注操作（关注或取消关注）
  void watchOperation(BuildContext context) {
    if (!userInfoModel.isLogin) {
      LoginSheetUtils.showLoginSheet(context);
      return;
    }
    if (!isWatch()) {
      addWatch();
      return;
    }
    cancelWatch();
  }

  /// 添加关注
  void addWatch() {
    userInfoModel.addWatcher(authorId);
    MineServiceApi.addWatch(authorId);
    notifyListeners();
  }

  /// 取消关注
  void cancelWatch() {
    userInfoModel.removeWatcher(authorId);
    MineServiceApi.cancelWatch(authorId);
    notifyListeners();
  }

  /// 跳转到新闻详情页
  void actionToNewsDetails(BuildContext context, NewsResponse cardInfo,
      {bool needScrollToComment = false}) {
    // 记录浏览历史
    if (cardInfo.id.isNotEmpty) {
      MineServiceApi.addToHistory(cardInfo.id);
    }

    final hasSurfaceUrl = cardInfo.postImgList?.isNotEmpty == true &&
        cardInfo.postImgList!.first.surfaceUrl.isNotEmpty;

    if (hasSurfaceUrl) {
      final videoData = VideoNewsData.fromCommentResponse(cardInfo);
      RouterUtils.of.pushPathByName(
        RouterMap.VIDEO_PLAY_PAGE,
        param: videoData,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailPage(
            news: cardInfo,
            needScrollToComment: needScrollToComment,
            fontSizeRatio: FontScaleUtils.fontSizeRatio,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
