import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:module_imagepreview/advanced_customImage_viewer.dart';
import '../common/constants.dart';
import '../viewmodels/personal_home_vm.dart';
import '../components/user_intro.dart';
import '../components/uniform_news.dart';
import 'package:lib_news_api/observedmodels/author_model.dart';
import '../common/news_data_source.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/params/base/base_model.dart'; // 导入 PostImgList
import 'package:lib_widget/components/custom_image.dart';
import 'package:lib_common/utils/pop_view_utils.dart';
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:lib_common/models/window_model.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:lib_account/lib_account.dart';
import 'package:lib_account/viewmodels/login_vm.dart' as login_vm;
import 'package:module_share/utils/event_dispatcher.dart';
import 'package:lib_news_api/observedmodels/news_model.dart';
import 'package:business_mine/utils/content_navigation_utils.dart';
import 'package:lib_news_api/services/mine_service.dart';
import 'package:business_video/models/video_model.dart';
import 'package:module_newsfeed/components/news_detail_page.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';

class PersonalHomePage extends StatefulWidget {
  final String userId;

  const PersonalHomePage({super.key, required this.userId});

  @override
  State<PersonalHomePage> createState() => _PersonalHomePageState();
}

class _PersonalHomePageState extends State<PersonalHomePage> {
  late PersonalPageViewModel vm;
  late ScrollController _scrollController;
  bool _isAppBarTitleVisible = false;
  bool _isTabBarSticky = false;
  bool _isPopViewInitialized = false;
  final Map<String, bool> _expandedStates = {};
  final List<TabItem> _tabList = tabList;

