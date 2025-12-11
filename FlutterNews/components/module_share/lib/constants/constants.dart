// 需导入之前定义的 ShareKinds 模型（路径根据实际项目结构调整）
import '../model/share_model.dart';

class Constants {
  // 尺寸常量
  static const double SPACE_0 = 0.0;
  static const double SPACE_2 = 2.0;
  static const double SPACE_2_5 = 2.5;
  static const double SPACE_4 = 4.0;
  static const double SPACE_10 = 10.0;
  static const double SPACE_12 = 12.0;
  static const double SPACE_16 = 16.0;
  static const double SPACE_18 = 18.0;
  static const double SPACE_20 = 20.0;
  static const double SPACE_24 = 24.0;
  static const double SPACE_25 = 25.0;
  static const double SPACE_28 = 28.0;
  static const double SPACE_32 = 32.0;
  static const double SPACE_35 = 35.0;
  static const double SPACE_40 = 40.0;
  static const double SPACE_44 = 44.0;
  static const double SPACE_48 = 48.0;
  static const double SPACE_100 = 100.0;
  static const double SPACE_200 = 200.0;
  static const double SPACE_2000 = -2000.0;

  // 字体大小常量
  static const double FONT_10 = 10.0;
  static const double FONT_12 = 12.0;
  static const double FONT_14 = 14.0;
  static const double FONT_16 = 16.0;
  static const double FONT_18 = 18.0;

  static const String shareActiveImage = 'assets/icons/share_active.png';
  static const String testImage = 'assets/test_image.png';
}


/// 二级分享选项列表（对应原 secondShareList，单层级数组）
final List<ShareKinds> secondShareList = [
  ShareKinds(
    id: 'wechat',
    icon: 'app.media.share_wechat', 
    name: '微信',
  ),
  ShareKinds(
    id: 'wechat_feed',
    icon: 'app.media.wechat_feed',
    name: '朋友圈',
  ),
  ShareKinds(
    id: 'qq',
    icon: 'app.media.qq',
    name: 'QQ',
  ),
  ShareKinds(
    id: 'save',
    icon: 'app.media.save',
    name: '保存图片',
  ),
];

/// 一级分享选项列表（对应原 firstShareList，二维数组：按行分组）
final List<List<ShareKinds>> firstShareList = [
  // 第一行分享选项：微信、朋友圈、QQ
  [
    ShareKinds(
      id: 'wechat',
      icon: 'assets/share_wechat.svg',
      name: '微信',
    ),
    ShareKinds(
      id: 'wechat_feed',
      icon: 'assets/wechat_feed.svg',
      name: '朋友圈',
    ),
    ShareKinds(
      id: 'qq',
      icon: 'assets/qq.svg',
      name: 'QQ',
    ),
  ],
  // 第二行分享选项：生成海报、复制链接、系统分享
  [
    ShareKinds(
      id: 'create_poster',
      icon: 'assets/create_poster.png',
      name: '生成海报',
    ),
    ShareKinds(
      id: 'copy_link',
      icon: 'assets/copy_link.png',
      name: '复制链接',
    ),
    ShareKinds(
      id: 'system_share',
      icon: 'assets/system_share.png',
      name: '系统分享',
    ),
  ],
];


