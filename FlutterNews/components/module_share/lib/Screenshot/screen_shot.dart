import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../model/share_model.dart';
import 'package:module_share/constants/constants.dart';

class Screenshot extends StatelessWidget {
  final ShareOptions qrCodeInfo;
  final Function(bool, Uint8List) onPost;

  const Screenshot({
    super.key,
    required this.qrCodeInfo,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    // 模拟截图：组件构建后触发
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _simulateScreenshot();
    });
    return const SizedBox.shrink();
  }

  Future<void> _simulateScreenshot() async {
    try {
      final data = await rootBundle.load(Constants.testImage);
      final bytes = data.buffer.asUint8List();
      onPost(true, bytes);
    } catch (e) {
      onPost(false, Uint8List(0));
    }
  }
}