  @override
  void initState() {
    super.initState();
    vm = PersonalPageViewModel();
    vm.userId = widget.userId;
    vm.init();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      setState(() {
        _isAppBarTitleVisible = offset > Constants.APP_BAR_TITLE_VISIBLE_OFFSET;
        _isTabBarSticky = offset > Constants.TAB_BAR_STICKY_OFFSET;
      });
    });
  }

  // 私信
  void _handleMessagePress() {
    if (!vm.userInfoModel.isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先登录')),
      );
      return;
    }

    if (isMyself) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('不能给自己发私信')),
      );
      return;
    }

    RouterUtils.of.pushPathByName(
      RouterMap.MINE_MSG_IM_CHAT_PAGE,
      param: vm.userInfo,
    );
  }

  void _handleEditPress() {
    RouterUtils.of.pushPathByName(
      RouterMap.SETTING_PERSONAL,
      onPop: (result) {
        if (isMyself) {
          vm.queryAuthorInfo();
          setState(() {});
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isPopViewInitialized) {
      PopViewUtils.instance.init(context);
      _isPopViewInitialized = true;
    }
  }

  bool get isMyself {
    bool isSameUser = vm.userInfoModel.authorId == vm.userInfo?.authorId;
    bool isDefaultUser =
        vm.userInfo?.authorId == '001' && vm.userInfoModel.authorId.isEmpty;
    return isSameUser || isDefaultUser;
  }

  @override
  Widget build(BuildContext context) {
    final windowModel = WindowModel();
    return Scaffold(
      backgroundColor: Constants.PAGE_BACKGROUND_COLOR,
      body: Column(
        children: [
          NavHeaderBar(
            title: _isAppBarTitleVisible
                ? (vm.userInfo?.authorNickName ?? '')
                : '',
            showBackBtn: true,
            windowModel: windowModel,
            onBack: () => Navigator.pop(context),
            backButtonBackgroundColor: Constants.BACK_BUTTON_BACKGROUND_COLOR,
            backButtonPressedBackgroundColor:
                Constants.BACK_BUTTON_PRESSED_COLOR,
            leftPadding: Constants.LEFT_PADDING,
            // 私信
            rightPartBuilder: (context) {
              return !isMyself && vm.userInfo != null
                  ? GestureDetector(
                      onTap: _handleMessagePress,
                      child: Container(
                        width: Constants.MESSAGE_BUTTON_SIZE,
                        height: Constants.MESSAGE_BUTTON_SIZE,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Constants.BACK_BUTTON_BACKGROUND_COLOR,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.mail_outline,
                          size: Constants.MESSAGE_ICON_SIZE,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    )
                  : const SizedBox(width: Constants.MESSAGE_BUTTON_SIZE);
            },
          ),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // 用户信息部分
                      if (vm.userInfo != null)
                        UserIntro(
                          userInfo: AuthorModel(vm.userInfo!),
                          fontSizeRatio: vm.settingInfo.fontSizeRatio,
                          refreshProfileHomePage: () => vm.queryAuthorInfo(),
                          mineInfo: vm.userInfoModel,
                          onEditPress: _handleEditPress,
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(
                              CommonConstants.PADDING_PAGE),
                          alignment: Alignment.center,
                          child: const Text('加载用户信息中...'),
                        ),
                      const SizedBox(height: CommonConstants.SPACE_XXL),
                      // 下方：文章/视频/动态区域
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                                Constants.CONTENT_BORDER_RADIUS),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: Constants.CONTENT_SHADOW_BLUR_RADIUS,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // 文章/视频/动态选项卡
                            Container(
                              padding: const EdgeInsets.all(
                                  CommonConstants.PADDING_PAGE),
                              child: buildTabBar(),
                            ),

                            // 内容区域
                            Container(
                              constraints: const BoxConstraints(
                                minHeight: Constants.MIN_CONTENT_HEIGHT,
                              ),
                              child: contentBuilder(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 吸顶的选项卡
                if (_isTabBarSticky)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: Constants.TAB_BAR_HEIGHT,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: Constants.TAB_BAR_SHADOW_BLUR_RADIUS,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: CommonConstants.PADDING_PAGE,
                          vertical: 0),
                      child: buildTabBar(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contentBuilder() {
    // 根据不同类型展示不同内容
    Widget content;
    if (vm.curIndex == 0) {
      content = buildArticleContent();
    } else if (vm.curIndex == 1) {
      content = buildVideoContent();
    } else {
      content = buildPostContent();
    }

    // 为所有内容添加左右内边距
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CommonConstants.PADDING_PAGE,
      ),
      child: content,
    );
  }

  Widget buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _tabList.map((tab) {
        bool isSelected = vm.curIndex == tab.id;
        return GestureDetector(
          onTap: () {
            setState(() {
              vm.curIndex = tab.id;
              if (tab.id == 0) {
                vm.queryArticleList();
              } else if (tab.id == 1) {
                vm.queryVideoList();
              } else {
                vm.queryPostList();
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.TAB_BUTTON_PADDING_HORIZONTAL,
                vertical: Constants.TAB_BUTTON_PADDING_VERTICAL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tab.label,
                  style: TextStyle(
                    fontSize: isSelected
                        ? Constants.SELECTED_FONT_SIZE
                        : Constants.UNSELECTED_FONT_SIZE,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(
                        top: Constants.TAB_INDICATOR_MARGIN_TOP),
                    width: Constants.TAB_INDICATOR_WIDTH,
                    height: Constants.TAB_INDICATOR_HEIGHT,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(
                          Constants.TAB_INDICATOR_BORDER_RADIUS)),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildArticleContent() {
    final currentDataSource =
        vm.dataSource[vm.curIndex] as LayoutNewsDataSource;
    if (currentDataSource.originDataArray.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(
            vertical: Constants.EMPTY_CONTENT_PADDING),
        alignment: Alignment.center,
        child: const Text('暂无内容'),
      );
    }

    List<NewsResponse> allNews = [];
    for (var requestListData in currentDataSource.originDataArray) {
      allNews.addAll(requestListData.articles);
    }
    return Column(
      children: allNews
          .map((news) => Padding(
                padding: const EdgeInsets.only(bottom: CommonConstants.SPACE_M),
                child: UniformNews(
                  newsInfo: news,
                  fontSizeRatio: vm.settingInfo.fontSizeRatio,
                ),
              ))
          .toList(),
    );
  }

  Widget buildVideoContent() {
    final currentDataSource = vm.dataSource[1] as LayoutNewsDataSource;
    if (currentDataSource.originDataArray.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(
            vertical: Constants.EMPTY_CONTENT_PADDING),
        alignment: Alignment.center,
        child: const Text('暂无视频'),
      );
    }

    List<NewsResponse> allVideos = [];
    for (var requestListData in currentDataSource.originDataArray) {
      allVideos.addAll(requestListData.articles);
    }
    return Column(
      children: allVideos
          .map((video) => Padding(
                padding: const EdgeInsets.only(bottom: CommonConstants.SPACE_M),
                child: UniformNews(
                  newsInfo: video,
                  fontSizeRatio: vm.settingInfo.fontSizeRatio,
                ),
              ))
          .toList(),
    );
  }

  Widget buildPostContent() {
    final currentDataSource = vm.dataSource[2] as LayoutNewsDataSource;
    if (currentDataSource.originDataArray.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(
            vertical: Constants.EMPTY_CONTENT_PADDING),
        alignment: Alignment.center,
        child: const Text('暂无动态'),
      );
    }

    List<NewsResponse> allPosts = [];
    for (var requestListData in currentDataSource.originDataArray) {
      allPosts.addAll(requestListData.articles);
    }

    return Column(
      children: allPosts
          .map((post) => GestureDetector(
                onTap: () {
                  final NewsModel newsModel = NewsModel.fromNewsResponse(post);
                  ContentNavigationUtils.navigateToDetailFromAnySource(
                      newsModel,
                      source: 'profile');
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: CommonConstants.SPACE_XXL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildExpandableContent(context, post.title, post.id,
                          vm.settingInfo.fontSizeRatio),
                      const SizedBox(height: CommonConstants.SPACE_S),
                      if (post.postImgList != null &&
                          post.postImgList!.isNotEmpty)
                        buildImageGrid(context, post.postImgList!, post),
                      Container(
                        margin: const EdgeInsets.only(
                            bottom: CommonConstants.SPACE_S),
                      ),
                      const SizedBox(height: CommonConstants.SPACE_S),
                      Text(
                        TimeUtils.getDateDiff(post.createTime),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize ??
                                  12.0,
                          color: Theme.of(context).textTheme.bodySmall?.color ??
                              const Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Size _calculateImageSize(String imageUrl) {
    if (imageUrl.startsWith('file://') || imageUrl.startsWith('/')) {
      if (_isVideoUrl(imageUrl)) {
        double width = Constants.IMAGE_WIDTH_SMALL;
        double height = width / Constants.IMAGE_ASPECT_RATIO_PORTRAIT;
        return Size(width, height);
      } else {
        return const Size(
            Constants.IMAGE_WIDTH_MEDIUM, Constants.IMAGE_HEIGHT_VERTICAL);
      }
    }

    final widthMatch = RegExp(r'w=(\d+)').firstMatch(imageUrl);
    final heightMatch = RegExp(r'h=(\d+)').firstMatch(imageUrl);

    double originalWidth = 0;
    double originalHeight = 0;

    if (widthMatch != null) {
      originalWidth = double.tryParse(widthMatch.group(1) ?? '0') ?? 0;
    }
    if (heightMatch != null) {
      originalHeight = double.tryParse(heightMatch.group(1) ?? '0') ?? 0;
    }

    double aspectRatio = Constants.IMAGE_ASPECT_RATIO_SQUARE;
    if (originalHeight > 0 && originalWidth > 0) {
      aspectRatio = originalWidth / originalHeight;
    }

    double width;
    double height;

    if (aspectRatio < 1) {
      width = Constants.IMAGE_WIDTH_SMALL;
      height = width / Constants.IMAGE_ASPECT_RATIO_PORTRAIT;
    } else if (aspectRatio == 1) {
      width = Constants.IMAGE_WIDTH_MEDIUM;
      height = Constants.IMAGE_HEIGHT_VERTICAL;
    } else if (aspectRatio > 1) {
      width = Constants.IMAGE_WIDTH_LARGE;
      height = Constants.IMAGE_HEIGHT_HORIZONTAL;
    } else {
      if (_isVideoUrl(imageUrl)) {
        width = Constants.IMAGE_WIDTH_MEDIUM;
        height = Constants.IMAGE_HEIGHT_VIDEO;
      } else {
        width = Constants.IMAGE_WIDTH_MEDIUM;
        height = Constants.IMAGE_HEIGHT_VERTICAL;
      }
    }

    return Size(width, height);
  }

  Widget buildImageGrid(
      BuildContext context, List<PostImgList> imgList, NewsResponse post) {
    if (imgList.isEmpty) return const SizedBox.shrink();
    final imageUrls = <String>[];
    final videos = <PostImgList>[];
    final isVideoList = <bool>[];
    String normalizeFilePath(String path) {
      if (path.startsWith('file://') && !path.startsWith('file:///')) {
        return 'file:///${path.substring(7)}';
      }
      return path;
    }

    for (final media in imgList) {
      try {
        String? surfaceUrl = media.surfaceUrl;
        String? picVideoUrl = media.picVideoUrl;
        if (surfaceUrl.isNotEmpty) {
          videos.add(media);
          imageUrls.add(normalizeFilePath(surfaceUrl));
          isVideoList.add(true);
        } else if (picVideoUrl.isNotEmpty) {
          imageUrls.add(normalizeFilePath(picVideoUrl));
          final isVideo = _isVideoUrl(picVideoUrl);
          isVideoList.add(isVideo);
          if (isVideo) {
            videos.add(media);
          }
        }
      } catch (e) {
        debugPrint('Error processing media: $e');
      }
    }

    final displayUrls =
        imageUrls.length > 9 ? imageUrls.sublist(0, 9) : imageUrls;
    final displayIsVideo =
        isVideoList.length > 9 ? isVideoList.sublist(0, 9) : isVideoList;
    if (displayUrls.length == 1) {
      final imageSize = _calculateImageSize(displayUrls[0]);
      final isVideo = displayIsVideo.isNotEmpty && displayIsVideo[0];

      return GestureDetector(
        onTap: () {
          if (isVideo) {
            _actionToNewsDetails(context, post);
          } else {
            _showImageViewer(context, displayUrls, 0, post.id);
          }
        },
        child: Hero(
          tag: 'image_${post.id}_${post.id.hashCode}_0',
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImage(
                imageUrl: displayUrls[0],
                width: imageSize.width,
                height: imageSize.height,
                fit: BoxFit.cover,
                borderRadius:
                    BorderRadius.circular(Constants.IMAGE_BORDER_RADIUS_MEDIUM),
              ),
              if (isVideo)
                Container(
                  width: Constants.VIDEO_PLAY_BUTTON_SIZE_LARGE,
                  height: Constants.VIDEO_PLAY_BUTTON_SIZE_LARGE,
                  decoration: const BoxDecoration(
                    color: Constants.VIDEO_PLAY_BUTTON_BACKGROUND_COLOR,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: Constants.VIDEO_PLAY_ICON_SIZE_LARGE,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final int crossAxisCount = displayUrls.length == 4
        ? Constants.GRID_CROSS_AXIS_COUNT_2.toInt()
        : Constants.GRID_CROSS_AXIS_COUNT_3.toInt();
    final double imageSize = (MediaQuery.of(context).size.width -
            Constants.IMAGE_GRID_CONTAINER_PADDING -
            (crossAxisCount - 1) * Constants.IMAGE_GRID_SPACING) /
        crossAxisCount;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: Constants.IMAGE_GRID_SPACING,
        mainAxisSpacing: Constants.IMAGE_GRID_SPACING,
        childAspectRatio: Constants.IMAGE_ASPECT_RATIO_SQUARE,
      ),
      itemCount: displayUrls.length,
      itemBuilder: (context, index) {
        final isVideo = displayIsVideo.isNotEmpty && displayIsVideo[index];
        double itemWidth = imageSize;
        double itemHeight = imageSize;
        if (isVideo) {
          itemHeight = itemWidth / Constants.IMAGE_ASPECT_RATIO_PORTRAIT;
        }
        return GestureDetector(
          onTap: () {
            if (isVideo) {
              _actionToNewsDetails(context, post);
            } else {
              _showImageViewer(context, displayUrls, index, post.id);
            }
          },
          child: Hero(
            tag: 'image_${post.id}_${post.id.hashCode}_$index',
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImage(
                  imageUrl: displayUrls[index],
                  width: itemWidth,
                  height: itemHeight,
                  fit: isVideo ? BoxFit.cover : BoxFit.cover,
                  borderRadius: BorderRadius.circular(
                      Constants.IMAGE_BORDER_RADIUS_SMALL),
                ),
                if (isVideo)
                  Container(
                    width: Constants.VIDEO_PLAY_BUTTON_SIZE_SMALL,
                    height: Constants.VIDEO_PLAY_BUTTON_SIZE_SMALL,
                    decoration: const BoxDecoration(
                      color: Constants.VIDEO_PLAY_BUTTON_BACKGROUND_COLOR,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: Constants.VIDEO_PLAY_ICON_SIZE_SMALL,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isVideoUrl(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.flv', '.wmv', '.mkv'];
    final lowerUrl = url.toLowerCase();
    return videoExtensions.any(lowerUrl.contains);
  }

  void _actionToNewsDetails(BuildContext context, NewsResponse post) {
    if (post.id.isNotEmpty) {
      try {
        MineServiceApi.addToHistory(post.id);
      } catch (e) {
        debugPrint('Error adding to history: $e');
      }
    }

    bool hasVideo = false;
    try {
      if (post.postImgList != null && post.postImgList!.isNotEmpty) {
        hasVideo = post.postImgList!.any((media) {
          try {
            return (media.surfaceUrl.isNotEmpty) ||
                (_isVideoUrl(media.picVideoUrl));
          } catch (e) {
            return false;
          }
        });
      }
    } catch (e) {
      debugPrint('Error checking video type: $e');
      hasVideo = false;
    }

    try {
      if (hasVideo) {
        final videoData = VideoNewsData.fromCommentResponse(post);
        RouterUtils.of.pushPathByName(
          RouterMap.VIDEO_PLAY_PAGE,
          param: videoData,
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              news: post,
              fontSizeRatio: FontScaleUtils.fontSizeRatio,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error navigating to detail page: $e');
    }
  }

  // 构建可展开的内容
  Widget buildExpandableContent(BuildContext context, String content,
      String postId, double fontSizeRatio) {
    const maxLines = Constants.MAX_TEXT_LINES;
    _expandedStates.putIfAbsent(postId, () => false);
    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = TextStyle(
          fontSize: 16 * fontSizeRatio,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.bodyLarge?.color ??
              Constants.PRIMARY_TEXT_COLOR,
          height: Constants.TEXT_HEIGHT_FACTOR,
        );
        if (_expandedStates[postId]!) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content, style: textStyle),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => setState(() => _expandedStates[postId] = false),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: Constants.EXPAND_BUTTON_PADDING_TOP),
                  child: Text(
                    '收起',
                    style: TextStyle(
                      fontSize:
                          Constants.EXPAND_BUTTON_FONT_SIZE * fontSizeRatio,
                      color: Constants.LINK_TEXT_COLOR,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        final fullTextPainter = TextPainter(
          text: TextSpan(text: content, style: textStyle),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);
        if (!fullTextPainter.didExceedMaxLines) {
          return Text(content, style: textStyle);
        }
        int left = 0;
        int right = content.length;
        String clippedText = '';
        while (left < right) {
          int mid = (left + right + 1) ~/ 2;
          final testText = content.substring(0, mid);
          final testPainter = TextPainter(
            text: TextSpan(
              style: textStyle,
              children: [
                TextSpan(text: testText),
                TextSpan(
                  text: '...全文',
                  style: textStyle.copyWith(color: Constants.LINK_TEXT_COLOR),
                ),
              ],
            ),
            maxLines: maxLines,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);
          if (testPainter.didExceedMaxLines) {
            right = mid - 1;
          } else {
            clippedText = testText;
            left = mid;
          }
        }
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => setState(() => _expandedStates[postId] = true),
          child: Text.rich(
            TextSpan(
              style: textStyle,
              children: [
                TextSpan(text: clippedText),
                TextSpan(
                  text: '...全文',
                  style: textStyle.copyWith(
                    color: const Color(0xFF5C79D9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 显示图片查看器
  void _showImageViewer(BuildContext context, List<String> imageUrls,
      int initialIndex, String postId) {
    if (imageUrls.isEmpty ||
        initialIndex < 0 ||
        initialIndex >= imageUrls.length) {
      debugPrint('Invalid parameters for image viewer');
      return;
    }

    NewsResponse? correspondingNews;
    final currentDataSource = vm.dataSource[2] as LayoutNewsDataSource;
    for (var requestListData in currentDataSource.originDataArray) {
      for (var news in requestListData.articles) {
        if (news.id == postId) {
          correspondingNews = news;
          break;
        }
      }
      if (correspondingNews != null) break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          final userInfo = AccountApi.getInstance().queryUserInfo();
          return AdvancedCustomImageViewer(
            imageProviders: imageUrls,
            initialIndex: initialIndex,
            authorId: correspondingNews?.author?.authorId,
            authorIcon: correspondingNews?.author?.authorIcon,
            authorNickName: correspondingNews?.author?.authorNickName,
            createTime: correspondingNews?.createTime,
            commentCount: correspondingNews?.commentCount ?? 0,
            likeCount: correspondingNews?.likeCount ?? 0,
            isLiked: correspondingNews?.isLiked ?? false,
            shareCount: correspondingNews?.shareCount ?? 0,
            isLogin: userInfo.isLogin,
            currentUserId: userInfo.authorId,
            heroTagPrefix:
                'image_${postId}_${postId.hashCode}', // 保留Hero标签以实现动画效果
            onNewsLike: () {
              // 【对齐鸿蒙】添加登录检查
              final loginVM = login_vm.LoginVM.getInstance();
              if (!loginVM.accountInstance.userInfoModel.isLogin) {
                // 未登录则跳转到登录页面
                LoginSheetUtils.showLoginSheet(context);
                return;
              }

              // 切换点赞状态
              if (correspondingNews != null) {
                setState(
                  () {
                    correspondingNews?.isLiked = !correspondingNews.isLiked;
                    if (correspondingNews!.isLiked) {
                      MineServiceApi.addLike(correspondingNews.id);
                      // 点赞数量加1
                      correspondingNews.likeCount =
                          (correspondingNews.likeCount) + 1;
                    } else {
                      MineServiceApi.cancelLike(correspondingNews.id);
                      // 点赞数量减1，确保不为负数
                      correspondingNews.likeCount =
                          max(0, (correspondingNews.likeCount) - 1);
                    }
                    // 发送事件通知
                    EventBusUtils.sendEvent(
                        NewLikeEvent(correspondingNews.isLiked, ""));
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
