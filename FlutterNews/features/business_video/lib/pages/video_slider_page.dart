import 'package:business_video/views/video_sheet.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_account/services/account_api.dart';
import 'package:lib_news_api/services/base_news_service.dart';
import 'package:lib_news_api/services/mine_service.dart';
import 'package:module_swipeplayer/module_swipeplayer.dart';
import 'package:business_video/services/video_services.dart';
import 'package:business_video/models/video_model.dart';
import 'package:business_video/types/page_type.dart';
import 'package:lib_common/lib_common.dart';
import 'package:business_video/models/video_enevtbus.dart';
import 'package:module_newsfeed/components/comment_list.dart';
import 'package:lib_news_api/params/response/comment_response.dart';
import 'package:lib_news_api/params/request/common_request.dart';
import 'package:module_flutter_feedcomment/utils/utils.dart';
import '../constants/constants.dart';

class VideoSliderPage extends StatefulWidget {
  final bool isVideo;
  final PageType type;
  final SettingModel settingInfo;
  final VideoNewsData? videoInfo;
  final Function(Duration duation)? onDuation;
  final bool isCommend;
  final Function(bool isCommend)? onCommend;

  const VideoSliderPage({
    super.key,
    this.isVideo = false,
    required this.type,
    required this.settingInfo,
    this.videoInfo,
    this.onDuation,
    this.isCommend = false,
    this.onCommend,
  });

  @override
  State<VideoSliderPage> createState() => _VideoSliderPageState();
}

