import 'package:lib_common/utils/base_view_model.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';
import 'package:lib_news_api/services/author_service.dart';
import 'package:lib_news_api/params/response/author_response.dart';
import '../common/author_data_source.dart';

class FollowerPageViewModel extends BaseViewModel {
  String userId = '';
  String title = '我的粉丝';
  String emptyTip = '暂无粉丝';
  AuthorDataSource dataSource = AuthorDataSource();
  bool isLoading = false;
  List<AuthorModel> get authorList => dataSource.originDataArray;
  Future<void> handleWatchAction(
      String authorId, bool isCurrentlyWatching) async {
    try {
      isLoading = true;
      notifyListeners();
      if (!userInfoModel.isLogin) {
        RouterUtils.of.pushPathByName(RouterMap.HUAWEI_LOGIN_PAGE);
        return;
      }


      bool success = false;
      if (isCurrentlyWatching) {
        success = authorServiceApi.unfollowAuthor(
            userInfoModel.authorId, authorId,
            fromFollowerPage: true);
      } else {
        // 处理回关操作
        success =
            authorServiceApi.followAuthor(userInfoModel.authorId, authorId);
      }
      if (success) {
        await Future.delayed(const Duration(milliseconds: 200));
        queryFollowList();
      }
    } catch (e) {
      // 移除提示功能
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void handleWatchStatusChanged() {
    queryFollowList();
  }

  void setUserId(String id) {
    userId = id;
    if (userInfoModel.isLogin &&
        id.isNotEmpty &&
        id != userInfoModel.authorId) {
      title = '他的粉丝';
    } else {
      title = '我的粉丝';
    }
    // 查询粉丝列表
    queryFollowList();
  }

  void queryFollowList() {
    try {
      isLoading = true;
      notifyListeners();
      if (!userInfoModel.isLogin &&
          (userId.isEmpty || userId == userInfoModel.authorId)) {
        dataSource.originDataArray.clear();
        notifyListeners();
        return;
      }
      String effectiveUserId = userId.isNotEmpty
          ? userId
          : userInfoModel.authorId.isNotEmpty
              ? userInfoModel.authorId
              : '001';

      // 使用authorServiceApi查询真实粉丝数据
      final List<AuthorResponse> responses =
          authorServiceApi.queryFollowers(effectiveUserId);
      final List<AuthorModel> list = responses.map((response) {
        final model = AuthorModel(response);
        if (!model.watchers!.contains(userInfoModel.authorId)) {
          model.watchers!.add(userInfoModel.authorId);
        }
        return model;
      }).toList();
      dataSource.originDataArray.clear();
      dataSource.pushDataArray(list);
      notifyListeners();
    } catch (e) {
      // 移除提示功能
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void init() {
    super.init();
    userInfoModel.addListener(() {
      if (userInfoModel.isLogin) {
        if (userId.isEmpty) {
          userId = userInfoModel.authorId;
          title = '我的粉丝';
        }
        queryFollowList();
      } else {
        dataSource.originDataArray.clear();
        notifyListeners();
      }
    });
    if (userId.isEmpty) {
      userId =
          userInfoModel.authorId.isNotEmpty ? userInfoModel.authorId : '001';
      title = '我的粉丝';
    } else {
      if (userId != userInfoModel.authorId) {
        title = '他的粉丝';
      } else {
        title = '我的粉丝';
      }
    }

    // 查询粉丝列表
    queryFollowList();
  }

  void loadMore() {
    notifyListeners();
  }

  void customBack() {
    RouterUtils.of.popWithResult(result: 'refresh');
  }
}
