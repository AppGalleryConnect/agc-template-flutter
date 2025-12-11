import '../types/types.dart';
import 'package:flutter/material.dart';

/// 我的页面网格列表数据
List<MineGridItem> get mineGridList => [
      const MineGridItemImpl(
        icon: 'packages/business_mine/assets/ic_grid_comment.png',
        label: '评论',
        routerName: '/mine/comment',
      ),
      const MineGridItemImpl(
        icon: 'packages/business_mine/assets/ic_message_active.png',
        label: '消息',
        routerName: '/mine/message',
      ),
      const MineGridItemImpl(
        icon: 'packages/business_mine/assets/ic_grid_star.png',
        label: '收藏',
        routerName: '/mine/mark',
      ),
      const MineGridItemImpl(
        icon: 'packages/business_mine/assets/ic_grid_like.png',
        label: '点赞',
        routerName: '/mine/like',
      ),
    ];

/// 消息菜单列表数据
List<MineMsgMenuItem> get messageMenuList => [
      MineMsgMenuItem(
        type: MineMsgMenuType.Comment,
        menuIcon: 'packages/business_mine/assets/ic_message_comment.png',
        menuTitle: '评论与回复',
        routerName: '/mine/message/comment',
      ),
      MineMsgMenuItem(
        type: MineMsgMenuType.IM,
        menuIcon: 'packages/business_mine/assets/ic_message_im.png',
        menuTitle: '私信',
        routerName: '/mine/message/im',
      ),
      MineMsgMenuItem(
        type: MineMsgMenuType.Fan,
        menuIcon: 'packages/business_mine/assets/ic_message_fans.png',
        menuTitle: '新增粉丝',
        routerName: '/mine/message/fans',
      ),
      MineMsgMenuItem(
        type: MineMsgMenuType.System,
        menuIcon: 'packages/business_mine/assets/ic_message_system.png',
        menuTitle: '系统消息',
        routerName: '/mine/message/system',
      ),
    ];

/// 离线WebID映射表
enum WebIdMap {
  chatWebId('webId1');

  final String id;
  const WebIdMap(this.id);
}

class Constants {
  // 尺寸常量
  static const int newsImageWidth = 96;
  static const int newsImageHeight = 72;
  static const int normalBtnH = 40;
  static const int smallBtnW = 72;
  static const int smallBtnH = 28;
  // 箭头图标大小常量
  static const double arrowIconSize = 20;
  // 未登录用户图标大小常量
  static const double userUnloginIconSize = 38;
  // 用户头像相关尺寸
  static const double avatarRadius = 23;
  static const double avatarTextSize = 18;
  // 文字大小常量
  static const double textPrimarySize = 16;
  static const double textSecondarySize = 12;
  static const double buttonTextSize = 14;
  static const double textHeaderSize = 20;
  static const double textMinSize = 10;
  // 关注按钮相关尺寸
  static const double followButtonWidth = 80;
  static const double followButtonHeight = 32;
  static const double followButtonRadius = 16;

  // 颜色常量
  static const int primaryButtonColorValue = 0xFF5C79D8;
  static const Color primaryButtonColor = Color(primaryButtonColorValue);
  static const Color secondaryButtonColor = Colors.white;
  static const Color textPrimaryColor = Colors.black87;
  static const Color textSecondaryColor = Colors.grey;
  static const Color buttonTextColor = Colors.white;
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color textLightGrayColor = Color(0xFF9E9E9E);
  static const Color textMediumGrayColor = Color(0xFF757575);
  static const Color backgroundLightGrayColor = Color(0xFFF5F5F5);

  // 对话框相关常量
  static const double dialogBorderRadius = 35;
  static const double dialogPadding = 20;
  static const double dialogSpacing = 20;
  static const double dialogCircular = 25.0;
  static const double dialogTextSize = 14;
  static const double dialogButtonTextSize = 16;
  static const double dialogDividerHeight = 30;
  static const FontWeight dialogTitleFontWeight = FontWeight.w500;
  static const FontWeight buttonTextFontWeight = FontWeight.normal;

  // 评论页面相关尺寸常量
  static const double commentEmptyIconSize = 60;
  static const double commentAvatarRadius = 16;
  static const double commentIconSize = 35;
  static const double commentContentPaddingLeft = 44;
  static const double commentToolIconSize = 24;

  // SVG图标路径常量
  static const String icPublicEllipsisCircle =
      'packages/business_mine/assets/ic_public_ellipsis_circle.svg';
  static const String icEmptyContent =
      'packages/lib_widget/assets/ic_empty_content.png';
  static const String icClose = 'packages/business_mine/assets/ic_close.png';
  static const String icPublicTrash =
      'packages/business_mine/assets/ic_public_trash.svg';
  static const String icPublicEraser =
      'packages/business_mine/assets/ic_public_eraser.svg';
  static const String icPublicDelete =
      'packages/business_mine/assets/ic_public_delete.svg';
  // IM消息相关图标路径常量
  static const String icMessageSelect =
      'packages/business_mine/assets/ic_message_select.svg';
  static const String icMessageUnselect =
      'packages/business_mine/assets/ic_message_unselect.svg';
  static const String icMessageDelete =
      'packages/business_mine/assets/ic_message_delete.svg';

