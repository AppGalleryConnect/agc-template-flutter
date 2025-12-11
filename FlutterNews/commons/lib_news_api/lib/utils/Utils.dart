import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lib_account/services/mockdata/protocol_data.dart';
import 'package:lib_account/pages/protocol_web_view.dart';

/// 统一的协议类型枚举
enum ProtocolType {
  userAgreement,
  privacyPolicy,
  thirdPartyInfoList,
  personalInfoCollectionList,
  huaweiUserProtocol,
}

/// 通用方法类
class Utils {
  static List<T> shuffleArray<T>(List<T> array) {
    final List<T> newArray = List<T>.from(array);
    final Random random = Random();
    for (int i = newArray.length - 1; i > 0; i--) {
      final int j = random.nextInt(i + 1);
      final T temp = newArray[i];
      newArray[i] = newArray[j];
      newArray[j] = temp;
    }
    return newArray;
  }

  static int randomRecommendId() {
    final Random random = Random();
    return random.nextInt(12 - 6 + 1) + 6;
  }

  static int randomArticleId() {
    final Random random = Random();
    return random.nextInt(100 - 20 + 1) + 20;
  }

  static void openProtocolPage(BuildContext context, ProtocolType type) {
    String htmlContent;
    switch (type) {
      case ProtocolType.userAgreement:
        htmlContent = ProtocolData.userProtocol;
        break;
      case ProtocolType.privacyPolicy:
        htmlContent = ProtocolData.privacyProtocol;
        break;
      case ProtocolType.thirdPartyInfoList:
        htmlContent = ProtocolData.thirdPartyInfo;
        break;
      case ProtocolType.personalInfoCollectionList:
        htmlContent = ProtocolData.personalInfoCollection;
        break;
      case ProtocolType.huaweiUserProtocol:
        // 注意：这里使用了华为账号用户协议的内容
        htmlContent = ProtocolData.huaweiUserProtocol;
        break;
      default:
        htmlContent = ProtocolData.userProtocol;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProtocolWebView(content: htmlContent),
      ),
    );
  }
}
