import 'package:business_home/components/widget_extent.dart';
import 'package:business_home/components/topText_bottomImage_card.dart';
import '../commons/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/models/userInfo_model.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_news_api/lib_news_api.dart';
import 'package:lib_news_api/services/author_service.dart';
import 'package:lib_account/services/account_api.dart';
import 'package:lib_account/utils/login_sheet_utils.dart';
import 'package:module_imagepreview/advanced_customImage_viewer.dart';
import 'package:module_newsfeed/components/news_detail_page.dart';
import 'feed_single_image_size.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';

class FeedDetail extends StatefulWidget {
  final NewsResponse curFeedCardInfo;

  const FeedDetail({
    super.key,
    required this.curFeedCardInfo,
  });
  @override
  State<FeedDetail> createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  late UserInfoModel userInfoModel;
  bool _isExpanded = false;
  final int _maxLines = Constants.feedDetailMaxLines;

  @override
  void initState() {
    super.initState();
    userInfoModel = AccountApi.getInstance().userInfoModel;
    userInfoModel.addListener(
      _onUserInfoChanged,
    );
  }

  @override
  void dispose() {
    userInfoModel.removeListener(
      _onUserInfoChanged,
    );
    super.dispose();
  }

  void _onUserInfoChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String get _authorIcon {
    if (isFeedSelf && userInfoModel.authorIcon.isNotEmpty) {
      return userInfoModel.authorIcon;
    }
    return widget.curFeedCardInfo.author?.authorIcon ?? '';
  }

  String get _authorName {
    if (isFeedSelf && userInfoModel.authorNickName.isNotEmpty) {
      return userInfoModel.authorNickName;
    }
    return widget.curFeedCardInfo.author?.authorNickName ?? '未知作者';
  }

  bool get isFeedSelf {
    return userInfoModel.isLogin &&
        userInfoModel.authorId.isNotEmpty &&
        userInfoModel.authorId == widget.curFeedCardInfo.author?.authorId;
  }

  bool get isWatched {
    if (!userInfoModel.isLogin || userInfoModel.authorId.isEmpty) {
      return false;
    }
    return userInfoModel.watchers.contains(
      widget.curFeedCardInfo.author?.authorId,
    );
  }

