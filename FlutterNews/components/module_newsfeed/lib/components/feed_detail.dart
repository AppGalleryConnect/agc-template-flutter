import 'package:flutter/material.dart';
import 'package:lib_common/models/userInfo_model.dart';
import '../model/recommend_model.dart';
import '../utils/utils.dart';
import 'article_text_elipsis.dart';
import 'feed_singleImage_size.dart';
import 'package:module_newsfeed/constants/constants.dart';

class FeedDetail extends StatefulWidget {
  final String componentId;
  final FeedCardInfo curFeedCardInfo;
  final bool isDynamicsSingleDetail;
  final bool isAll;
  final double fontSizeRatio;
  final String searchKey;
  final bool showUserBar;
  final bool showTimeBottom;
  final bool isWatch;
  final bool isFeedSelf;
  final Widget Function() followBuilderParam;
  final Widget Function() publishCustomTimeBuilder;
  final Function(String) onGoUserInfo;
  final VoidCallback onAddWatch;
  final VoidCallback onAddLike;
  final VoidCallback onAddComment;
  final VoidCallback onVideo;
  final bool isNewsDetail;

  const FeedDetail({
    super.key,
    required this.componentId,
    required this.curFeedCardInfo,
    required this.isDynamicsSingleDetail,
    this.isAll = false,
    this.fontSizeRatio = 1.0,
    this.searchKey = '',
    this.showUserBar = true,
    this.showTimeBottom = false,
    this.isWatch = false,
    this.isFeedSelf = false,
    this.isNewsDetail = false,
    required this.followBuilderParam,
    required this.publishCustomTimeBuilder,
    required this.onGoUserInfo,
    required this.onAddWatch,
    required this.onAddLike,
    required this.onAddComment,
    required this.onVideo,
  });

  @override
  State<FeedDetail> createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  late UserInfoModel userInfoModel;
  List<String> imageList = [];
  List<Size> imageSizes = []; 
  double gridImageSize = 0; 

  String get _authorIcon => widget.isFeedSelf
      ? userInfoModel.authorIcon
      : widget.curFeedCardInfo.author.authorIcon;

  String get _authorName => widget.isFeedSelf
      ? userInfoModel.authorNickName
      : widget.curFeedCardInfo.author.authorNickName;

  bool get _hasAdditionalContent =>
      !widget.isNewsDetail &&
      (widget.curFeedCardInfo.richContent?.isNotEmpty ?? false);

  @override
  void initState() {
    super.initState();
    userInfoModel = UserInfoModel();
    _initImageList();
  }

