import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // todo: 自行调整是否支持开屏广告
  bool isShowAd = true;

  @override
  void initState() {
    super.initState();
    SplashUtils.initRouterLis(context);
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        final prefs = await SharedPreferences.getInstance();
        final isAgreed = prefs.getBool('isAgreedPrivacyPolicy') ?? false;
        if (isAgreed) {
          Navigator.pushReplacementNamed(context, RouterMap.INDEX_PAGE);
        } else {
          Navigator.pushReplacementNamed(context, RouterMap.SAFE_PAGE);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingInfo = SettingModel.getInstance();
    return Scaffold(
      backgroundColor: ThemeColors.getBackgroundColor(settingInfo.darkSwitch),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: settingInfo.darkSwitch
                  ? Colors.black
                  : const Color(0xFF6180DC),
              image: DecorationImage(
                image: AssetImage(settingInfo.darkSwitch
                    ? AppConstants.icStartBackgroundImageDark
                    : AppConstants.icStartBackgroundImageLight),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