class _VideoSliderPageState extends State<VideoSliderPage>
    implements MarkLikeObserver {
  final PageController _pageController = PageController();
  final EasyRefreshController _controller = EasyRefreshController();

  int _currentPageIndex = 0;
  List<VideoNewsData> _videoList = [];
  bool _canPlayVideo = true;
  bool _isInitialized = false;

  late final VoidCallback _listener;
  UserInfoModel userInfoModel = AccountApi.getInstance().userInfoModel;

  @override
  void initState() {
    super.initState();

    if (widget.type == PageType.RECOMMEND && widget.videoInfo != null) {
      _videoList.add(widget.videoInfo as VideoNewsData);
    }

    _listener = () {
      setState(() {});
    };

    userInfoModel.addListener(_listener);
    MineServiceApi.addObserver(this);
    request();
    if (_videoList.isNotEmpty) {
      MineService().addToHistory(_videoList[0].id);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkNetworkForInitialPlay();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    userInfoModel.removeListener(_listener);
    MineServiceApi.removeObserver(this);
    _controller.dispose();
    _pageController.dispose();
  }

  @override
  void onMarkLikeUpdated(MarkLikeUpdateType type) {
    if (type == MarkLikeUpdateType.Like ||
        type == MarkLikeUpdateType.Mark ||
        type == MarkLikeUpdateType.All) {
      setState(() {
        for (int i = 0; i < _videoList.length; i++) {
          final news = BaseNewsServiceApi.queryRawNews(_videoList[i].id);
          if (news != null) {
            _videoList[i].isLiked = news.isLiked ?? false;
            _videoList[i].likeCount = news.likeCount ?? 0;
            _videoList[i].isMarked = news.isMarked ?? false;
            _videoList[i].markCount = news.markCount ?? 0;
          }
        }
      });
    }
  }

  void request() {
    List<VideoNewsData> list = [];
    if (widget.type == PageType.FOLLOW) {
      list = VideoService.queryFollowedUserVideoList(userInfoModel.authorId);
    } else {
      list = VideoService.queryVideoList();
    }
    setState(() {
      _videoList += list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              height: widget.isCommend
                  ? MediaQuery.of(context).size.height * 0.3
                  : MediaQuery.of(context).size.height,
              color: Colors.black,
              child:
                  widget.type == PageType.RECOMMEND && widget.videoInfo != null
                      ? _buildvideoListWidget()
                      : _buildReloadWidget(),
            ),
            if (widget.isCommend)
              const SizedBox(
                height: Constants.SPACE_30,
              ),
            if (widget.isCommend) _showCommondSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildReloadWidget() {
    return EasyRefresh(
      controller: _controller,
      header: const MaterialHeader(),
      onRefresh: _onRefresh,
      child: _buildvideoListWidget(),
    );
  }

  // 下拉刷新回调
  Future<void> _onRefresh() async {
    eventBus.fire(ShowTabbarEvent(true));
    await Future.delayed(const Duration(seconds: 1));
    _videoList.clear();
    if (widget.type == PageType.FOLLOW) {
      _videoList =
          VideoService.queryFollowedUserVideoList(userInfoModel.authorId);
    } else {
      _videoList = VideoService.queryVideoList();
    }
    setState(() {
      _pageController.jumpToPage(0);
      MineService().addToHistory(_videoList[0].id);
    });
    _controller.finishRefresh();
  }

  Widget _buildvideoListWidget() {
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.portrait;
    return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _videoList.length,
        allowImplicitScrolling: true,
        physics: isLandscape && !widget.isCommend
            ? const ScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) => {_handlePageChanged(index)},
        itemBuilder: (context, index) => VideoPage(
              isCommend: widget.isCommend,
              videoModel: _getVideoModel(index),
              canPlayVideo: index == _currentPageIndex &&
                  widget.isVideo &&
                  ModalRoute.of(context)!.isCurrent &&
                  _canPlayVideo,
              onTap: (isPlaying) => {
                if (widget.type == PageType.FOLLOW ||
                    widget.type == PageType.FEATURED)
                  {
                    eventBus.fire(ShowTabbarEvent(!isPlaying)),
                  }
              },
              onClick: () => {
                RouterUtils.of.pushPathByName(RouterMap.PROFILE_HOME,
                    param: _videoList[index].author!.authorId),
              },
              onFollow: (isFollow) => {
                if (!userInfoModel.isLogin)
                  {VideoSheet.showLoginSheet(context)}
                else
                  {
                    if (_getVideoModel(index).isFollow)
                      {
                        userInfoModel
                            .removeWatcher(_videoList[index].author!.authorId),
                        MineServiceApi.cancelWatch(
                            _videoList[index].author!.authorId),
                      }
                    else
                      {
                        userInfoModel
                            .addWatcher(_videoList[index].author!.authorId),
                        MineServiceApi.addWatch(
                            _videoList[index].author!.authorId),
                      }
                  }
              },
              onLike: (isLike) => {
                setState(() {
                  if (!userInfoModel.isLogin) {
                    VideoSheet.showLoginSheet(context);
                  } else {
                    VideoNewsData model = _videoList[index];
                    model.isLiked = !model.isLiked;
                    if (model.isLiked) {
                      MineServiceApi.addLike(model.id);
                      model.likeCount++;
                    } else {
                      MineServiceApi.cancelLike(model.id);
                      model.likeCount--;
                    }
                    _videoList[index] = model;
                  }
                })
              },
              onCommond: (bool isFromBottom) => {
                if (!userInfoModel.isLogin)
                  {
                    VideoSheet.showLoginSheet(context),
                  }
                else
                  {
                    if (widget.onCommend != null)
                      {
                        widget.onCommend!(true),
                        eventBus.fire(IsCommendEvent(true)),
                        if (isFromBottom)
                          showCommond(_currentPageIndex, '', ''),
                      }
                  }
              },
              onCollect: (isCollect) => {
                setState(() {
                  if (!userInfoModel.isLogin) {
                    VideoSheet.showLoginSheet(context);
                  } else {
                    VideoNewsData model = _videoList[index];
                    model.isMarked = !model.isMarked;
                    if (model.isMarked) {
                      MineServiceApi.addMark(model.id);
                      model.markCount++;
                    } else {
                      MineServiceApi.cancelMark(model.id);
                      model.markCount--;
                    }
                    _videoList[index] = model;
                  }
                })
              },
              onShare: () => {
                VideoSheet.showShareSheet(context, _videoList[index].title),
              },
              onFinish: () => {
                setState(() {
                  if (widget.settingInfo.network.autoPlayNext &&
                      _currentPageIndex < _videoList.length - 1) {
                    _pageController.jumpToPage(_currentPageIndex + 1);
                  }
                })
              },
              onSlider: (duration) => {
                if (index == 0 && widget.onDuation != null)
                  {
                    widget.onDuation!(duration),
                  }
              },
              onCommendChange: () => {
                if (widget.onCommend != null)
                  {
                    widget.onCommend!(false),
                    eventBus.fire(IsCommendEvent(false)),
                  }
              },
            ));
  }

  void _checkNetworkForInitialPlay() {
    if (widget.isVideo && _videoList.isNotEmpty) {
      setState(() {
        _canPlayVideo = true;
        _isInitialized = true;
      });
    }
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
      _canPlayVideo = true;
      if (index == _videoList.length - 1) request();
      MineService().addToHistory(_videoList[index].id);
    });
  }

  VideoModel _getVideoModel(int index) {
    VideoModel model = VideoModel.fromJson(_videoList[index].toJson());
    model.isFollow =
        userInfoModel.watchers.contains(_videoList[index].author!.authorId);
    model.authorIcon = _videoList[index].author!.authorIcon;
    model.author = _videoList[index].author!.authorNickName;
    model.currentDuration = _videoList[index].currentDuration;

    _videoList[index].comments = VideoService.getComments(_videoList[index].id);
    _videoList[index].commentCount = _videoList[index].comments.length;
    model.commentCount = _videoList[index].commentCount;

    if (_videoList[index].comments.isNotEmpty) {
      for (CommentResponse comment in _videoList[index].comments) {
        if (comment.author!.authorId == userInfoModel.authorId) {
          comment.author!.authorIcon = userInfoModel.authorIcon;
        }
      }
    }

    final newModel = VideoService.queryVideoDataById(_videoList[index].id);
    if (newModel != null) {
      model.isLike = newModel.isLiked;
      model.likeCount = newModel.likeCount;
      model.isCollect = newModel.isMarked;
      model.collectCount = newModel.markCount;
      model.authorIcon = newModel.author!.authorIcon;
    }

    if (widget.type == PageType.FEATURED) {
      if (model.id == 'video1' || model.id == 'video2') {
        model.videoType = VideoEnum.Live;
      } else if (model.id == 'video3' || model.id == 'video4') {
        model.videoType = VideoEnum.Ad;
      }
    }

    return model;
  }

  Widget _showCommondSheet() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(Constants.SPACE_20),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7 - Constants.SPACE_30,
        color: widget.settingInfo.darkSwitch ? Colors.black : Colors.white,
        child: Column(
          children: [
            Container(
              height: Constants.SPACE_50,
              padding: const EdgeInsets.only(
                  left: Constants.SPACE_10,
                  right: Constants.SPACE_10,
                  top: Constants.SPACE_10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_videoList[_currentPageIndex].commentCount}条评论',
                    style: TextStyle(
                        fontSize: Constants.FONT_20,
                        fontWeight: FontWeight.bold,
                        color: widget.settingInfo.darkSwitch
                            ? Colors.white
                            : Colors.black),
                  ),
                  _backButton(context)
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: CommentList(
                  commentResponse: _videoList[_currentPageIndex].comments,
                  onPullUpKeyboard: () =>
                      {showCommond(_currentPageIndex, '', '')},
                  showInteractiveButtons: true,
                  onReplyToComment: (
                      {required CommentResponse targetComment,
                      CommentResponse? targetReply}) {
                    showCommond(
                        _currentPageIndex,
                        targetReply!.author!.authorNickName,
                        targetComment.commentId);
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {showCommond(_currentPageIndex, '', '')},
              child: Container(
                height: Constants.SPACE_40,
                width: MediaQuery.of(context).size.width - Constants.SPACE_40,
                padding: const EdgeInsets.all(Constants.SPACE_10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Constants.SPACE_24),
                  border: Border.all(
                      color: Colors.black12, width: Constants.SPACE_1),
                  color: widget.settingInfo.darkSwitch
                      ? Colors.grey[800]
                      : Colors.grey[200],
                ),
                child: Text(
                  '发表评论',
                  style: TextStyle(
                      color: widget.settingInfo.darkSwitch
                          ? Colors.white
                          : Colors.black,
                      fontSize: Constants.FONT_16),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
    );
  }

  void showCommond(int index, String title, String commendId) {
    commentSheetOpen(
      context,
      title,
      (content) {
        PublishCommentRequest params = PublishCommentRequest(
            newsId: _videoList[index].id,
            content: content,
            parentCommentId: commendId);
        MineServiceApi.publishComment(params).then((value) {
          setState(() {
            if (title.isEmpty) {
              _videoList[index].commentCount++;
              _videoList[index].comments.add(value);
            } else {
              for (int i = 0; i < _videoList[index].comments.length; i++) {
                if (_videoList[index].comments[i].commentId == commendId) {
                  _videoList[index].comments[i].replyComments.add(value);
                }
              }
            }
          });
        });
      },
      false,
    );
  }

  Widget _backButton(BuildContext context) {
    return Container(
      width: Constants.SPACE_30,
      height: Constants.SPACE_30,
      decoration: BoxDecoration(
        color: widget.settingInfo.darkSwitch
            ? Colors.grey[800]
            : Constants.backButtonColor,
        borderRadius: BorderRadius.circular(Constants.SPACE_25),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: IconButton(
        padding: const EdgeInsets.all(Constants.SPACE_9),
        icon: SvgPicture.asset(
          Constants.deleteImage,
          width: Constants.SPACE_15,
          height: Constants.SPACE_15,
          colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary, BlendMode.srcIn),
          fit: BoxFit.contain,
        ),
        onPressed: () {
          if (widget.onCommend != null) {
            widget.onCommend!(false);
            eventBus.fire(IsCommendEvent(false));
          }
        },
      ),
    );
  }
}
