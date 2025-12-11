import 'package:flutter/material.dart';
import 'package:module_newsfeed/constants/constants.dart';

class NewsWithQRCode extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String sourceAndTime;
  final String qrCodeUrl;
  final Image? qrCodeImage; 

  static const double _fixedTotalHeight = Constants.SPACE_360;

  const NewsWithQRCode({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.sourceAndTime,
    required this.qrCodeUrl,
    this.qrCodeImage,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = screenWidth * 0.85; 

    return Container(
      height: _fixedTotalHeight,
      width: maxContentWidth,
      constraints: const BoxConstraints(
        minWidth: 280,
        maxWidth: 500,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Constants.SPACE_8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(Constants.SPACE_12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 新闻图片
          _buildNewsImage(maxContentWidth),
          const SizedBox(height: Constants.SPACE_8),

          // 2. 新闻标题
          _buildTitle(),
          const SizedBox(height: Constants.SPACE_4),

          // 3. 来源与时间
          _buildSourceAndTime(),
          const SizedBox(height: Constants.SPACE_8),

          // 4. 二维码区域
          _buildQrCodeArea(),
        ],
      ),
    );
  }

  Widget _buildNewsImage(double maxWidth) {
    return Expanded(
      flex: 45,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Constants.SPACE_4),
        child: Image.network(
          imageUrl,
          width: maxWidth,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: Constants.SPACE_2,
                  valueColor: AlwaysStoppedAnimation(Colors.grey),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: Constants.SPACE_32,
              ),
            );
          },
        ),
      ),
    );
  }

  // 新闻标题：优化文本溢出和行高
  Widget _buildTitle() {
    return Expanded(
      flex: 20,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: Constants.FONT_16,
          fontWeight: FontWeight.w500,
          height: 1.2, 
        ),
        softWrap: true,
        maxLines: 3,
        overflow: TextOverflow.ellipsis, 
      ),
    );
  }

  // 来源与时间：固定样式
  Widget _buildSourceAndTime() {
    return Expanded(
      flex: 8,
      child: Text(
        sourceAndTime,
        style: const TextStyle(
          fontSize: Constants.FONT_12,
          color: Colors.grey,
          height: 1.2,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // 二维码区域：优先显示本地二维码，其次网络加载
  Widget _buildQrCodeArea() {
    return Expanded(
      flex: 22,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 二维码容器
          Container(
            width: Constants.SPACE_60,
            height: Constants.SPACE_60,
            padding: const EdgeInsets.all(Constants.SPACE_2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.SPACE_4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: Constants.SPACE_2,
                  offset: const Offset(0, 1),
                )
              ],
            ),
            child: _buildQrImage(),
          ),
          const SizedBox(width: Constants.SPACE_6),
          // 提示文字
          const Expanded(
            child: Text(
              '长按二维码查看详情',
              style: TextStyle(
                fontSize: Constants.FONT_12,
                color: Colors.grey,
                height: 1.3,
              ),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 二维码图片：优先本地生成，其次网络加载
  Widget _buildQrImage() {
    if (qrCodeImage != null) {
      return qrCodeImage!; 
    } else {
      return Image.network(
        qrCodeUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[100],
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: Constants.SPACE_1_5,
                valueColor: AlwaysStoppedAnimation(Colors.grey),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[100],
            child: const Icon(
              Icons.qr_code,
              color: Colors.grey,
              size: Constants.SPACE_24,
            ),
          );
        },
      );
    }
  }
}