import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:business_video/services/video_services.dart';
import 'package:business_video/views/video_sheet.dart';
import 'package:lib_account/services/account_api.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_news_api/params/request/common_request.dart';
import 'package:lib_news_api/services/mockdata/mock_flex_layout.dart';
import 'package:module_flutter_feedcomment/utils/utils.dart';
import 'package:module_flutter_feedcomment/components/publish_comment.dart';
import 'package:module_share/model/share_model.dart';
import 'package:module_share/views/Share.dart';
import '../utils/number_formatter.dart';
import 'article_text_elipsis.dart';
import 'native_navigation_utils.dart';
import 'package:business_home/home_page/widgets/author_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_news_api/params/base/base_model.dart';
import 'package:lib_news_api/params/response/comment_response.dart';
import 'package:lib_news_api/constants/constants.dart';
import 'package:lib_news_api/params/response/layout_response.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/services/base_news_service.dart';
import 'package:lib_news_api/services/comment_service.dart';
import 'package:lib_news_api/services/home_service.dart';
import 'package:lib_news_api/services/mine_service.dart';
import 'package:module_imagepreview/advanced_customImage_viewer.dart';
import 'package:lib_news_api/services/author_service.dart';
import 'package:module_newsfeed/components/rcommend_list.dart';
import 'package:module_share/utils/event_dispatcher.dart';
import 'comment_Input_bar.dart';
import 'comment_list.dart';
import 'package:lib_account/viewmodels/login_vm.dart' as login_vm;
import 'package:module_newsfeed/constants/constants.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsResponse? news;
  final List<RequestListData>? newsList;
  final bool needScrollToComment;
  final double fontSizeRatio;

  const NewsDetailPage({
    super.key,
    required this.news,
    this.newsList,
    this.needScrollToComment = false,
    this.fontSizeRatio = 1.0,
  });
  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage>
    implements MarkLikeObserver {
  bool _collectFlag = false;
  List<CommentResponse> commentResponse = [];
  final GlobalKey commentListKey = GlobalKey();
  final GlobalKey commentDividerKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  final List<String> imageProviders = [];
  List<RequestListData> newsInfoList = [];
  late StreamSubscription _subscription;
  late bool _isLike = false;
  bool _isCommentSheetOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.news != null) {
      final newModel = VideoService.queryVideoDataById(widget.news!.id);
      widget.news?.isMarked = newModel!.isMarked;
      widget.news?.markCount = newModel!.markCount;
      widget.news?.isLiked = newModel!.isLiked;
      widget.news?.likeCount = newModel!.likeCount;
      MineServiceApi.addToHistory(widget.news!.id);
    }

    setState(() {
      if (widget.news != null) {
        MineServiceApi.addToHistory(widget.news!.id);
        _isLike = widget.news?.isLiked ?? false;
        _collectFlag = widget.news?.isMarked ?? false;
      }
    });
    MineServiceApi.addObserver(this);
    _loadComments();
    widget.news!.commentCount =
        CommentServiceApi.queryTotalCommentCount(widget.news!.id);
    imageProviders.addAll(
      widget.news!.postImgList!.map(
        (group) => group.picVideoUrl,
      ),
    );
    _subscription = EventBusUtils.listenEvent<ShareButtonClickEvent>(
      (event) async {
        final Map<String, String> params = {
          "title": widget.news!.title,
        };

        await NativeNavigationUtils.pushToShare(params: params);
      },
    );
    if (widget.needScrollToComment) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCommentList();
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    MineServiceApi.removeObserver(this);
    super.dispose();
  }

  void _loadComments() {
    List<CommentResponse>? cList =
        CommentServiceApi.queryCommentList(widget.news!.id);
    commentResponse = cList?.toList() ?? [];
    _subscription = EventBusUtils.listenEvent<NewLikeEvent>((event) async {
      setState(() {
        _isLike = event.isLike;
        for (var comment in commentResponse) {
          if (comment.commentId == event.cmd) {
            comment.isLiked = event.isLike;
          }
        }
      });
    });
  }

  Future<void> getNewsDynamicData(String resource) async {
    newsInfoList = await HomeServiceApi.queryHomeRecommendList(resource);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const bottomSheetHeight = Constants.SPACE_80;

    List<CommentResponse>? cList =
        CommentServiceApi.queryCommentList(widget.news!.id);
    commentResponse = cList?.toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            CommonConstants.iconBackPath,
            width: Constants.SPACE_15,
            height: Constants.SPACE_15,
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            fit: BoxFit.contain,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('新闻详情'),
        actions: [
          _AnimatedHeadsetButton(news: widget.news),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.news!.type == NewsEnum.article) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.SPACE_16,
                          vertical: Constants.SPACE_12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.news!.title,
                          style: TextStyle(
                            fontSize: Constants.FONT_20 * widget.fontSizeRatio,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                  // 作者+发布时间
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Constants.SPACE_16,
                        Constants.SPACE_16,
                        Constants.SPACE_16,
                        Constants.SPACE_8),
                    child: AuthorCard(
                        cardData: widget.news!,
                        isNeedAuthor: true,
                        watchBuilder: () {}),
                  ),
                  // 正文内容
                  if (widget.news!.type == NewsEnum.article) ...[
                    _buildTextFirstGroup(widget.news!.richContent ?? ''),
                    if (widget.news!.postImgList != null &&
                        widget.news!.postImgList!.isNotEmpty) ...[
                      ...widget.news!.postImgList!.map((group) {
                        return _buildImageFirstGroup(group);
                      }),
                    ],
                  ] else if (widget.news!.type == NewsEnum.post) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.SPACE_16,
                          vertical: Constants.SPACE_0),
                      child: ArticleTextEllipsis(
                        text: widget.news!.title,
                        fontSizeRatio: widget.fontSizeRatio,
                        enableExpand: false,
                        searchKey: widget.news!.extraInfo?['searchKey'] ?? '',
                        maxLines: null,
                      ),
                    ),
                    if (widget.news!.postImgList != null &&
                        widget.news!.postImgList!.isNotEmpty) ...[
                      _buildPostImageGrid(widget.news!.postImgList!),
                    ],
                  ],

                  // 互动栏（评论/点赞/分享）
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.SPACE_16,
                        vertical: Constants.SPACE_12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInteractiveButton(
                            iconPath: widget.news!.isLiked
                                ? Constants.likeActiveImagePath
                                : Constants.likeImagePath,
                            isLiked: _isLike,
                            text: widget.news!.likeCount.toString(),
                            onTap: () {
                              final loginVM = login_vm.LoginVM.getInstance();
                              if (!loginVM
                                  .accountInstance.userInfoModel.isLogin) {
                                VideoSheet.showLoginSheet(context);
                                return;
                              }
                              _handleLike(context);
                            }),
                        _buildInteractiveButton(
                          iconPath: Constants.icWechatImage,
                          text: NumberFormatter.formatCompact(
                              widget.news!.commentCount ?? 0),
                          onTap: () async {
                            final Map<String, String> params = {
                              "params": widget.news!.title
                            };
                            await NativeNavigationUtils.pushToShareWX(
                                params: params);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    key: commentDividerKey,
                    height: Constants.SPACE_10,
                    color: Colors.grey[200],
                  ),

                  RecommendList(
                    requestListDataList: HomeServiceApi.getRecommendList(
                            MockFlexLayout.recommendList) ??
                        [],
                    titleStyle: const TextStyle(
                      fontSize: Constants.FONT_16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                    subtitleStyle: const TextStyle(
                      fontSize: Constants.FONT_11,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    imageWidth: Constants.SPACE_120,
                    imageHeight: Constants.SPACE_90,
                    padding: const EdgeInsets.all(Constants.SPACE_10),
                  ),
                  Container(
                    height: Constants.SPACE_10,
                    color: Colors.grey[200],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          screenHeight - bottomSheetHeight - Constants.SPACE_10,
                    ),
                    child: CommentList(
                      cardData: widget.news,
                      key: commentListKey,
                      showInteractiveButtons: false,
                      onPullUpKeyboard: () => showCommond('', ''),
                      commentResponse: commentResponse,
                      onCommentLike: (String commentId, bool isLiked) {
                        final loginVM = login_vm.LoginVM.getInstance();
                        if (!loginVM.accountInstance.userInfoModel.isLogin) {
                          VideoSheet.showLoginSheet(context);
                          return;
                        }
                        if (isLiked) {
                          CommentServiceApi.addCommentLike(commentId);
                        } else {
                          CommentServiceApi.cancelCommentLike(commentId);
                        }
                      },
                      onReplyToComment: (
                          {required CommentResponse targetComment,
                          CommentResponse? targetReply}) {
                        showCommond(targetReply!.author!.authorNickName,
                            targetComment.commentId);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomCommentInput(),
        ],
      ),
    );
  }

  Widget _buildBottomCommentInput() {
    // 根据评论弹窗状态决定是否显示底部评论栏
    if (_isCommentSheetOpen) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: Constants.SPACE_80,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: Constants.SPACE_80,
        color: Colors.white,
        child: CommentInputBar(
          news: widget.news!,
          onSendComment: () {
            _scrollToCommentList();
            showCommond('', '');
          },
          onScrollToComment: () {
            _scrollToCommentList();
          },
          onLike: () {
            _handleLike(context);
            setState(() {});
          },
          onShare: () async {
            final Map<String, String> params = {"params": widget.news!.title};
            await NativeNavigationUtils.pushToShare(params: params);
          },
        ),
      ),
    );
  }

  void showCommond(String title, String commendId) {
    final loginVM = login_vm.LoginVM.getInstance();
    if (!loginVM.accountInstance.userInfoModel.isLogin) {
      VideoSheet.showLoginSheet(context);
      return;
    }

    // 设置评论弹窗为打开状态，隐藏底部评论栏
    setState(() {
      _isCommentSheetOpen = true;
    });

    // 打开评论弹窗
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: publishCommentBuilder(
              context,
              CommentParams(title, (content) {
                PublishCommentRequest params = PublishCommentRequest(
                    newsId: widget.news!.id,
                    content: content,
                    parentCommentId: commendId);
                MineServiceApi.publishComment(params).then((value) {
                  setState(() {
                    if (title.isEmpty) {
                      commentResponse.add(value);
                    } else {
                      for (int i = 0; i < commentResponse.length; i++) {
                        if (commentResponse[i].commentId == commendId) {
                          commentResponse[i].replyComments.add(value);
                        }
                      }
                    }
                  });
                });
              })),
        );
      },
      isScrollControlled: true,
    ).then((_) {
      // 评论弹窗关闭后，重新显示底部评论栏
      setState(() {
        _isCommentSheetOpen = false;
      });
    });
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      // Handle local file paths, removing file:// prefix if present
      final filePath =
          imageUrl.startsWith('file://') ? imageUrl.substring(7) : imageUrl;
      return FileImage(File(filePath));
    }
  }

  Size _calculateImageSize(String imageUrl) {
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
    double aspectRatio = 0;
    if (originalHeight > 0) {
      aspectRatio = originalWidth / originalHeight;
    }
    double width;
    double height;
    if (aspectRatio < 1) {
      // 竖图
      width = 220;
      height = width / (2 / 3);
    } else if (aspectRatio == 1) {
      // 方图
      width = 280;
      height = 280;
    } else if (aspectRatio > 1) {
      // 横图
      width = 327;
      height = width / 1.5;
    } else {
      if (imageUrl.contains('.mp4')) {
        width = 327;
        height = width / 1.5;
      } else {
        width = 220;
        height = width / (2 / 3);
      }
    }
    return Size(width, height);
  }

  Widget _buildPostImageGrid(List<PostImgList> postImgList) {
    final imageUrls = postImgList
        .where((item) => item.surfaceUrl.isEmpty)
        .map((item) => item.picVideoUrl)
        .where((url) => url.isNotEmpty)
        .toList();
    if (imageUrls.isEmpty) return const SizedBox.shrink();
    if (imageUrls.length == 1) {
      final imageSize = _calculateImageSize(imageUrls[0]);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  final userInfo = AccountApi.getInstance().queryUserInfo();
                  return AdvancedCustomImageViewer(
                    imageProviders: imageUrls,
                    authorId: widget.news?.author?.authorId,
                    authorIcon: widget.news?.author?.authorIcon,
                    authorNickName: widget.news?.author?.authorNickName,
                    createTime: widget.news?.createTime,
                    commentCount: widget.news?.commentCount ?? 0,
                    likeCount: widget.news?.likeCount ?? 0,
                    isLiked: widget.news?.isLiked ?? false,
                    shareCount: widget.news?.shareCount ?? 0,
                    isLogin: userInfo.isLogin,
                    currentUserId: userInfo.authorId,
                    initialIndex: 0,
                    onNewsLike: () {
                      if (mounted) {
                        _handleLike(context);
                      }
                    },
                    onAddComment: () {
                      if (mounted) {
                        _handleComment(context);
                      }
                    },
                    onShare: () {
                      if (mounted) {
                        _handleShare(context);
                      }
                    },
                    onWatchOperation: () {
                      if (mounted) {
                        _handleWatch(context);
                      }
                    },
                  );
                },
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: _getImageProvider(imageUrls[0]),
              width: imageSize.width,
              height: imageSize.height,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : Container(
                      width: imageSize.width,
                      height: imageSize.height,
                      color: Colors.grey[100],
                      child: const Center(
                        child: CircularProgressIndicator(
                            strokeWidth: Constants.SPACE_2),
                      ),
                    ),
              errorBuilder: (context, error, stack) => Container(
                width: imageSize.width,
                height: imageSize.height,
                color: Colors.grey[100],
                child: const Center(
                  child: Icon(Icons.image_not_supported_outlined,
                      color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final int crossAxisCount = imageUrls.length == 4 ? 2 : 3;
    final double imageSize =
        (MediaQuery.of(context).size.width - 32 - (crossAxisCount - 1) * 4) /
            crossAxisCount;
    final int displayCount = imageUrls.length > 9 ? 9 : imageUrls.length;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.SPACE_16, vertical: Constants.SPACE_8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1.0,
        ),
        itemCount: displayCount,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    final userInfo = AccountApi.getInstance().queryUserInfo();
                    return AdvancedCustomImageViewer(
                      imageProviders: imageUrls,
                      authorId: widget.news?.author?.authorId,
                      authorIcon: widget.news?.author?.authorIcon,
                      authorNickName: widget.news?.author?.authorNickName,
                      createTime: widget.news?.createTime,
                      commentCount: widget.news?.commentCount ?? 0,
                      likeCount: widget.news?.likeCount ?? 0,
                      isLiked: widget.news?.isLiked ?? false,
                      shareCount: widget.news?.shareCount ?? 0,
                      isLogin: userInfo.isLogin,
                      currentUserId: userInfo.authorId,
                      initialIndex: index,
                      onNewsLike: () {
                        if (mounted) {
                          _handleLike(context);
                        }
                      },
                      onAddComment: () {
                        if (mounted) {
                          _handleComment(context);
                        }
                      },
                      onShare: () {
                        if (mounted) {
                          _handleShare(context);
                        }
                      },
                      onWatchOperation: () {
                        if (mounted) {
                          _handleWatch(context);
                        }
                      },
                    );
                  },
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Constants.SPACE_10),
              child: Image(
                image: _getImageProvider(imageUrls[index]),
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : Container(
                        width: imageSize,
                        height: imageSize,
                        color: Colors.grey[100],
                        child: const Center(
                          child: CircularProgressIndicator(
                              strokeWidth: Constants.SPACE_2),
                        ),
                      ),
                errorBuilder: (context, error, stack) => Container(
                  width: imageSize,
                  height: imageSize,
                  color: Colors.grey[100],
                  child: const Center(
                    child: Icon(Icons.image_not_supported_outlined,
                        color: Colors.grey),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _scrollToCommentList() {
    if (commentDividerKey.currentContext != null) {
      RenderBox renderBox =
          commentDividerKey.currentContext!.findRenderObject() as RenderBox;
      Offset offset = renderBox.localToGlobal(Offset.zero);

      scrollController.animateTo(
        scrollController.offset + offset.dy + 150,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleComment(BuildContext context) {
    _scrollToCommentList();
  }

  void _handleWatch(BuildContext context) {
    final loginVM = login_vm.LoginVM.getInstance();
    if (!loginVM.accountInstance.userInfoModel.isLogin) {
      VideoSheet.showLoginSheet(context);
      return;
    }

    if (widget.news?.author != null) {
      final authorId = widget.news!.author!.authorId;
      final userInfoModel = AccountApi.getInstance().queryUserInfo();

      setState(() {
        if (userInfoModel.watchers.contains(authorId)) {
          authorServiceApi.unfollowAuthor(
            userInfoModel.authorId,
            authorId,
          );
        } else {
          authorServiceApi.followAuthor(
            userInfoModel.authorId,
            authorId,
          );
        }
      });
    }
  }

  Future<void> _handleShare(BuildContext context) async {
    if (widget.news != null) {
      try {
        final shareOptions = ShareOptions(
          id: widget.news!.id,
          title: widget.news!.title,
          articleFrom: widget.news!.articleFrom ?? '',
        );
        Share.show(context, shareOptions, widget.news!.title);
        setState(() {
          widget.news!.shareCount = (widget.news!.shareCount ?? 0) + 1;
        });
      } catch (e) {
        // 分享异常处理
      }
    }
  }

  void _handleLike(BuildContext context) {
    final loginVM = login_vm.LoginVM.getInstance();
    if (!loginVM.accountInstance.userInfoModel.isLogin) {
      VideoSheet.showLoginSheet(context);
      return;
    }

    if (widget.news != null) {
      try {
        bool newLikeStatus = !(widget.news!.isLiked ?? false);
        int newLikeCount = widget.news!.likeCount ?? 0;
        newLikeCount += newLikeStatus ? 1 : -1;
        newLikeCount = max(0, newLikeCount);
        if (newLikeStatus) {
          MineServiceApi.addLike(widget.news!.id);
          CommentServiceApi.addPosterLike(widget.news!.id);
        } else {
          MineServiceApi.cancelLike(widget.news!.id);
          CommentServiceApi.cancelPosterLike(widget.news!.id);
        }
        final rawNews = BaseNewsServiceApi.queryRawNews(widget.news!.id);
        if (rawNews != null) {
          rawNews.isLiked = newLikeStatus;
          rawNews.likeCount = newLikeCount;
        }
        widget.news!.isLiked = newLikeStatus;
        widget.news!.likeCount = newLikeCount;
        _isLike = newLikeStatus;
      } catch (e) {
        if (widget.news != null) {
          final currentStatus = widget.news!.isLiked ?? false;
          widget.news!.isLiked = !currentStatus;
          widget.news!.likeCount =
              (widget.news!.likeCount ?? 0) + (currentStatus ? -1 : 1);
          widget.news!.likeCount = max(0, widget.news!.likeCount);
          _isLike = widget.news!.isLiked;
        }
      }
    }
    setState(() {});
  }

  Widget _buildImageFirstGroup(PostImgList group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (group.picVideoUrl.isNotEmpty)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    final userInfo = AccountApi.getInstance().queryUserInfo();
                    return AdvancedCustomImageViewer(
                      imageProviders: imageProviders,
                      authorId: widget.news?.author?.authorId,
                      authorIcon: widget.news?.author?.authorIcon,
                      authorNickName: widget.news?.author?.authorNickName,
                      createTime: widget.news?.createTime,
                      commentCount: widget.news?.commentCount ?? 0,
                      likeCount: widget.news?.likeCount ?? 0,
                      isLiked: widget.news?.isLiked ?? false,
                      shareCount: widget.news?.shareCount ?? 0,
                      isLogin: userInfo.isLogin,
                      currentUserId: userInfo.authorId,
                      initialIndex: 0,
                      onNewsLike: () {
                        if (mounted) {
                          _handleLike(context);
                        }
                      },
                      onAddComment: () {
                        if (mounted) {
                          _handleComment(context);
                        }
                      },
                      onShare: () {
                        if (mounted) {
                          _handleShare(context);
                        }
                      },
                      onWatchOperation: () {
                        if (mounted) {
                          _handleWatch(context);
                        }
                      },
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.SPACE_16,
                vertical: Constants.SPACE_5,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  Constants.SPACE_10,
                ),
                child: Image(
                  image: _getImageProvider(group.picVideoUrl),
                  width: double.infinity,
                  // height: Constants.SPACE_220,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : Container(
                          width: double.infinity,
                          height: Constants.SPACE_220,
                          color: Colors.grey[100],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: Constants.SPACE_10,
                            ),
                          ),
                        ),
                  errorBuilder: (context, error, stack) => Container(
                    width: double.infinity,
                    height: Constants.SPACE_220,
                    color: Colors.grey[100],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Constants.SPACE_16,
            vertical: Constants.SPACE_12,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFirstGroup(String richContent) {
    List<String> textList =
        HtmlUtils.extractPlainText(richContent, true).split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...textList.map((text) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.SPACE_16,
              vertical: Constants.SPACE_6,
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: Constants.FONT_16 * widget.fontSizeRatio,
                color: Colors.black87,
                height: Constants.SPACE_1_5,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInteractiveButton({
    bool? isLiked = false,
    required String iconPath,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Constants.SPACE_30,
        width: Constants.SPACE_150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constants.SPACE_8),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconPath.contains('svg'))
                SvgPicture.asset(
                  'packages/module_newsfeed/assets/$iconPath',
                  key: ValueKey(iconPath),
                  width: Constants.SPACE_18,
                  height: Constants.SPACE_18,
                  fit: BoxFit.contain,
                )
              else
                Image.asset(
                  'packages/module_newsfeed/assets/$iconPath',
                  width: Constants.SPACE_18,
                  height: Constants.SPACE_18,
                  fit: BoxFit.contain,
                ),
              const SizedBox(width: Constants.SPACE_10),
              Text(
                iconPath.contains('png') ? '微信' : text,
                style: const TextStyle(
                    fontSize: Constants.FONT_12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onMarkLikeUpdated(MarkLikeUpdateType type) {
    if (widget.news != null) {
      final rawNews = BaseNewsServiceApi.queryRawNews(widget.news!.id);
      if (rawNews != null) {
        setState(() {
          _isLike = rawNews.isLiked ?? false;
          _collectFlag = rawNews.isMarked ?? false;
          if (widget.news != null) {}
        });
      }
    }
  }
}

class HtmlUtils {
  static String extractPlainText(String htmlContent, bool isNewsDetail) {
    if (htmlContent.isEmpty) {
      return '';
    }
    return htmlContent
        .replaceAll(RegExp(r'<[^>]*>', multiLine: true), '')
        .replaceAll(RegExp(r'&nbsp;'), ' ')
        .replaceAll(RegExp(r'&lt;'), '<')
        .replaceAll(RegExp(r'&gt;'), '>')
        .replaceAll(RegExp(r'&amp;'), '&')
        .replaceAll(RegExp(r'&quot;'), '"')
        .replaceAll(RegExp(r'&apos;'), "'")
        .replaceAll(RegExp(r'\n\s*\n'), '\n\n')
        .replaceAll(RegExp(r'[\r\t]+'), ' ')
        .replaceAll(RegExp(r'\s{2,}'), isNewsDetail ? '\n' : ' ')
        .trim();
  }
}

class _AnimatedHeadsetButton extends StatefulWidget {
  final NewsResponse? news;
  const _AnimatedHeadsetButton({this.news});
  @override
  _AnimatedHeadsetButtonState createState() {
    return _AnimatedHeadsetButtonState();
  }
}

class _AnimatedHeadsetButtonState extends State<_AnimatedHeadsetButton> {
  int _clickCount = 0;
  bool _autoClickTriggered = false;
  bool _firstAppLaunchClickComplete = false;
  DateTime? _lastClickTime;
  static const int _clickIntervalThreshold = 500;
  int _rapidClickCount = 0;

  @override
  void dispose() {
    _lastClickTime = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        Constants.icHeadsetImage,
        width: Constants.SPACE_36,
        height: Constants.SPACE_36,
      ),
      onPressed: _handlePress,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }

  void _handlePress() {
    _detectRapidClicks();
    if (widget.news != null) {
      _processNewsContent();
      if (_clickCount == 0) {
        _firstAppLaunchClickComplete = true;
      }
      _clickCount++;
      _autoClickTriggered = false;
      if (_firstAppLaunchClickComplete && _clickCount >= 2) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && !_autoClickTriggered) {
            _autoClickTriggered = true;
            _processNewsContent();
          }
        });
      }
    }
  }

  void _detectRapidClicks() {
    final now = DateTime.now();
    if (_lastClickTime != null) {
      final timeDifference = now.difference(_lastClickTime!).inMilliseconds;
      if (timeDifference < _clickIntervalThreshold) {
        _rapidClickCount++;
      } else {
        _rapidClickCount = 0;
      }
    }
    _lastClickTime = now;
  }

  void _processNewsContent() async {
    String newsContent = HtmlUtils.extractPlainText(
        widget.news!.richContent ?? widget.news!.postBody ?? '', false);
    if (newsContent.isEmpty) {
      newsContent = widget.news!.title;
    }
    final Map<String, String> params = {
      'currentId': widget.news!.id,
      'body': newsContent,
      'title': widget.news!.title,
      'author': widget.news!.author?.authorNickName ?? '',
      'date': widget.news!.relativeTime ?? '',
      'bundleName': "我的朗读",
      'coverImage': widget.news!.postImgList?.isNotEmpty == true
          ? widget.news!.postImgList![0].picVideoUrl
          : '',
      'from': 'Flutter'
    };

    await NativeNavigationUtils.AInews(params: params);
  }
}
