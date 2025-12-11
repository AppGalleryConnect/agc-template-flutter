import 'package:business_interaction/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_account/utils/login_sheet_utils.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/lib_widget.dart';
import 'package:lib_account/viewmodels/login_vm.dart' as login_vm;
import '../constants/constants.dart';
import '../components/top_bar.dart';
import '../components/inter_action_tab_content.dart';
import '../viewmodels/interaction_view_model.dart';

/// 互动页面
class InteractionPage extends StatefulWidget {
  const InteractionPage({super.key});

  @override
  State<InteractionPage> createState() => _InteractionPageState();
}

class _InteractionPageState extends BaseStatefulWidgetState<InteractionPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver, RouteAware {
  /// 用于存储所有标签页的 ViewModel 引用
  final Map<int, InteractionViewModel> _tabViewModels = {};

  /// 当前选中的标签页ID
  int selectedId = 0;

  /// 目标标签页索引
  int targetIndex = 0;

  /// WindowModel 实例
  final WindowModel windowModel = WindowModel();

  /// PageController
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    // 添加应用生命周期监听
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 注册路由观察者（用于监听页面显示/隐藏）
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      interactionPageRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    interactionPageRouteObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();
    super.dispose();
  }

  /// 路由观察者回调：页面显示时（类似 iOS viewWillAppear）
  @override
  void didPush() {
    _refreshCurrentTab();
  }

  /// 路由观察者回调：页面返回显示时（类似 iOS viewWillAppear）
  @override
  void didPopNext() {
    _updateCurrentTabStates();
  }

  /// 更新当前标签页的状态（保持数据顺序）
  void _updateCurrentTabStates() {
    if (!mounted) return;

    final currentTabViewModel = _tabViewModels[selectedId];
    if (currentTabViewModel != null) {
      currentTabViewModel.updateStates();
    }
  }

  /// 应用生命周期回调：应用从后台恢复时
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshCurrentTab();
    }
  }

  /// 刷新当前标签页的数据
  void _refreshCurrentTab() {
    if (!mounted) return;

    final currentTabViewModel = _tabViewModels[selectedId];
    if (currentTabViewModel != null) {
      currentTabViewModel.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.getInteractionGradient(settingInfo.darkSwitch),
        ),
        child: _buildMainContent(),
      ),
    );
  }

  Widget _buildMainContent() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          NavHeaderBar(
            title: '互动',
            isSubTitle: false,
            bgColor: Colors.transparent,
            titleColor: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
            windowModel: windowModel,
            leftPadding: Constants.SPACE_20,
            rightPadding: Constants.SPACE_20,
            topPadding: statusBarHeight + Constants.SPACE_10,
            rightPartBuilder: (context) => _buildRightHeadPart(),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.SPACE_16,
            ),
            child: IntrinsicHeight(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TopBar(
                  selectedId: selectedId,
                  fontSizeRatio: settingInfo.fontSizeRatio,
                  onClickBar: (id) {
                    setState(() {
                      selectedId = id;
                      targetIndex =
                          TAB_LIST.indexWhere((item) => item.id == id);
                    });
                    pageController.animateToPage(
                      targetIndex,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedId = TAB_LIST[index].id;
                  targetIndex = index;
                });
              },
              children: TAB_LIST.map((v) {
                return InterActionTabContent(
                  resource: v,
                  onViewModelReady: (viewModel) {
                    _tabViewModels[v.id] = viewModel;
                  },
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + Constants.SPACE_50,
          ),
        ],
      ),
    );
  }

  /// 构建右侧头部区域
  Widget _buildRightHeadPart() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () async {
            RouterUtils.of.push(RouterMap.NEWS_SEARCH_PAGE);
          },
          child: Container(
            padding: const EdgeInsets.all(Constants.SPACE_10),
            decoration: BoxDecoration(
              color: ThemeColors.getBackgroundTertiary(settingInfo.darkSwitch),
              borderRadius: BorderRadius.circular(Constants.SPACE_20),
            ),
            child: SvgPicture.asset(
              Assets.assetsIcSearchSimple,
              package: Constants.packageName,
              width: Constants.SPACE_20,
              height: Constants.SPACE_20,
              colorFilter: ColorFilter.mode(
                ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: Constants.SPACE_8),
        GestureDetector(
          onTap: () {
            final loginVM = login_vm.LoginVM.getInstance();
            if (!loginVM.accountInstance.userInfoModel.isLogin) {
              LoginSheetUtils.showLoginSheet(context);
              return;
            }
            RouterUtils.of.push(
              RouterMap.PUBLISH_POST_PAGE,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(Constants.SPACE_10),
            decoration: BoxDecoration(
              color: ThemeColors.getBackgroundTertiary(settingInfo.darkSwitch),
              borderRadius: BorderRadius.circular(Constants.SPACE_20),
            ),
            child: SvgPicture.asset(
              Assets.assetsIcPlusSimple,
              package: Constants.packageName,
              width: Constants.SPACE_20,
              height: Constants.SPACE_20,
              colorFilter: ColorFilter.mode(
                ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 全局路由观察者（用于监听页面显示/隐藏，实现类似 iOS viewWillAppear 的功能）
final RouteObserver<PageRoute> interactionPageRouteObserver =
    RouteObserver<PageRoute>();