  @override
  void didUpdateWidget(covariant FeedDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.curFeedCardInfo != oldWidget.curFeedCardInfo) {
      _initImageList();
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _calculateImageSizes());
    }
  }

  void _initImageList() {
    imageList = widget.curFeedCardInfo.postMedias
        .map((media) =>
            media.thumbnailUrl.isNotEmpty ? media.thumbnailUrl : media.url)
        .toList();

    imageSizes = List.generate(imageList.length, (index) => Size.zero);
  }

  void _calculateImageSizes() {
    if (imageList.isEmpty) return;

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width - Constants.SPACE_32;

    if (imageList.length == 1) {
      final media = widget.curFeedCardInfo.postMedias.first;
      final imageUrl =
          media.thumbnailUrl.isNotEmpty ? media.thumbnailUrl : media.url;
      final size = calculateDimensions(imageUrl);

      final scaleRatio =
          size.width > screenWidth ? screenWidth / size.width : 1.0;

      setState(() {
        imageSizes[0] = Size(size.width * scaleRatio, size.height * scaleRatio);
      });
    } else {
      setState(() {
        if (imageList.length <= 3) {
          gridImageSize =
              (screenWidth - (imageList.length - 1) * 4) / imageList.length;
        } else {
          gridImageSize = (screenWidth - 4) / 2; 
        }

        for (int i = 0; i < imageSizes.length; i++) {
          imageSizes[i] = Size(gridImageSize, gridImageSize);
        }
      });
    }
  }

  Widget _defaultPublishTimeBuilder() {
    if (!widget.isDynamicsSingleDetail) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        getDateDiff(widget.curFeedCardInfo.createTime),
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodySmall?.fontSize ?? 12,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }

  Widget _buildAdditionalContent() {
    if (!_hasAdditionalContent) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: Constants.SPACE_8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            widget.curFeedCardInfo.richContent!.split('\n').map((content) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Constants.SPACE_8),
            child: ArticleTextEllipsis(
              text: content,
              fontSizeRatio: widget.fontSizeRatio * 0.9, 
              enableExpand: widget.isAll,
              searchKey: widget.searchKey,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (widget.curFeedCardInfo.postMedias.isEmpty) {
      return const SizedBox.shrink();
    }

    if (imageList.length == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Constants.SPACE_12),
        child: _buildImageItem(0),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constants.SPACE_12),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: imageList.length <= 3 ? imageList.length : 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1.0,
        children:
            List.generate(imageList.length, (index) => _buildImageItem(index)),
      ),
    );
  }

  Widget _buildImageItem(int index) {
    final media = widget.curFeedCardInfo.postMedias[index];
    return FeedSingleImageSize(
      fontSizeRatio: widget.fontSizeRatio,
      componentId: widget.componentId,
      isWatch: widget.isWatch,
      isFeedSelf: widget.isFeedSelf,
      imageWidth: imageSizes[index].width,
      imageHeight: imageSizes[index].height,
      curFeedCardInfo: widget.curFeedCardInfo,
      postImgListItem: media,
      imageList: imageList,
      index: index,
      onAddWatch: widget.onAddWatch,
      onAddLike: widget.onAddLike,
      onAddComment: widget.onAddComment,
      onVideo: widget.onVideo,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateImageSizes());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 作者信息栏（显示/隐藏控制）
          Visibility(
            visible: widget.showUserBar,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Constants.SPACE_12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 作者头像 + 昵称 + 时间
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 作者头像（带圆形裁剪）
                        GestureDetector(
                          onTap: () => widget.onGoUserInfo(
                              widget.curFeedCardInfo.author.authorId),
                          child: ClipOval(
                            child: Image.network(
                              _authorIcon.isNotEmpty
                                  ? _authorIcon
                                  : Constants.iconDefaultImage,
                              width: Constants.SPACE_40,
                              height: Constants.SPACE_40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                Constants.iconDefaultImage,
                                width: Constants.SPACE_40,
                                height: Constants.SPACE_40,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Constants.SPACE_8),
                        // 昵称 + 时间
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 作者昵称
                            Text(
                              _authorName,
                              style: TextStyle(
                                fontSize: Constants.FONT_14 * widget.fontSizeRatio,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                            // 发布时间（优先自定义builder，否则用默认）
                            widget.publishCustomTimeBuilder() ??
                                _defaultPublishTimeBuilder(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 关注按钮（外部传入的builder）
                  widget.followBuilderParam(),
                ],
              ),
            ),
          ),

          // 2. 动态文本内容（文章标题/动态内容）
          ArticleTextEllipsis(
            text: widget.curFeedCardInfo.title,
            fontSizeRatio: widget.fontSizeRatio,
            enableExpand: widget.isAll,
            searchKey: widget.searchKey,
          ),

          // 3. 图片/视频列表
          _buildImageGrid(),

          // 4. 附加内容（仅在非新闻详情且有内容时显示）
          _buildAdditionalContent(),

          // 5. 底部时间（显示/隐藏控制）
          Visibility(
            visible: widget.showTimeBottom,
            child: Padding(
              padding: const EdgeInsets.only(top: Constants.SPACE_8, bottom: Constants.SPACE_12),
              child: Text(
                getDateDiff(widget.curFeedCardInfo.createTime),
                style: TextStyle(
                  fontSize: Constants.FONT_12 * widget.fontSizeRatio,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
