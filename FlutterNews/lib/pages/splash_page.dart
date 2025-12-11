import 'package:flutter/material.dart';
import '../index_page.dart';
import '../constants/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // todo: 自行调整是否支持开屏广告
  bool isShowAd = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const IndexPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppConstants.icStartBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppConstants.startIconImage,
                  width: AppConstants.SPACE_116,
                  height: AppConstants.SPACE_116,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: AppConstants.SPACE_258),
                const Text(
                  '新闻模板',
                  style: TextStyle(
                    fontSize: AppConstants.FONT_20, 
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textColor, 
                    height: AppConstants.SPACE_1_6,
                  ),
                ),
                const SizedBox(height: AppConstants.SPACE_20),
                const Text(
                  '新闻也是如此精彩',
                  style: TextStyle(
                    fontSize: AppConstants.FONT_16,
                    fontWeight: FontWeight.normal, 
                    color: AppConstants.textColor, 
                    height: AppConstants.SPACE_1_31,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
