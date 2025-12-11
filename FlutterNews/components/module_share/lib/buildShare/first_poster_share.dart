
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../model/share_model.dart';
import '../views/share.dart';
import 'package:module_share/constants/constants.dart';

class FirstPosterShare extends StatelessWidget {
  final ShareSheetParams params;

  // 分享选项：统一图标和文字，避免布局错位
  final List<ShareOptionTap> shareOptions = [
    ShareOptionTap(
      icon: 'share_wechat.svg', name: '微信',
      onTap: () {} 
    ),
    ShareOptionTap(
      icon: 'wechat_feed.svg', name: '朋友圈',
      onTap: () {}
    ),
    ShareOptionTap(
      icon: 'qq.svg', name: 'QQ',
      onTap: () {} 
    ),
    ShareOptionTap(
      icon: 'create_poster.png', name: '生成海报',
      onTap: () {}
    ),
    ShareOptionTap(
      icon: 'copy_link.png', name: '复制链接',
      onTap: () {} 
    ),
    ShareOptionTap(
      icon: 'system_share.png', name: '系统分享',
      onTap: () {} 
    ),

  ];

  FirstPosterShare({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final gridMaxWidth = screenWidth * 0.5 + Constants.SPACE_100;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft, 
          child: Container(
            width: gridMaxWidth,
            padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16, vertical: Constants.SPACE_16),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 4, 
              crossAxisSpacing: 4,
              childAspectRatio: 0.7,
              padding: EdgeInsets.zero,

              children: shareOptions.map((option) {
                return _buildShareGridItem(option);
              }).toList(),
            ),
          ),
        ),
        _buildCancelButton(context),
      ],
    );
  }

  // 单个分享选项：图标+文字居中对齐，固定尺寸
  Widget _buildShareGridItem(ShareOptionTap option) {
    const double iconContainerSize = Constants.SPACE_44;
    const double textMaxWidth = iconContainerSize + Constants.SPACE_20;

    return GestureDetector(
      onTap: () {
        params.onOptionTap?.call(option.name);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: Constants.SPACE_10),
          Container(
            width: iconContainerSize,
            height: iconContainerSize,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(iconContainerSize / 2),
            ),
            child: option.icon.contains('png')
                ? Image.asset('packages/module_share/assets/${option.icon}',
                    fit: BoxFit.cover)
                : SvgPicture.asset(
                    'packages/module_share/assets/${option.icon}',
                    width: Constants.SPACE_18,
                    height: Constants.SPACE_18,
                    fit: BoxFit.contain,
                  ),
          ),

          const SizedBox(height: Constants.SPACE_4),

          // 文字区域：放宽最大宽度，减少不必要的省略
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: textMaxWidth, 
              minWidth: 0,
            ),
            child: Text(
              option.name,
              style: const TextStyle(
                fontSize: Constants.FONT_12,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // 取消按钮：全屏宽度，带分割线
  Widget _buildCancelButton(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Constants.SPACE_28, left: Constants.SPACE_20, right: Constants.SPACE_20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(Constants.SPACE_25),
            ),
          child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, Constants.SPACE_48), 
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Constants.SPACE_16),
                    bottomRight: Radius.circular(Constants.SPACE_16),
                  ),
                ),
              ),
              child: const Text(
                '取消',
                style: TextStyle(
                  fontSize: Constants.FONT_16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