  // IM项相关尺寸常量
  static const double imItemLeftWidth = 54;
  static const double imItemLeftHeight = 64;
  static const double imItemSelectIconSize = 18;
  static const double imItemRightWidth = 72;
  static const double imItemRightHeight = 64;
  static const double imItemDeleteIconSize = 40;
  static const double imItemAvatarBorderRadius = 24;

  // IM项相关颜色常量
  static const Color imItemDeleteBgColor = Colors.grey;
  // IM项相关padding常量
  static const double imItemTimeRightPadding = 10;

  // 消息底部操作栏相关尺寸常量
  static const double messageBottomContainerWidth = 156;
  static const double messageBottomContainerHeight = 40;
  static const double messageBottomContainerRadius = 20;
  static const double messageBottomSpacing = 16;
  static const double messageBottomTextSize = 16;

  // 消息底部操作栏相关颜色常量
  static const Color messageBottomSelectAllBgColor = Color(0x0D000000);
  static const Color messageBottomDeleteDisabledColor = Color(0x805C79D9);
  static const Color messageBottomDeleteEnabledColor = Color(0xFF5C79D9);

  // 消息项相关尺寸常量
  static const double messageItemIconSize = 48;
  static const double messageItemIconBorderRadius = 4;
  static const double messageItemVerticalPadding = 16;
  static const double messageItemHorizontalSpacing = 12;
  static const double messageItemTextSpacing = 4;
  static const double messageItemTimeMaxWidth = 80;

  // 消息项相关颜色常量
  static const Color messageItemIconBgColor = Color(0xFFF0F0F0);
  static const Color messageItemTextSecondaryColor = Color(0xFF666666);

  // 文字大小常量
  static const double textTertiarySize = 13;
  static const double textQuaternarySize = 12;

  // 设置已读图标相关常量
  static const double setReadIconSize = 40;
  static const double setReadIconPlaceholderSize = 24;
  static const double setReadIconPlaceholderIconSize = 16;
  static const Color setReadIconPlaceholderColor =
      Color.fromARGB(255, 78, 29, 29);
  static const Duration toastDuration = Duration(seconds: 1);

  // SVG图标路径常量
  static const String icPublicClean =
      'packages/business_mine/assets/ic_public_clean.svg';
  static const String icPublicVideoPlay =
      'packages/business_mine/assets/ic_public_video_play.svg';
  static const String icMessageBatchDelete =
      'packages/business_mine/assets/ic_message_betch_delete.svg';
  static const String icSystemAvatar =
      'packages/business_mine/assets/ic_system_avatar.png';
  static const String icMessageSystem =
      'packages/business_mine/assets/ic_message_system.png';
  // 默认图标路径常量
  static const String defaultIconPath = 'assets/icon_default.png';
  // 未登录用户图标路径常量
  static const String icUserUnlogin =
      'packages/business_mine/assets/ic_user_unlogin.svg';
  static const String icPhone = 'packages/business_mine/assets/ic_phone.svg';
  static const String icRightArrow =
      'packages/business_mine/assets/ic_right.svg';

  // 新闻卡片相关颜色常量
  static const Color newsCardTextPrimaryColor = Colors.black;
  static const int newsCardTextSecondaryColorValue = 0xFF999999;
  static const Color newsCardTextSecondaryColor =
      Color(newsCardTextSecondaryColorValue);
  static const Color newsCardPlaceholderBgColor = Color(0xFFF0F0F0);
  static const Color newsCardPlaceholderIconColor = Color(0xFF9E9E9E);
  static const Color newsCardWhiteColor = Colors.white;
  static const Color newsCardBlackOverlayColor = Colors.black45;

  // 新闻卡片相关尺寸常量
  static const double newsCardBorderRadius = 8.0;
  static const double newsCardVideoIconSize = 40;
  static const double newsCardPlayIconSize = 30;
  static const double newsCardPositionOffset = 4;
}

/// MineGridItem实现类
class MineGridItemImpl implements MineGridItem {
  @override
  final String icon;
  @override
  final String label;
  @override
  final String routerName;

  const MineGridItemImpl({
    required this.icon,
    required this.label,
    required this.routerName,
  });
}

/// 常用表情列表
const List<String> chatEmojis = [
  '😀',
  '😃',
  '😄',
  '😁',
  '😆',
  '😅',
  '😂',
  '🤣',
  '😊',
  '😇',
  '🙂',
  '🙃',
  '😉',
  '😌',
  '😍',
  '🥰',
  '😘',
  '😗',
  '😙',
  '😚',
  '😋',
  '😛',
  '😜',
  '🤪',
  '😝',
  '🤑',
  '🤗',
  '🤭',
  '🤫',
  '🤔',
  '🤐',
  '🤨',
  '😐',
  '😑',
  '😶',
  '😏',
  '😒',
  '🙄',
  '😬',
  '🤥',
  '😌',
  '😔',
  '😪',
  '🤤',
  '😴',
  '😷',
  '🤒',
  '🤕',
  '🤢',
  '🤮',
  '🤧',
  '🥵',
  '🥶',
  '🥴',
  '😵',
  '🤯',
  '🤠',
  '🥳',
  '😎',
  '🤓',
  '🧐',
  '😕',
  '😟',
  '🙁',
];
