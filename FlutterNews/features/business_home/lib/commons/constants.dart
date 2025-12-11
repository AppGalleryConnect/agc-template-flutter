import 'package:flutter/material.dart';

class Constants {
  // 基本信息
  static const String packageName = 'business_home';

  // 间距常量
  static const double spacingXxs = 5.0;
  static const double spacingS = 10.0;
  static const double spacingM = 16.0;
  static const double spacingL = 20.0;
  static const double spacingXl = 30.0;
  static const double spacingXxl = 48.0;

  // 字体大小常量
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeExtraLarge = 24.0;
  static const double fontSizeTiny = 12.0;
  static const double fontSizeTitle = 15.0;

  // 宽高常量
  static const double backButtonWidth = 15.0;
  static const double backButtonHeight = 15.0;
  static const double backButtonContainerSize = 40.0;
  static const double backButtonIconSize = 22.0;
  static const double cameraBackButtonWidth = 60.0;
  static const double cameraBackButtonHeight = 60.0;
  static const double cameraInnerButtonWidth = 48.0;
  static const double cameraInnerButtonHeight = 48.0;
  static const double cameraIconButtonWidth = 40.0;
  static const double cameraIconButtonHeight = 40.0;
  static const double galleryIconSize = 40.0;
  static const double scanAreaScale = 0.7;

  // 左侧文本右侧图片卡片相关宽高
  static const double leftRightCardImageWidth = 96.0;
  static const double leftRightCardImageHeight = 70.0;
  static const double leftRightCardPlayIconSize = 43.0;

  // 顶部文本底部大图卡片相关宽高
  static const double topBottomCardImageHeight = 180.0;
  static const double topBottomCardLoadingIndicatorSize = 24.0;
  static const double topBottomCardLoadingIndicatorStrokeWidth = 2.0;
  static const double topBottomCardErrorIconSize = 48.0;

  // 热榜服务卡片相关
  static const double hotNewsTabContainerHeight = 35.0;
  static const double hotNewsTabButtonHeight = 32.0;
  static const double hotNewsTabSpacing = 4.0;

  // 搜索按钮相关
  static const double searchButtonIconSize = 25.0;
  static const double searchButtonIconWidth = 15.0;
  static const double searchButtonIconHeight = 15.0;
  static const double searchButtonRadius = 20.0;

