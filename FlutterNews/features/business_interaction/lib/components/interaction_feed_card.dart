import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_account/utils/login_sheet_utils.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:lib_news_api/lib_news_api.dart';
import 'package:lib_widget/lib_widget.dart';
import 'package:module_share/model/share_model.dart';
import 'package:module_imagepreview/module_imagepreview.dart';
import 'package:module_imagepreview/advanced_customImage_viewer.dart';
import 'package:lib_account/viewmodels/login_vm.dart' as login_vm;
import 'package:lib_account/services/account_api.dart';
import 'package:module_share/views/Share.dart';
import '../constants/constants.dart';
import '../generated/assets.dart';
import '../viewmodels/interaction_view_model.dart';
import 'package:module_setfontsize/module_setfontsize.dart';

/// 互动信息流卡片组件（使用PostCard的布局）
class InteractionFeedCard extends StatefulWidget {
  /// 卡片信息
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

  /// 互动视图模型实例
  final InteractionViewModel interactionViewModel = InteractionViewModel();

  /// 文本是否展开
  bool _isExpanded = false;
  final int _maxLines = 3;

  @override
  void initState() {
    super.initState(); // 会自动初始化 settingInfo 并监听变化

    // 设置作者ID到互动视图模型中
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

  bool get _isFollowed {
    final authorId = widget.cardInfo.author?.authorId ?? '';
    final isLogin = userInfoModel.isLogin;
    final watchers = userInfoModel.watchers;
    final isFollowed = watchers.contains(authorId);

    return isLogin && isFollowed;
  }

  bool get _isSelf {
    return userInfoModel.authorId == widget.cardInfo.author?.authorId;
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
    // 鸿蒙主题蓝色
    const Color appThemeColor = Constants.appThemeColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        interactionViewModel.actionToNewsDetails(context, widget.cardInfo);
      },
      child: Container(
        padding: const EdgeInsets.all(Constants.SPACE_8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 作者信息
            Row(
              children: [
                CustomImage(
                  imageUrl: widget.cardInfo.author?.authorIcon ?? '',
                  width: Constants.SPACE_40,
                  height: Constants.SPACE_40,
                  borderRadius: BorderRadius.circular(Constants.SPACE_20),
                ),
                const SizedBox(width: Constants.SPACE_8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cardInfo.author?.authorNickName ?? '未知用户',
                        style: TextStyle(
                          fontSize:
                              Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
                          fontWeight: FontWeight.w500,
                          color: ThemeColors.getFontPrimary(
                              settingInfo.darkSwitch),
                        ),
                      ),
                      const SizedBox(height: Constants.SPACE_4),
                      Text(
                        TimeUtils.getDateDiff(widget.cardInfo.createTime),
                        style: TextStyle(
                            fontSize: Constants.FONT_12 *
                                FontScaleUtils.fontSizeRatio,
                            color: ThemeColors.getFontSecondary(
                                settingInfo.darkSwitch)),
                      ),
                    ],
                  ),
                ),
                // 如果是自己的帖子，不显示关注按钮
                if (!_isSelf)
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      interactionViewModel.watchOperation(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.SPACE_12,
                          vertical: Constants.SPACE_6),
                      decoration: BoxDecoration(
                        color: _isFollowed
                            ? ThemeColors.getBackgroundTertiary(
                                settingInfo.darkSwitch)
                            : appThemeColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        _isFollowed ? '已关注' : '关注',
                        style: TextStyle(
                          fontSize:
                              Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
                          color: _isFollowed ? appThemeColor : Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Constants.SPACE_12),
            if (widget.cardInfo.title != "") ...[
              // 内容（支持展开/收起）
              _buildTextContent(appThemeColor),
            ],
            // 图片和视频（从 postImgList 中区分）
            if (widget.cardInfo.postImgList != null &&
                widget.cardInfo.postImgList!.isNotEmpty) ...[
              const SizedBox(height: Constants.SPACE_8),
              _buildMediaContent(context, widget.cardInfo.postImgList!),
            ],

            // 视频
            if (widget.cardInfo.videoUrl != null) ...[
              const SizedBox(height: Constants.SPACE_8),
              _buildVideoThumbnail(widget.cardInfo.videoUrl!),
            ],

            const SizedBox(height: Constants.SPACE_12),

            // 操作栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 分享
                _buildSvgActionButton(
                  svgPath: Assets.assetsOpForward,
                  label: _formatCount(widget.cardInfo.shareCount),
                  color: ThemeColors.getFontSecondary(settingInfo.darkSwitch),
                  onTap: () => _handleShare(),
                ),
                // 评论
                _buildSvgActionButton(
                  svgPath: Assets.messageActiveImage,
                  label: _formatCount(widget.cardInfo.commentCount),
                  color: ThemeColors.getFontSecondary(settingInfo.darkSwitch),
                  onTap: () => _handleComment(),
                ),
                // 点赞
                _buildSvgActionButton(
                  svgPath: widget.cardInfo.isLiked
                      ? Assets.assetsLikeActive
                      : Assets.assetsLike,
                  label: _formatCount(widget.cardInfo.likeCount),
                  color: widget.cardInfo.isLiked
                      ? Colors.red
                      : ThemeColors.getFontSecondary(settingInfo.darkSwitch),
                  onTap: () => _handleLike(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleLike() {
    final loginVM = login_vm.LoginVM.getInstance();
    if (!loginVM.accountInstance.userInfoModel.isLogin) {
      LoginSheetUtils.showLoginSheet(context);
      return;
    }

    setState(() {
      widget.cardInfo.isLiked = !widget.cardInfo.isLiked;

      if (widget.cardInfo.isLiked) {
        CommentServiceApi.addPosterLike(widget.cardInfo.id);
        MineServiceApi.addLike(widget.cardInfo.id);
        widget.cardInfo.likeCount += 1;
      } else {
        CommentServiceApi.cancelPosterLike(widget.cardInfo.id);
        MineServiceApi.cancelLike(widget.cardInfo.id);
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

    Share.show(context, shareOptions, widget.cardInfo.title);
  }

  void _handleComment() {
    // 跳转到新闻详情页面，显示评论区域
    interactionViewModel.actionToNewsDetails(context, widget.cardInfo,
        needScrollToComment: true);
  }

  // 构建文字内容（支持展开/收起）
  Widget _buildTextContent(Color themeColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = TextStyle(
          fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
          fontWeight: FontWeight.w500,
          color: ThemeColors.getFontPrimary(settingInfo.darkSwitch),
          height: Constants.SPACE_1_5,
        );

        if (_isExpanded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.cardInfo.title, style: textStyle),
              Padding(
                padding: const EdgeInsets.only(top: Constants.SPACE_8),
                child: Text.rich(
                  TextSpan(
                    text: '收起',
                    style: TextStyle(
                        fontSize:
                            Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
                        color: themeColor,
                        fontWeight: FontWeight.w500),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() => _isExpanded = false);
                      },
                  ),
                ),
              ),
            ],
          );
        }

        final fullTextPainter = TextPainter(
          text: TextSpan(text: widget.cardInfo.title, style: textStyle),
          maxLines: _maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (!fullTextPainter.didExceedMaxLines) {
          return Text(widget.cardInfo.title, style: textStyle);
        }

        // 文本溢出，需要裁剪并显示"...全文"
        // 使用二分查找快速定位最佳裁剪点
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
          )..layout(maxWidth: constraints.maxWidth);

          if (testPainter.didExceedMaxLines) {
            right = mid - 1;
          } else {
            clippedText = testText;
            left = mid;
          }
        }

        return Text.rich(
          TextSpan(
            style: textStyle,
            children: [
              TextSpan(text: clippedText),
              TextSpan(
                text: '...全文',
                style: textStyle.copyWith(
                    color: themeColor, fontWeight: FontWeight.w500),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() => _isExpanded = true);
                  },
              ),
            ],
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

  // 构建媒体内容（区分图片和视频）
  Widget _buildMediaContent(BuildContext context, List<PostImgList> mediaList) {
    // 分离图片和视频
    final imageUrls = <String>[];
    final videos = <PostImgList>[];

    for (final media in mediaList) {
      // 通过 surfaceUrl 是否为空来判断
      if (media.surfaceUrl.isNotEmpty) {
        // surfaceUrl 有值 = 视频（surfaceUrl 是视频缩略图）
        videos.add(media);
      } else {
        // surfaceUrl 为空 = 图片
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

  // 构建图片网格
  Widget _buildImageGrid(BuildContext context, List<String> imageUrls) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    // 单图：显示完整图片（支持点击查看大图）
    if (imageUrls.length == 1) {
      final imageSize = _calculateImageSize(imageUrls[0]);

      return GestureDetector(
        onTap: () => _showImageViewer(context, imageUrls, 0),
        child: Hero(
          tag: 'image_${widget.cardInfo.id}_${widget.cardInfo.hashCode}_0',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Constants.SPACE_10),
            child: CustomImage(
              imageUrl: imageUrls[0],
              width: imageSize.width,
              height: imageSize.height,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    // 多图：网格布局（2/3列）
    final int crossAxisCount = imageUrls.length == 4 ? 2 : 3;
    final double imageSize = (MediaQuery.of(context).size.width -
            Constants.SPACE_32 -
            (crossAxisCount - 1) * 4) /
        crossAxisCount;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: Constants.SPACE_4,
        mainAxisSpacing: Constants.SPACE_4,
        childAspectRatio: 1.0,
      ),
      itemCount: imageUrls.length > 9 ? 9 : imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showImageViewer(context, imageUrls, index),
          child: Hero(
            tag:
                'image_${widget.cardInfo.id}_${widget.cardInfo.hashCode}_$index',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Constants.SPACE_10),
              child: CustomImage(
                imageUrl: imageUrls[index],
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  // 显示图片查看器
  void _showImageViewer(
      BuildContext context, List<String> imageUrls, int initialIndex) {
    final listContext = context;

    Navigator.push(
      context,
      ImagePreviewPageRoute(
        builder: (context) {
          final userInfo = AccountApi.getInstance().queryUserInfo();
          return AdvancedCustomImageViewer(
            imageProviders: imageUrls,
            initialIndex: initialIndex,
            authorId: widget.cardInfo.author?.authorId,
            authorIcon: widget.cardInfo.author?.authorIcon,
            authorNickName: widget.cardInfo.author?.authorNickName,
            createTime: widget.cardInfo.createTime,
            commentCount: widget.cardInfo.commentCount ?? 0,
            likeCount: widget.cardInfo.likeCount ?? 0,
            isLiked: widget.cardInfo.isLiked ?? false,
            shareCount: widget.cardInfo.shareCount ?? 0,
            isLogin: userInfo.isLogin,
            currentUserId: userInfo.authorId,
            heroTagPrefix:
                'image_${widget.cardInfo.id}_${widget.cardInfo.hashCode}',
            onWatchOperation: () {
              if (mounted) {
                interactionViewModel.watchOperation(listContext);
              }
            },
            onNewsLike: () {
              if (mounted) {
                _handleLike();
              }
            },
            onAddComment: () {
              if (mounted) {
                interactionViewModel.actionToNewsDetails(
                    listContext, widget.cardInfo,
                    needScrollToComment: true);
              }
            },
            onShare: () {
              if (mounted) {
                final shareOptions = ShareOptions(
                  id: widget.cardInfo.id,
                  title: widget.cardInfo.title,
                  articleFrom: widget.cardInfo.articleFrom ?? '',
                );
                Share.show(listContext, shareOptions, widget.cardInfo.title);
              }
            },
          );
        },
      ),
    );
  }

  // 构建视频缩略图（使用 PostImgList 对象，完全参考鸿蒙）
  Widget _buildVideoThumbnailWithCover(PostImgList video) {
    // 计算视频封面尺寸
    // 视频默认使用横屏尺寸：宽度 327，高度 327/1.5 ≈ 218
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
              borderRadius: BorderRadius.circular(Constants.SPACE_12),
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
                                size: Constants.SPACE_60,
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
                        size: Constants.SPACE_60,
                        color: Colors.grey,
                      ),
                    ),
            ),
            // 播放按钮
            Container(
              width: Constants.SPACE_36,
              height: Constants.SPACE_36,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: Constants.SPACE_24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建视频缩略图
  Widget _buildVideoThumbnail(String videoUrl) {
    return GestureDetector(
      onTap: () {
        interactionViewModel.actionToNewsDetails(context, widget.cardInfo);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Constants.SPACE_8),
            child: CustomImage(
              imageUrl: widget.cardInfo.postImgList?.isNotEmpty == true
                  ? widget.cardInfo.postImgList!.first.surfaceUrl
                  : '',
              width: double.infinity,
              height: Constants.SPACE_200,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: Constants.SPACE_60,
            height: Constants.SPACE_60,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: Constants.SPACE_40,
            ),
          ),
        ],
      ),
    );
  }

  // 构建SVG操作按钮
  Widget _buildSvgActionButton({
    required String svgPath,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgPath,
            package: Constants.packageName,
            width: Constants.SPACE_20,
            height: Constants.SPACE_20,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(width: Constants.SPACE_4),
          Text(
            label,
            style: TextStyle(
              fontSize: Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // 格式化数量
  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}w';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
