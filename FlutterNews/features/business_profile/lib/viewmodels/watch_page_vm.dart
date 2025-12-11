import 'package:lib_common/utils/base_view_model.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';
import 'package:lib_news_api/services/author_service.dart';
import 'package:lib_news_api/params/response/author_response.dart';
import '../common/author_data_source.dart';

class WatchPageViewModel extends BaseViewModel {
  String userId = '';
  String title = '我的关注';
  String emptyTip = '暂无关注';
  AuthorDataSource dataSource = AuthorDataSource();
  bool isLoading = false;
  List<AuthorModel> get authorList => dataSource.originDataArray;
  void handleWatchStatusChanged() {
    queryWatchList();
  }

  void setUserId(String id) {
    userId = id;
    if (userInfoModel.isLogin &&
        id.isNotEmpty &&
        id != userInfoModel.authorId) {
      title = '他的关注';
    } else {
      title = '我的关注';
    }
    queryWatchList();
  }

  void queryWatchList() {
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
      final List<AuthorResponse> responses =
          authorServiceApi.queryWatchers(effectiveUserId);
      final List<AuthorModel> list = responses.map((v) {
        final model = AuthorModel(v);
        model.setForceWatchStatus(true);
        return model;
      }).toList();
      dataSource.originDataArray.clear();
      dataSource.pushDataArray(list);
      notifyListeners();
    } catch (e) {
      // 错误提示
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleWatchAction(
      String authorId, bool isCurrentlyWatching) async {
    try {
      isLoading = true;
      notifyListeners();
      if (!userInfoModel.isLogin) {
        RouterUtils.of.pushPathByName('/huawei_login_page');
        return;
      }
      int authorIndex = -1;
      for (int i = 0; i < dataSource.originDataArray.length; i++) {
        if (dataSource.originDataArray[i].authorId == authorId) {
          authorIndex = i;
          break;
        }
      }
      if (isCurrentlyWatching) {
        bool success = authorServiceApi.unfollowAuthor(
            userInfoModel.authorId, authorId,
            fromFollowerPage: false);
        if (success) {
          if (authorIndex != -1 &&
              authorIndex < dataSource.originDataArray.length) {
            dataSource.originDataArray.removeAt(authorIndex);
            notifyListeners();
          }
        }
      } else {
        bool success =
            authorServiceApi.followAuthor(userInfoModel.authorId, authorId);
        if (success) {
          // 显示操作成功提示
        }
      }
      await Future.delayed(const Duration(milliseconds: 200));
      queryWatchList();
    } catch (e) {
      // 显示错误提示
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
        userId = userInfoModel.authorId;
        title = '我的关注';
        queryWatchList();
      } else {
        dataSource.originDataArray.clear();
        notifyListeners();
      }
    });
    userId = userInfoModel.authorId.isNotEmpty ? userInfoModel.authorId : '001';
    title = '我的关注';
    queryWatchList();
  }

  void loadMore() {
    notifyListeners();
  }

  void customBack() {
    RouterUtils.of.popWithResult(result: 'refresh');
  }
}
