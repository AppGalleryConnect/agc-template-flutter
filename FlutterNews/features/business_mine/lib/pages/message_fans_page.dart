import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import '../components/fan_item.dart';
import 'package:lib_news_api/services/message_service.dart';
import '../viewmodels/message_fans_vm.dart';
import '../utils/font_scale_utils.dart';


class MsgFansPage extends StatefulWidget {
  const MsgFansPage({super.key});

  @override
  _MsgFansPageState createState() => _MsgFansPageState();
}

class _MsgFansPageState extends State<MsgFansPage> {
  final MsgFansViewModel _vm = MsgFansViewModel();
  final WindowModel _windowModel = WindowModel();
  UserInfoModel get userInfoModel => _vm.userInfoModel;
  late VoidCallback _vmListener;

  @override
  void initState() {
    super.initState();
    _vm.userInfoModel.addListener(_onLoginStateChanged);
    _vmListener = () {
      if (mounted) {
        setState(() {});
      }
    };
    _vm.addListener(_vmListener);
    messageServiceApi.setNewFansRead();
  }

  void _onLoginStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _vm.userInfoModel.removeListener(_onLoginStateChanged);
    _vm.removeListener(_vmListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingInfo = SettingModel.getInstance();
    return Scaffold(
      body: Column(
        children: [
          NavHeaderBar(
            title: '新增粉丝',
            showBackBtn: true,
            windowModel: _windowModel,
            onBack: () {
              Navigator.pop(context);
            },
            titleColor: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
            bgColor: ThemeColors.getBackgroundColor(settingInfo.darkSwitch),
            backButtonBackgroundColor:
                ThemeColors.getCompBackgroundSecondary(settingInfo.darkSwitch),
            backButtonPressedBackgroundColor:
                ThemeColors.getCompBackgroundSecondary(settingInfo.darkSwitch),
            customTitleSize: 20 * FontScaleUtils.fontSizeRatio,
          ),
          Expanded(
            child: Container(
              color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
              child: !_vm.userInfoModel.isLogin
                  ? _buildNotLoggedInState()
                  : (_vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _vm.fansList.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: _vm.fansList.length,
                              itemBuilder: (context, index) {
                                final author = _vm.fansList[index];
                                return FanItem(
                                  author: author,
                                );
                              },
                              padding: EdgeInsets.zero,
                              physics: const AlwaysScrollableScrollPhysics(),
                            )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotLoggedInState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text('请先登录查看粉丝信息'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('暂无新增粉丝'),
        ],
      ),
    );
  }
}

Widget msgFansPageBuilder(BuildContext context) {
  return const MsgFansPage();
}
