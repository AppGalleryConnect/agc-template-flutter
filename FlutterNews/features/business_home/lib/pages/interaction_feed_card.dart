import 'dart:io';
import 'package:business_interaction/utils/font_scale_utils.dart';
import 'package:business_interaction/viewmodels/interaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:lib_news_api/lib_news_api.dart';
import 'package:lib_widget/lib_widget.dart';
import 'package:module_share/model/share_model.dart';
import 'package:module_imagepreview/advanced_customImage_viewer.dart';
import 'package:lib_account/viewmodels/login_vm.dart' as login_vm;
import 'package:lib_account/services/account_api.dart';
import 'package:module_share/views/Share.dart';

class InteractionFeedCard extends StatefulWidget {
  final NewsResponse cardInfo;
  const InteractionFeedCard({
    super.key,
    required this.cardInfo,
  });

  @override
  State<InteractionFeedCard> createState() => _InteractionFeedCardState();
}

class _InteractionFeedCardState
    extends BaseStatefulWidgetState<InteractionFeedCard> {
  UserInfoModel get userInfoModel => AccountApi.getInstance().userInfoModel;
  final InteractionViewModel interactionViewModel = InteractionViewModel();
  bool _isExpanded = false;
  final int _maxLines = 3;

  @override
  void initState() {
    super.initState();

    interactionViewModel.setAuthorId(widget.cardInfo.author?.authorId ?? '');
    userInfoModel.addListener(_onUserInfoChanged);
    interactionViewModel.addListener(_onViewModelChanged);
  }

  void _onUserInfoChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    userInfoModel.removeListener(_onUserInfoChanged);
    interactionViewModel.removeListener(_onViewModelChanged);
    interactionViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        interactionViewModel.actionToNewsDetails(context, widget.cardInfo);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _buildChildren().length,
          itemBuilder: (context, index) {
            return _buildChildren()[index];
          },
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      Row(
        children: [
          CustomImage(
            imageUrl: widget.cardInfo.author?.authorIcon ?? '',
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cardInfo.author?.authorNickName ?? '未知用户',
                  style: TextStyle(
                    fontSize: 14 * FontScaleUtils.fontSizeRatio,
                    fontWeight: FontWeight.w500,
                    color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  TimeUtils.getDateDiff(widget.cardInfo.createTime),
                  style: TextStyle(
                    fontSize: 12 * FontScaleUtils.fontSizeRatio,
                    color: ThemeColors.getFontSecondary(settingInfo.darkSwitch),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      _buildTextContent(const Color(0xFF5C79D9)),
      if (widget.cardInfo.postImgList != null &&
          widget.cardInfo.postImgList!.isNotEmpty) ...[
        const SizedBox(height: 8),
        _buildMediaContent(context, widget.cardInfo.postImgList!),
      ],
      if (widget.cardInfo.videoUrl != null) ...[
        const SizedBox(height: 8),
        _buildVideoThumbnail(widget.cardInfo.videoUrl!),
      ],
      const SizedBox(height: 12),
    ];
  }

  void _handleLike() {
    final loginVM = login_vm.LoginVM.getInstance();
    if (!loginVM.accountInstance.userInfoModel.isLogin) {
      Navigator.of(context).pushNamed(RouterMap.HUAWEI_LOGIN_PAGE);
      return;
    }

    setState(() {
      widget.cardInfo.isLiked = !widget.cardInfo.isLiked;
      if (widget.cardInfo.isLiked) {
        CommentServiceApi.addPosterLike(widget.cardInfo.id);
        widget.cardInfo.likeCount += 1;
      } else {
        CommentServiceApi.cancelPosterLike(widget.cardInfo.id);
        widget.cardInfo.likeCount -= 1;
      }
    });
  }

  void _handleShare() {
    final shareOptions = ShareOptions(
      id: widget.cardInfo.id,
      title: widget.cardInfo.title,
      articleFrom: widget.cardInfo.articleFrom ?? '',
    );
    Share.show(context, shareOptions, widget.cardInfo.postBody!);
  }

  void _handleComment() {
    interactionViewModel.actionToNewsDetails(context, widget.cardInfo);
  }

  Widget _buildTextContent(Color themeColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = TextStyle(
          fontSize: 16 * FontScaleUtils.fontSizeRatio,
          fontWeight: FontWeight.w500,
          color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
          height: 1.5,
        );
        if (_isExpanded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.cardInfo.title, style: textStyle),
              GestureDetector(
                onTap: () => setState(() => _isExpanded = false),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '收起',
                    style: TextStyle(
                        fontSize: 14 * FontScaleUtils.fontSizeRatio,
                        color: themeColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          );
        }
        final fullTextPainter = TextPainter(
          text: TextSpan(
            text: widget.cardInfo.title,
            style: textStyle,
          ),
          maxLines: _maxLines,
          textDirection: TextDirection.ltr,
        )..layout(
            maxWidth: constraints.maxWidth,
          );

        if (!fullTextPainter.didExceedMaxLines) {
          return Text(
            widget.cardInfo.title,
            style: textStyle,
          );
        }
        int left = 0;
        int right = widget.cardInfo.title.length;
        String clippedText = '';
        while (left < right) {
          int mid = (left + right + 1) ~/ 2;
          final testText = widget.cardInfo.title.substring(0, mid);
          final testPainter = TextPainter(
            text: TextSpan(
              style: textStyle,
              children: [
                TextSpan(text: testText),
                TextSpan(
                  text: '...全文',
                  style: textStyle.copyWith(color: themeColor),
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
        return GestureDetector(
          onTap: () => setState(
            () => _isExpanded = true,
          ),
          child: Text.rich(
            TextSpan(
              style: textStyle,
              children: [
                TextSpan(text: clippedText),
                TextSpan(
                  text: '...全文',
                  style: textStyle.copyWith(
                    color: themeColor,
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
      width = 220;
      height = width / (2 / 3);
    } else if (aspectRatio == 1) {
      width = 280;
      height = 280;
    } else if (aspectRatio > 1) {
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

  Widget _buildMediaContent(BuildContext context, List<PostImgList> mediaList) {
    final imageUrls = <String>[];
    final videos = <PostImgList>[];
    for (final media in mediaList) {
      if (media.surfaceUrl.isNotEmpty) {
        videos.add(media);
      } else {
        imageUrls.add(media.picVideoUrl);
      }
    }

    return Column(
      children: [
        if (imageUrls.isNotEmpty) _buildImageGrid(context, imageUrls),
        if (videos.isNotEmpty)
          ...videos.map((video) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildVideoThumbnailWithCover(video),
              )),
      ],
    );
  }

  Widget _buildImageGrid(BuildContext context, List<String> imageUrls) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();
    if (imageUrls.length == 1) {
      final imageSize = _calculateImageSize(imageUrls[0]);
      return GestureDetector(
        onTap: () => _showImageViewer(context, imageUrls, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomImage(
            imageUrl: imageUrls[0],
            width: imageSize.width,
            height: imageSize.height,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final int crossAxisCount = imageUrls.length == 4 ? 2 : 3;
    final double imageSize =
        (MediaQuery.of(context).size.width - 32 - (crossAxisCount - 1) * 4) /
            crossAxisCount;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1.0,
      ),
      itemCount: imageUrls.length > 9 ? 9 : imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showImageViewer(context, imageUrls, index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CustomImage(
              imageUrl: imageUrls[index],
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  void _showImageViewer(
      BuildContext context, List<String> imageUrls, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          final userInfo = AccountApi.getInstance().queryUserInfo();
          return AdvancedCustomImageViewer(
            imageProviders: imageUrls,
            initialIndex: initialIndex,
            authorId: widget.cardInfo.author?.authorId,
            authorIcon: widget.cardInfo.author?.authorIcon,
            authorNickName: widget.cardInfo.author?.authorNickName,
            createTime: widget.cardInfo.createTime,
            commentCount: widget.cardInfo.commentCount,
            likeCount: widget.cardInfo.likeCount,
            isLiked: widget.cardInfo.isLiked,
            shareCount: widget.cardInfo.shareCount,
            isLogin: userInfo.isLogin,
            currentUserId: userInfo.authorId,
            heroTagPrefix:
                'image_${widget.cardInfo.id}_${widget.cardInfo.hashCode}',
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
            onShare: () {
              if (mounted) {
                _handleShare();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildVideoThumbnailWithCover(PostImgList video) {
    final size = _calculateImageSize(video.picVideoUrl);
    return GestureDetector(
      onTap: () {
        interactionViewModel.actionToNewsDetails(context, widget.cardInfo);
      },
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: video.surfaceUrl.isNotEmpty
                  ? (video.surfaceUrl.startsWith('http')
                      ? CustomImage(
                          imageUrl: video.surfaceUrl,
                          width: size.width,
                          height: size.height,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(video.surfaceUrl),
                          width: size.width,
                          height: size.height,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: size.width,
                              height: size.height,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.videocam,
                                size: 60,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ))
                  : Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.videocam,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoThumbnail(String videoUrl) {
    return GestureDetector(
      onTap: () {
        interactionViewModel.actionToNewsDetails(context, widget.cardInfo);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImage(
              imageUrl: widget.cardInfo.postImgList?.isNotEmpty == true
                  ? widget.cardInfo.postImgList!.first.surfaceUrl
                  : '',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
