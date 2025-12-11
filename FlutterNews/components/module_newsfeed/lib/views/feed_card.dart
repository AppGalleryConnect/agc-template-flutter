import 'package:flutter/material.dart';
import 'package:lib_common/models/userInfo_model.dart';
import 'package:video_player/video_player.dart';
import '../components/feed_detail.dart';
import '../model/recommend_model.dart';
import '../utils/utils.dart';
import 'package:module_newsfeed/constants/constants.dart';

class FeedCard extends StatefulWidget {
  final FeedCardInfo feedCardInfo;
  final String componentId;
  final int index;
  final double fontSizeRatio;
  final bool isDark;
  final bool isAll;
  final bool isNeedOperation;
  final bool showUserBar;
  final bool showTimeBottom;
  final String searchKey;
  final bool isNeedFollow;
  final Widget Function() shareBuilder;
  final VoidCallback onArticle;
  final VoidCallback onVideo;
  final VoidCallback onWatch;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final Function(String) onGoUserInfo;

  const FeedCard({
    super.key,
    required this.feedCardInfo,
    required this.componentId,
    this.index = 0,
    this.fontSizeRatio = 1.0,
    this.isDark = false,
    this.isAll = false,
    this.isNeedOperation = true,
    this.showUserBar = true,
    this.showTimeBottom = false,
    this.searchKey = '',
    this.isNeedFollow = false,
    required this.shareBuilder,
    required this.onArticle,
    required this.onVideo,
    required this.onWatch,
    required this.onLike,
    required this.onComment,
    required this.onGoUserInfo,
  });

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  late UserInfoModel userInfoModel;
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    userInfoModel = UserInfoModel();
    videoController = VideoPlayerController.networkUrl(Uri());
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  bool get isWatched {
    return userInfoModel.isLogin &&
        userInfoModel.watchers.contains(widget.feedCardInfo.author.authorId);
  }

  bool get isFeedSelf {
    return userInfoModel.authorId == widget.feedCardInfo.author.authorId;
  }

  Widget _publishTimeBuilder() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        getDateDiff(widget.feedCardInfo.createTime),
        style: TextStyle(
          fontSize: Constants.FONT_12 * widget.fontSizeRatio,
          color: Constants.PUBLISH_TEXT_COLOR,
        ),
      ),
    );
  }

  // 关注按钮组件
  Widget _followBuilder() {
    return Visibility(
      visible: !widget.isNeedFollow && !isFeedSelf,
      child: GestureDetector(
        onTap: widget.onWatch,
        child: Container(
          padding: const EdgeInsets.fromLTRB(Constants.SPACE_12, Constants.SPACE_6, Constants.SPACE_12, Constants.SPACE_6),
          decoration: BoxDecoration(
            color: isWatched
                ? Constants.WATCH_COLOR
                : Theme.of(context).primaryColor, 
            borderRadius: BorderRadius.circular(Constants.SPACE_14),
          ),
          child: Text(
            isWatched ? '已关注' : '关注',
            style: TextStyle(
              fontSize: Constants.FONT_14 * widget.fontSizeRatio,
              color: isWatched
                  ? Theme.of(context).primaryColor
                  : Colors.white, 
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeedDetail(
          componentId: widget.componentId,
          curFeedCardInfo: widget.feedCardInfo,
          fontSizeRatio: widget.fontSizeRatio,
          isWatch: isWatched,
          isFeedSelf: isFeedSelf,
          isDynamicsSingleDetail: false,
          isAll: widget.isAll,
          searchKey: widget.searchKey,
          showUserBar: widget.showUserBar,
          showTimeBottom: widget.showTimeBottom,
          followBuilderParam: _followBuilder,
          onVideo: widget.onVideo,
          publishCustomTimeBuilder: _publishTimeBuilder,
          onGoUserInfo: widget.onGoUserInfo,
          onAddWatch: widget.onWatch,
          onAddLike: widget.onLike,
          onAddComment: widget.onComment,
        ),
      ],
    );
  }
}
