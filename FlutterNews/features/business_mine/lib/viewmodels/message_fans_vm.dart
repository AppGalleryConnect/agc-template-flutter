import 'package:lib_common/utils/base_view_model.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lib_news_api/services/mine_service.dart';
import 'package:lib_news_api/params/response/author_response.dart';

class MsgFansViewModel extends BaseViewModel {
  // 存储新增粉丝数据
  List<AuthorModel> fansList = [];

  // 加载状态
  bool isLoading = false;

  // 已查看的粉丝ID集合
  Set<String> _viewedFanIds = {};

  MsgFansViewModel() {
    init();
  }

  @override
  void init() {
    super.init();
    // 监听登录状态变化
    userInfoModel.addListener(_onLoginStateChanged);

    loadViewedFanIds();
  }

  // 登录状态变化处理方法
  void _onLoginStateChanged() {

    // 登录状态变化时重新查询数据
    if (userInfoModel.isLogin) {

      queryNewFansList();
    } else {

      fansList = [];
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // 移除监听器，防止内存泄漏
    userInfoModel.removeListener(_onLoginStateChanged);
    super.dispose();
  }

  // 从持久化存储加载已查看的粉丝ID
  Future<void> loadViewedFanIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final viewedIds = prefs.getStringList('viewed_fan_ids') ?? [];
      _viewedFanIds = Set.from(viewedIds);
      // 加载完成后查询新增粉丝
      queryNewFansList();
    } catch (e) {
      _viewedFanIds = {};
      // 即使失败也继续查询
      queryNewFansList();
    }
  }

  // 保存已查看的粉丝ID到持久化存储
  Future<void> saveViewedFanIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('viewed_fan_ids', _viewedFanIds.toList());
    } catch (e) {
    }
  }

  void queryNewFansList() {
    try {
      isLoading = true;
      notifyListeners();

      // 检查是否登录
      if (!userInfoModel.isLogin) {
        fansList = [];
        isLoading = false;
        notifyListeners();
        return;
      }

      final List<AuthorResponse> newFansResponses =
          MineServiceApi.queryNewFans();
      final List<AuthorResponse> filteredNewFans = newFansResponses
          .where((fan) => !_viewedFanIds.contains(fan.authorId))
          .toList();

      // 转换为AuthorModel列表
      fansList = filteredNewFans.map((v) => AuthorModel(v)).toList();

      for (int i = 0; i < fansList.length; i++) {}
    } catch (e) {
      // 清空粉丝列表以显示空状态
      fansList = [];
    } finally {
      isLoading = false;
      // 通知UI更新
      notifyListeners();
    }
  }

  void setAllRead() {
    try {
      // 检查是否登录
      if (!userInfoModel.isLogin) {
        return;
      }

      final List<AuthorResponse> newFansResponses =
          MineServiceApi.queryNewFans();

      for (var fan in newFansResponses) {
        _viewedFanIds.add(fan.authorId);
      }
      // 保存到持久化存储
      saveViewedFanIds();
      // 清空新增粉丝列表
      fansList = [];
      notifyListeners();
    } catch (e) {
    }
  }

  // 标记单个粉丝为已读
  void markFanAsRead(String fanId) {
    try {
      // 检查是否登录
      if (!userInfoModel.isLogin) {
        return;
      }

      _viewedFanIds.add(fanId);

      saveViewedFanIds();

      // 从列表中移除
      fansList.removeWhere((fan) => fan.authorId == fanId);
      notifyListeners();
    } catch (e) {
    }
  }
}