  // 内边距常量
  static const EdgeInsets backButtonPadding = EdgeInsets.only(
    left: 10,
    top: 5,
    bottom: 5,
  );
  static const EdgeInsets cameraPadding = EdgeInsets.only(bottom: 48.0);
  static const EdgeInsets iconButtonPadding = EdgeInsets.all(12.0);
  static const EdgeInsets searchButtonPadding = EdgeInsets.all(8.0);
  static const EdgeInsets zeroPadding = EdgeInsets.zero;
  static const EdgeInsets hotNewsTabPadding =
      EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  static const EdgeInsets hotNewsTabButtonPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 4);

  // 图片路径常量
  static const String iconBackPath =
      'packages/module_flutter_channeledit/assets/delete.svg';
  static const String galleryIconPath =
      'packages/business_home/assets/image_pic.svg';
  static const String searchIconPath =
      'packages/business_home/assets/ic_search_simple.svg';

  // 颜色常量（RGB格式）
  static const Color backgroundColor = Color.fromARGB(255, 243, 243, 243);
  static const Color cameraOverlayColor = Color.fromARGB(85, 0, 0, 0);
  static const Color whiteColor = Color.fromARGB(255, 255, 255, 255);
  static const Color blackColor = Color.fromARGB(255, 0, 0, 0);
  static const Color blackTransparentColor = Color.fromARGB(51, 0, 0, 0);
  static const Color blackHalfTransparentColor = Color.fromARGB(128, 0, 0, 0);
  static const Color whiteTransparentColor = Color.fromARGB(76, 255, 255, 255);
  static const Color primaryTextColor = Color.fromARGB(255, 0, 0, 0);
  static const Color secondaryTextColor = Color.fromARGB(255, 153, 153, 153);
  static const Color hotNewsTabBackgroundColor =
      Color.fromARGB(255, 230, 230, 230);
  static const Color hotNewsTabTextColor = Color.fromARGB(255, 102, 102, 102);
  static const Color searchButtonBackgroundColor =
      Color.fromARGB(255, 229, 231, 235);
  // 颜色常量（十六进制格式）
  static const Color greenColor = Color(0xFF00FF00);
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color grayColor = Color(0xFF808080);
  static const Color lightGrayColor = Color(0xFFCCCCCC);
  static const Color highlightColor = Color(0xFFE84026);
  static const Color mediumGrayColor = Color(0xFFA0A0A0);
  static const Color lightGrayBackgroundColor = Color(0xFFF0F0F0);
  // 其他常量
  static const double borderRadiusCircle = 24.0;
  static const double borderRadiusButton = 25.0;
  static const double borderWidthThin = 1.0;
  static const double textLineHeight = 1.3;
  static const double hotNewsTabBorderRadius = 20.0;
  static const double hotNewsTabButtonBorderRadius = 16.0;
  static const double hotNewsTabShadowBlurRadius = 3.0;
  static const double hotNewsTabShadowSpreadRadius = 1.0;
  static const Duration hotNewsTabAnimationDuration =
      Duration(milliseconds: 300);

  // 左侧文本右侧图片卡片相关
  static const double leftRightCardImageBorderRadius = 10.0;
  static const double leftRightCardVerticalSpacing = 8.0;
  static const double leftRightCardHorizontalSpacing = 8.0;
  static const double leftRightCardTitleSpacing = 4.0;

  // 顶部文本底部大图卡片相关
  static const double topBottomCardImageBorderRadius = 10.0;
  static const double topBottomCardVerticalSpacing = 8.0;
  static const double topBottomCardHorizontalSpacing = 8.0;
  static const double topBottomCardContentMargin = 16.0;

  // 顶部文本底部图片卡片相关
  static const double topBottomImageCardVerticalSpacing = 8.0;
  static const double topBottomImageCardGridSpacing = 8.0;
  static const double topBottomImageCardGridTopPadding = 10.0;
  static const double topBottomImageCardTitleFontSize = 15.0;
  static const double topBottomImageCardHighlightFontSize = 16.0;

  // 顶部文本底部视频卡片相关
  static const double topBottomVideoCardVerticalSpacing = 8.0;
  static const double topBottomVideoCardTitleFontSize = 16.0;
  static const double topBottomVideoCardHighlightFontSize = 16.0;
  static const double topBottomVideoCardCoverHeight = 200.0;
  static const double topBottomVideoCardPauseIconSize = 44.0;
  static const String topBottomVideoCardPauseIconPath = 'assets/ic_paused.png';

  // 垂直大图片卡片相关
  static const double verticalBigImageCardHeight = 260.0;
  static const double verticalBigImageCardWidth = 180.0;
  static const double verticalBigImageCardBorderRadius = 8.0;
  static const double verticalBigImageCardVerticalSpacing = 8.0;
  static const double verticalBigImageCardHorizontalSpacing = 5.0;
  static const double verticalBigImageCardPlayIconSize = 14.0;
  static const double verticalBigImageCardSubtitleFontSize = 12.0;

  // 文章来源构建器相关
  static const double articleSourceBuilderFontSize = 12.0;
  static const double articleSourceBuilderSpacing = 8.0;
  static const double verticalBigImageCardTitleFontSize = 14.0;

  // 作者卡片相关
  static const double authorCardAvatarRadius = 20.0;
  static const double authorCardHorizontalSpacing = 8.0;
  static const double authorCardVerticalSpacing = 5.0;
  static const double authorCardAvatarPadding = 13.0;
  static const double authorCardRightSpacing = 20.0;
  static const double authorCardAuthorNameFontSize = 15.0;
  static const double authorCardDateFontSize = 12.0;
  static const double authorCardButtonFontSize = 14.0;
  static const double authorCardButtonPaddingHorizontal = 12.0;
  static const double authorCardButtonPaddingVertical = 6.0;
  static const double authorCardButtonBorderRadius = 14.0;
  static const Color authorCardButtonFollowedColor = Color(0xFFE5E5E5);
  static const Color authorCardButtonTextFollowedColor = Color(0xFF5C79D9);
  static const Color authorCardButtonUnfollowedColor = Color(0xFF5C79D9);
  static const String authorCardDefaultAvatarPath =
      'packages/business_mine/assets/ic_user_unlogin.svg';

  // 标签标题
  static const List<String> tabs = ['我的热榜', '今日热搜', '实时资讯'];

  static const customItemCardContainerPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const int customItemCardAdvertisementType = 8;

  // FeedDetail相关常量
  static const double feedDetailBottomPadding = 12.0;
  static const double feedDetailWidth8 = 8.0;
  static const double feedDetailHeight4 = 4.0;
  static const double feedDetailHeight8 = 8.0;
  static const double feedDetailAvatarRadius = 20.0;
  static const double feedDetailButtonBorderRadius = 25.0;
  static const double feedDetailButtonPaddingHorizontal = 12.0;
  static const double feedDetailButtonPaddingVertical = 6.0;
  static const double feedDetailImageGridCrossAxisSpacing = 8.0;
  static const double feedDetailImageGridMainAxisSpacing = 8.0;
  static const double feedDetailSingleColumnAspectRatio = 1.5;
  static const double feedDetailMultiColumnAspectRatio = 1.0;
  static const int feedDetailMaxLines = 3;
  static const double feedDetailTextHeight = 1.3;
  static const double feedDetailIconSize24 = 24.0;

  static const String feedDetailDefaultAvatarPath = "assets/icon_default.png";

  // NewsSearch相关常量
  // 字体大小
  static const double newsSearchTitleFontSize = 18.0;
  static const double newsSearchNormalFontSize = 14.0;
  static const double newsSearchSmallFontSize = 12.0;

  // 宽高
  static const double newsSearchTextFieldHeight = 40.0;
  static const double newsSearchIconSizeSmall = 16.0;
  static const double newsSearchIconSizeMedium = 24.0;
  static const double newsSearchIconSizeLarge = 25.0;
  static const double newsSearchIndexWidth = 20.0;

  // 间距
  static const double newsSearchSpacingXs = 5.0;
  static const double newsSearchSpacingS = 8.0;
  static const double newsSearchSpacingM = 10.0;
  static const double newsSearchSpacingL = 12.0;
  static const double newsSearchSpacingXl = 16.0;
  static const double newsSearchSpacingXxl = 20.0;
  static const double newsSearchHistoryMaxLength = 20.0;
  static const int newsSearchMaxResultsDisplay = 10;
  static const int newsSearchMaxSuggestionsDisplay = 5;

  // 内边距
  static const EdgeInsets newsSearchSectionPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsets newsSearchEmptyHistoryPadding =
      EdgeInsets.only(top: 20.0, bottom: 20.0);
  static const EdgeInsets newsSearchHistoryTagPadding =
      EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);
  static const EdgeInsets newsSearchResultItemPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsets newsSearchTextFieldPadding =
      EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets newsSearchAppBarMargin =
      EdgeInsets.only(top: 8.0, bottom: 8.0, right: 16.0);

  // 边框半径
  static const double newsSearchHistoryTagBorderRadius = 16.0;
  static const double newsSearchTextFieldBorderRadius = 20.0;

  // 颜色
  static const Color newsSearchHighlightColor = Color(0xFF5C79D9);
  static const Color newsSearchHotRankColor = Color(0xFFFF0000);
  static const Color newsSearchHistoryTagBackgroundColor = Color(0xFFF0F0F0);
  static const Color newsSearchHistoryTagTextColor = Color(0xFF404040);
  static const Color newsSearchHistoryLabelColor = Color(0xFF707070);
  static const Color newsSearchTextFieldBackgroundColor = Color(0xFFF5F5F5);
  static const Color newsSearchDividerColor = Color(0xFFF0F0F0);
  static const Color newsSearchTextColorBlack =
      Color(0xFF000000); // Colors.black equivalent
  static const Color newsSearchTextColorWhite =
      Color(0xFFFFFFFF); // Colors.white equivalent
  static const Color newsSearchTextColorGrey =
      Color(0xFF9E9E9E); // Colors.grey equivalent
  static const Color newsSearchTextColorGrey400 =
      Color(0xFFBDBDBD); // Colors.grey[400] equivalent
  static const Color newsSearchTextColorGrey500 =
      Color(0xFF9E9E9E); // Colors.grey[500] equivalent
  static const Color newsSearchTextColorGrey600 =
      Color(0xFF757575); // Colors.grey[600] equivalent
  static const Color newsSearchTextColorGrey800 =
      Color(0xFF424242); // Colors.grey[800] equivalent
  static const Color feedDetailAppThemeColor = Color(0xFF5C79D9);
  static const Color feedDetailTextBlack87 = Color.fromARGB(255, 204, 204, 204);
  static const Color feedDetailColor8C8C8E = Color(0xFF8C8C8E);
  static const Color feedDetailColorF5F5F5 = Color(0xFFF5F5F5);

  // FeedSingleImageSize相关常量
  static const double feedSingleImageBorderRadius = 12.0;
  static const double feedSingleImageTruncatedTextMargin = 8.0;
  static const double feedSingleImageTruncatedTextFontSize = 18.0;
  static const double feedSingleImagePlayButtonWidth = 36.0;
  static const double feedSingleImagePlayButtonHeight = 36.0;
  static const double feedSingleImagePlayIconSize = 24.0;
  static const double feedSingleImageVideoContainerHeight = 200.0;

  // VerticalBigImageItemCard相关常量
  static const double verticalBigImageItemCardHeight = 260.0;
  static const double verticalBigImageItemCardHorizontalPadding = 16.0;
  static const double verticalBigImageItemCardVerticalPadding = 8.0;
  static const double verticalBigImageItemCardSeparatorWidth = 8.0;

  // HomePage相关常量
  // 字体大小
  static const double homePageTitleFontSize = 30.0;
  static const double homePageSubtitleFontSize = 13.0;

  // 宽高
  static const double homePageIconSize = 20.0;
  static const double homePageNoLoginImageSize = 100.0;

  // 内边距和间距
  static const EdgeInsets homePageHeaderPadding =
      EdgeInsets.fromLTRB(16, 0, 16, 0);
  static const EdgeInsets homePageIconButtonPadding = EdgeInsets.all(8.0);

  // 边框半径
  static const double homePageIconButtonBorderRadius = 20.0;

  // 颜色
  static const Color homePageIconButtonBackgroundColor =
      Color(0xFFE0E0E0); // Colors.grey[200] equivalent
  static const Color homePageButtonColor =
      Color(0xFF2196F3); // Colors.blue equivalent
  static const Color homePageButtonTextColor =
      Color(0xFFFFFFFF); // Colors.white equivalent

  // 图片路径
  static const String homePageScanIconPath =
      'packages/business_home/assets/ic_scan.svg';
  static const String homePageNoLoginImagePath =
      'packages/business_home/assets/no_login.png';

  // 底部间距
  static const double homePageBottomPadding = 50.0;
}
