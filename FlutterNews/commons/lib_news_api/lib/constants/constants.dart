/// 新闻类型
enum NewsEnum {
  /// 文章
  article,

  /// 视频
  video,

  /// 动态
  post,
}

/// 视频类型
enum VideoEnum {
  /// 竖屏
  portrait,

  /// 横屏
  landscape,
}

/// 聊天内容枚举
enum ChatEnum {
  /// 文本
  text,

  /// 图片
  image,

  /// 时间
  time,
}

enum NewsCardType {
  hotNewsServiceCard,
  topTextBottomImageCard,
  leftTextRightImageCard,
  topTextBottomBigImageCard,
  verticalBigImageCard,
  topTextBottomVideoCard,
  advertisementCard,
  feedDetailsCard,
  hotListServiceSwitchCard,
  unknown,
}
