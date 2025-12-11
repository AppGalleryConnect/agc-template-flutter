
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../model/share_model.dart';
import 'package:module_share/constants/constants.dart';

class PosterSharePop extends StatelessWidget {
  final bool sharePopShow;
  final ShareOptions qrCodeInfo;
  final Uint8List pixmap;
  final VoidCallback onClose;
  final Function(bool) popClose;

  const PosterSharePop({
    super.key,
    required this.sharePopShow,
    required this.qrCodeInfo,
    required this.pixmap,
    required this.onClose,
    required this.popClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8, 
      padding: const EdgeInsets.all(Constants.SPACE_16),
      margin: const EdgeInsets.symmetric(vertical: Constants.SPACE_24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Constants.SPACE_16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: Constants.SPACE_10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题+关闭按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '海报预览',
                style: TextStyle(
                  fontSize: Constants.FONT_18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: Constants.SPACE_20),
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: Constants.SPACE_16),
          // 海报图片：自适应宽度，保持比例
          Image.memory(
            pixmap,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: Constants.SPACE_200,
                color: Colors.grey[100],
                child: const Center(child: Text('图片加载失败')),
              );
            },
          ),
          const SizedBox(height: Constants.SPACE_16),
          // 提示文字
          const Text(
            '长按图片可保存到相册',
            style: TextStyle(
              fontSize: Constants.FONT_14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

