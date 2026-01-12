import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafePageVM extends ChangeNotifier {
  Future<void> agreeBtnClick(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAgreedPrivacyPolicy', true);
    Navigator.pushReplacementNamed(context, RouterMap.INDEX_PAGE);
  }

  void cancelBtnClick(BuildContext context) {
    exit(0);
  }

  void privacyClick(BuildContext context) {
    Navigator.pushNamed(context, RouterMap.PRIVACY_PAGE);
  }
}
