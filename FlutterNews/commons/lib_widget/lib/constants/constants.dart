class Constants {
  // Space
  static const int SM_SPACE = 4;
  static const int MD_SPACE = 8;
  static const int LG_SPACE = 12;

  // Percent
  static const String FULL_PERCENT = '100%';

  // Padding
  static const int PADDING_S = 8;
  static const int PADDING_L = 16;
  static const int PADDING_PAGE = 16;

  // 空白图标宽度
  static const int EMPTY_IMG_W = 120;

  // 空内容图片路径
  static const String emptyContentImg =
      'packages/lib_widget/assets/ic_empty_content.png';
}

/// 按钮项接口
base class IButtonItem {
  final String id;
  final String label;

  const IButtonItem({
    required this.id,
    required this.label,
  });
}