  void _handleWatch() {
    if (!userInfoModel.isLogin) {
      LoginSheetUtils.showLoginSheet(
        context,
      );
      return;
    }

    final authorId = widget.curFeedCardInfo.author?.authorId;
    if (authorId == null || authorId.isEmpty) return;
    if (isWatched) {
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
  }

  List<PostImgList> _getValidImageList() {
    final originalList = widget.curFeedCardInfo.postImgList;
    if (originalList == null || originalList.isEmpty) return [];
    return originalList.where((item) {
      return item.surfaceUrl.isNotEmpty || item.picVideoUrl.isNotEmpty;
    }).toList();
  }

  List<PostImgList> _computeDisplayImages() {
    final validImages = _getValidImageList();
    if (validImages.isEmpty) return [];
    final count = validImages.length;
    final keepCountMap = {5: 4, 6: 6, 7: 6, 8: 6, 9: 9};
    final keepCount = keepCountMap[count] ?? count;
    return validImages.sublist(0, keepCount.clamp(0, validImages.length));
  }

  int _getColumnsCount(int imageCount) {
    if (imageCount == 1) return 1;
    if (imageCount == 2 || imageCount == 4) return 2;
    return 3;
  }

  List<String> _getImageUrls() {
    final validImages = _getValidImageList();
    return validImages.map((item) {
      return item.surfaceUrl.isNotEmpty ? item.surfaceUrl : item.picVideoUrl;
    }).toList();
  }

  void _handleLike() {
    if (!userInfoModel.isLogin) {
      LoginSheetUtils.showLoginSheet(context);
      return;
    }
    setState(() {
      widget.curFeedCardInfo.isLiked = !widget.curFeedCardInfo.isLiked;
      if (widget.curFeedCardInfo.isLiked) {
        CommentServiceApi.addPosterLike(widget.curFeedCardInfo.id);
        widget.curFeedCardInfo.likeCount = widget.curFeedCardInfo.likeCount + 1;
      } else {
        CommentServiceApi.cancelPosterLike(widget.curFeedCardInfo.id);
        widget.curFeedCardInfo.likeCount = widget.curFeedCardInfo.likeCount - 1;
      }
    });
  }

  void _handleComment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(
          news: widget.curFeedCardInfo,
          fontSizeRatio: FontScaleUtils.fontSizeRatio,
          needScrollToComment: true,
        ),
      ),
    );
  }

  void _showImagePreview(int initialIndex) {
    final imageUrls = _getImageUrls();
    if (imageUrls.isEmpty) return;
    final outerContext = context;
    Navigator.push(
      outerContext,
      ImagePreviewPageRoute(
        builder: (context) {
          final userInfo = AccountApi.getInstance().queryUserInfo();
          return AdvancedCustomImageViewer(
            imageProviders: imageUrls,
            initialIndex: initialIndex,
            authorId: widget.curFeedCardInfo.author?.authorId,
            authorIcon: widget.curFeedCardInfo.author?.authorIcon,
            authorNickName: widget.curFeedCardInfo.author?.authorNickName,
            createTime: widget.curFeedCardInfo.createTime,
            commentCount: widget.curFeedCardInfo.commentCount,
            likeCount: widget.curFeedCardInfo.likeCount,
            isLiked: widget.curFeedCardInfo.isLiked,
            shareCount: widget.curFeedCardInfo.shareCount,
            isLogin: userInfo.isLogin,
            currentUserId: userInfo.authorId,
            heroTagPrefix: 'feed_detail_${widget.curFeedCardInfo.id}',
            onWatchOperation: () {
              if (mounted) {
                _handleWatch();
              }
            },
            onNewsLike: () {
              if (mounted) {
                _handleLike();
              }
            },
            onAddComment: () {
              if (mounted) {
                _handleComment();
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayImages = _computeDisplayImages();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: Constants.feedDetailBottomPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: Constants.feedDetailAvatarRadius,
                          backgroundImage: _authorIcon.isNotEmpty
                              ? NetworkImage(_authorIcon)
                              : const AssetImage(
                                  Constants.feedDetailDefaultAvatarPath,
                                ),
                          child: _authorIcon.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: Constants.feedDetailIconSize24,
                                )
                              : null,
                        ),
                      ],
                    ).clickable(() {}),
                    const SizedBox(
                      width: Constants.feedDetailWidth8,
                    ),
                    // 作者名称和时间
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _authorName,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: Constants.fontSizeSmall,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: Constants.feedDetailHeight4,
                          ),
                          _buildPublishTime(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 关注按钮
              if (!isFeedSelf) _buildFollowButton(),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: _buildTextContent(),
        ),
        const SizedBox(
          height: Constants.feedDetailHeight8,
        ),
        if (displayImages.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              final columnCount = _getColumnsCount(
                displayImages.length,
              );
              return GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  crossAxisSpacing:
                      Constants.feedDetailImageGridCrossAxisSpacing,
                  mainAxisSpacing: Constants.feedDetailImageGridMainAxisSpacing,
                  childAspectRatio: columnCount == 1
                      ? Constants.feedDetailSingleColumnAspectRatio
                      : Constants.feedDetailMultiColumnAspectRatio,
                ),
                itemCount: displayImages.length,
                itemBuilder: (context, index) {
                  final item = displayImages[index];
                  final isLast = index == displayImages.length - 1;
                  return _buildImageItem(
                    item,
                    index,
                    isLast,
                    displayImages.length,
                  );
                },
              );
            },
          ),
        const SizedBox(
          height: Constants.feedDetailHeight8,
        ),
      ],
    );
  }

  Widget _buildImageItem(
    PostImgList item,
    int index,
    bool isLast,
    int totalCount,
  ) {
    return FeedSingleImageSize(
      componentId: 'feed_detail_${widget.curFeedCardInfo.id}',
      isLast: isLast,
      curFeedCardInfo: widget.curFeedCardInfo,
      truncatedCount: totalCount,
      postImgListItem: item,
      onImageClick: () {
        _showImagePreview(index);
      },
      onVideo: () {},
    );
  }

  Widget _buildPublishTime() {
    return Text(
      widget.curFeedCardInfo.relativeTime ?? '',
      style: const TextStyle(
        fontSize: Constants.fontSizeTiny,
        color: Constants.feedDetailColor8C8C8E,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFollowButton() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.feedDetailButtonPaddingHorizontal,
        vertical: Constants.feedDetailButtonPaddingVertical,
      ),
      decoration: BoxDecoration(
        color: isWatched
            ? Constants.feedDetailColorF5F5F5
            : Constants.feedDetailAppThemeColor,
        borderRadius: BorderRadius.circular(
          Constants.feedDetailButtonBorderRadius,
        ),
      ),
      child: GestureDetector(
        onTap: _handleWatch,
        child: Text(
          isWatched ? '已关注' : '关注',
          style: TextStyle(
            fontSize: Constants.fontSizeSmall,
            color: isWatched ? Constants.feedDetailAppThemeColor : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const textStyle = TextStyle(
          fontSize: Constants.fontSizeTitle,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          height: Constants.feedDetailTextHeight,
        );
        final hasSearchKey =
            widget.curFeedCardInfo.extraInfo?["searchKey"] != null;
        final searchKey = hasSearchKey
            ? widget.curFeedCardInfo.extraInfo!["searchKey"].toString()
            : '';
        if (_isExpanded) {
          if (hasSearchKey) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HighlightText(
                  keywords: [searchKey],
                  sourceString: widget.curFeedCardInfo.title,
                  highlightColor: Constants.highlightColor,
                  textColor: Colors.black87,
                  fontSize: Constants.fontSizeTitle,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: Constants.feedDetailHeight8,
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: '收起',
                      style: const TextStyle(
                        fontSize: Constants.fontSizeSmall,
                        color: Constants.feedDetailAppThemeColor,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(
                            () => _isExpanded = false,
                          );
                        },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.curFeedCardInfo.title,
                  style: textStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: '收起',
                      style: const TextStyle(
                        fontSize: Constants.fontSizeSmall,
                        color: Constants.feedDetailAppThemeColor,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(
                            () => _isExpanded = false,
                          );
                        },
                    ),
                  ),
                ),
              ],
            );
          }
        }
        final fullTextPainter = TextPainter(
          text: TextSpan(
            text: widget.curFeedCardInfo.title,
            style: textStyle,
          ),
          maxLines: _maxLines,
          textDirection: TextDirection.ltr,
        )..layout(
            maxWidth: constraints.maxWidth,
          );

        if (!fullTextPainter.didExceedMaxLines) {
          if (hasSearchKey) {
            return HighlightText(
              keywords: [searchKey],
              sourceString: widget.curFeedCardInfo.title,
              highlightColor: Constants.highlightColor,
              textColor: Colors.black87,
              fontSize: Constants.fontSizeTitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            );
          } else {
            return Text(
              widget.curFeedCardInfo.title,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            );
          }
        }

        int left = 0;
        int right = widget.curFeedCardInfo.title.length;
        String clippedText = '';
        while (left < right) {
          int mid = (left + right + 1) ~/ 2;
          final testText = widget.curFeedCardInfo.title.substring(0, mid);
          final testPainter = TextPainter(
            text: TextSpan(
              style: textStyle,
              children: [
                TextSpan(text: testText),
                TextSpan(
                  text: '...全文',
                  style: textStyle.copyWith(
                      color: Constants.feedDetailAppThemeColor),
                ),
              ],
            ),
            maxLines: _maxLines,
            textDirection: TextDirection.ltr,
          )..layout(
              maxWidth: constraints.maxWidth,
            );

          if (testPainter.didExceedMaxLines) {
            right = mid - 1;
          } else {
            clippedText = testText;
            left = mid;
          }
        }
        if (hasSearchKey) {
          final highlightIndex = clippedText.indexOf(
            searchKey,
          );
          if (highlightIndex >= 0 && highlightIndex < clippedText.length) {
            final beforeText = clippedText.substring(
              0,
              highlightIndex,
            );
            final highlightText = searchKey;
            final afterText = clippedText.substring(
              highlightIndex + highlightText.length,
            );
            return Text.rich(
              TextSpan(
                style: textStyle,
                children: [
                  TextSpan(
                    text: beforeText,
                  ),
                  TextSpan(
                    text: highlightText,
                    style: textStyle.copyWith(
                      color: Constants.highlightColor,
                    ),
                  ),
                  TextSpan(text: afterText),
                  TextSpan(
                    text: '...全文',
                    style: textStyle.copyWith(
                      color: Constants.feedDetailAppThemeColor,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(
                          () => _isExpanded = true,
                        );
                      },
                  ),
                ],
              ),
            );
          } else {
            return Text.rich(
              TextSpan(
                style: textStyle,
                children: [
                  TextSpan(
                    text: clippedText,
                  ),
                  TextSpan(
                    text: '...全文',
                    style: textStyle.copyWith(
                      color: Constants.feedDetailAppThemeColor,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(
                          () => _isExpanded = true,
                        );
                      },
                  ),
                ],
              ),
            );
          }
        } else {
          return Text.rich(
            TextSpan(
              style: textStyle,
              children: [
                TextSpan(
                  text: clippedText,
                ),
                TextSpan(
                  text: '...全文',
                  style: textStyle.copyWith(
                    color: Constants.feedDetailAppThemeColor,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(
                        () => _isExpanded = true,
                      );
                    },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
