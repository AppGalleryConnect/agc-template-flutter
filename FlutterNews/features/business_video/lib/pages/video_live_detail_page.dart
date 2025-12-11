import 'dart:io';
import 'package:business_video/models/video_model.dart';
import 'package:business_video/services/video_services.dart';
import 'package:lib_news_api/services/base_news_service.dart';
import 'package:lib_news_api/services/mine_service.dart';
import 'package:business_video/views/video_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_account/services/account_api.dart';
import 'package:module_flutter_channeledit/components/custom_tab_bar.dart';
import 'package:module_imagepreview/advanced_customImage_viewer.dart';
import 'package:module_swipeplayer/model/video_model.dart';
import 'package:module_swipeplayer/views/live_view.dart';
import 'package:lib_news_api/params/response/comment_response.dart';
import 'package:lib_news_api/params/request/common_request.dart';
import 'package:lib_common/lib_common.dart';
import 'package:module_flutter_feedcomment/utils/utils.dart';
import '../constants/constants.dart';

class VideoLiveDetailPage extends StatefulWidget {
  const VideoLiveDetailPage({
    super.key,
  });

  @override
  State<VideoLiveDetailPage> createState() => _VideoLiveDetailPageState();
}

class _VideoLiveDetailPageState extends State<VideoLiveDetailPage>
    implements MarkLikeObserver {
  final ScrollController listScroller = ScrollController();
  final PageController pageController = PageController();
  final TextEditingController commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int currentIndex = 0;

  late VideoNewsData model;
  bool isLive = true;
  late SettingModel settingInfo;
  List<VideoNewsData> introduceList = [];

  late final VoidCallback _listener;
  UserInfoModel userInfoModel = AccountApi.getInstance().userInfoModel;

  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();

    _listener = () {
      setState(() {});
    };

    userInfoModel.addListener(_listener);
    MineServiceApi.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    listScroller.dispose();
    pageController.dispose();
    commentController.dispose();
    _scrollController.dispose();
    userInfoModel.removeListener(_listener);
    MineServiceApi.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    List args = ModalRoute.of(context)?.settings.arguments as List;
    model = args[0] as VideoNewsData;
    isLive = args[1] as bool;
    settingInfo = args[2] as SettingModel;

    if (introduceList.isEmpty) {
      List<VideoNewsData> tempList =
          VideoService.queryLiveIntroduceList(model.author!.authorId);
      if (tempList.isEmpty) {
        tempList = VideoService.queryLiveIntroduceList('author_5');
      }
      introduceList = tempList;
      if (introduceList.isNotEmpty) {
        for (VideoNewsData introduce in introduceList) {
          if (introduce.author!.authorId == userInfoModel.authorId) {
            introduce.author!.authorIcon = userInfoModel.authorIcon;
          }
        }
      }

      model.comments = VideoService.getComments(model.id);
      model.commentCount = model.comments.length;

      if (model.comments.isNotEmpty) {
        for (CommentResponse comment in model.comments) {
          if (comment.author!.authorId == userInfoModel.authorId) {
            comment.author!.authorIcon = userInfoModel.authorIcon;
          }
        }
      }
    }
    final newModel = VideoService.queryVideoDataById(model.id);
    if (newModel != null) {
      model.isLiked = newModel.isLiked;
      model.likeCount = newModel.likeCount;
    }

    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom -
        Constants.SPACE_40 -
        Constants.SPACE_60 -
        MediaQuery.of(context).padding.top -
        Constants.SPACE_200 -
        Constants.SPACE_44;

    return Scaffold(
        body: Column(
      children: [
        if (!isFullScreen)
          Container(
            color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
            height: MediaQuery.of(context).padding.top,
          ),
        if (!isFullScreen)
          Container(
            color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
            height: Constants.SPACE_44,
            width: MediaQuery.of(context).size.width,
            child: _buildTitleViewWidge(),
          ),
        SizedBox(
          height: !isFullScreen
              ? Constants.SPACE_200
              : MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              LiveView(
                videoModel: VideoModel.fromJson(model.toJson()),
                onFullScreen: (value) {
                  setState(() {
                    isFullScreen = value;
                  });
                },
              ),
              if (!isFullScreen)
                Positioned(
                  top: Constants.SPACE_10,
                  left: Constants.SPACE_20,
                  height: Constants.SPACE_30,
                  child: Row(
                    children: [
                      if (isLive)
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                                Radius.circular(Constants.SPACE_5)),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: Constants.SPACE_5,
                              ),
                              SvgPicture.asset(
                                Constants.icLiveImage,
                                width: Constants.SPACE_12,
                                height: Constants.SPACE_12,
                              ),
                              const Text(
                                '直播中',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Constants.FONT_10),
                              ),
                              const SizedBox(
                                width: Constants.SPACE_5,
                              ),
                            ],
                          ),
                        ),
                      if (isLive)
                        const SizedBox(
                          width: Constants.SPACE_10,
                        ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                              Radius.circular(Constants.SPACE_5)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: Constants.SPACE_5,
                            ),
                            if (!isLive)
                              SvgPicture.asset(
                                Constants.icPlaybackImage,
                                width: Constants.SPACE_12,
                                height: Constants.SPACE_12,
                              ),
                            Text(
                              isLive ? '2078人观看' : '精彩回顾',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: Constants.FONT_10),
                            ),
                            const SizedBox(
                              width: Constants.SPACE_5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
        Offstage(
          offstage: isFullScreen,
          child: Container(
            color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
            child: CustomTabBar(
              listScroller: listScroller,
              myChannels: Constants.channelsList,
              fontSizeRatio: 1,
              currentIndex: currentIndex,
              onIndexChange: (index, item) {
                setState(() {
                  currentIndex = index;
                  pageController.jumpToPage(index);
                });
              },
              isShowEdit: true,
              index: 0,
              isDark: settingInfo.darkSwitch,
            ),
          ),
        ),
        Offstage(
          offstage: isFullScreen,
          child: SizedBox(
            height: height < 0 ? Constants.SPACE_200 : height,
            child: _buildInfoViewWidget(),
          ),
        ),
        Offstage(
          offstage: isFullScreen,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: Constants.SPACE_40,
            color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
            padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_20),
            child: _buildBottomWidget(),
          ),
        ),
        Offstage(
          offstage: isFullScreen,
          child: Container(
            height: MediaQuery.of(context).padding.bottom,
            color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
          ),
        ),
      ],
    ));
  }

  Widget _buildTitleViewWidge() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        Expanded(
          child: Text(
            model.title,
            style: TextStyle(
              fontSize: Constants.SPACE_20,
              color: settingInfo.darkSwitch ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Widget _buildInfoViewWidget() {
    return PageView(
      controller: pageController,
      allowImplicitScrolling: true,
      onPageChanged: (index) => {
        setState(() {
          currentIndex = index;
        })
      },
      children: [
        Container(
            color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
            child: _buildIntroduceViewWidget()),
        Container(
          color: ThemeColors.getBackgroundSecondary(settingInfo.darkSwitch),
          child: _buildCommentViewWidget(),
        ),
      ],
    );
  }

  Widget _buildIntroduceViewWidget() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      controller: _scrollController,
      itemCount: introduceList.length,
      cacheExtent: 0,
      itemBuilder: (context, index) {
        return Column(children: [
          SizedBox(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.SPACE_20),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Constants.SPACE_5),
                        child: introduceList[index]
                                .author!
                                .authorIcon
                                .contains('http')
                            ? Image.network(
                                introduceList[index].author!.authorIcon,
                                fit: BoxFit.cover,
                                width: Constants.SPACE_20,
                                height: Constants.SPACE_20,
                              )
                            : Image.file(
                                File(introduceList[index].author!.authorIcon),
                                fit: BoxFit.cover,
                                width: Constants.SPACE_20,
                                height: Constants.SPACE_20,
                              ),
                      ),
                      const SizedBox(width: Constants.SPACE_5),
                      Text(
                        introduceList[index].author!.authorNickName,
                        style: TextStyle(
                            fontSize: Constants.FONT_14,
                            color: settingInfo.darkSwitch
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Constants.SPACE_5),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.SPACE_45),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    introduceList[index].title,
                    style: TextStyle(
                      fontSize: Constants.FONT_16 * settingInfo.fontSizeRatio,
                      fontWeight: FontWeight.w700,
                      color:
                          settingInfo.darkSwitch ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Constants.SPACE_5),
          if (introduceList[index].postImgList!.isNotEmpty)
            Row(
              children: [
                const SizedBox(width: Constants.SPACE_40),
                SizedBox(
                  width: Constants.SPACE_150,
                  height: Constants.SPACE_200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Constants.SPACE_20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          ImagePreviewPageRoute(
                            builder: (context) => AdvancedCustomImageViewer(
                              imageProviders: [
                                introduceList[index].postImgList![0].picVideoUrl
                              ],
                              initialIndex: 0,
                            ),
                          ),
                        );
                      },
                      child: Image.network(
                        introduceList[index].postImgList![0].picVideoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: Constants.SPACE_5),
        ]);
      },
    );
  }

  Widget _buildCommentViewWidget() {
    return model.comments.isEmpty
        ? Center(
            child: Text(
              '还没有人评论，快来抢沙发吧',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Constants.FONT_16,
                  color: settingInfo.darkSwitch ? Colors.white : Colors.black),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.zero,
            controller: _scrollController,
            itemCount: model.comments.length,
            cacheExtent: 0,
            itemBuilder: (context, index) {
              CommentResponse comment = model.comments[index];
              return SizedBox(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width -
                          Constants.SPACE_40,
                      padding: const EdgeInsets.all(Constants.SPACE_5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Constants.SPACE_24),
                        border: Border.all(
                            color: Colors.black12, width: Constants.SPACE_1),
                        color: settingInfo.darkSwitch
                            ? Colors.grey[800]
                            : Colors.grey[200],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: Constants.SPACE_5,
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Constants.SPACE_8),
                            child: comment.author!.authorIcon.contains('http')
                                ? Image.network(
                                    comment.author!.authorIcon,
                                    fit: BoxFit.cover,
                                    width: Constants.SPACE_20,
                                    height: Constants.SPACE_20,
                                  )
                                : Image.file(
                                    File(comment.author!.authorIcon),
                                    fit: BoxFit.cover,
                                    width: Constants.SPACE_20,
                                    height: Constants.SPACE_20,
                                  ),
                          ),
                          const SizedBox(
                            width: Constants.SPACE_5,
                          ),
                          Expanded(
                            child: Text(
                              '${comment.author!.authorNickName} ${comment.commentBody}',
                              style: TextStyle(
                                fontSize: Constants.FONT_14,
                                color: settingInfo.darkSwitch
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(
                            width: Constants.SPACE_5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: Constants.SPACE_15,
                    ),
                  ],
                ),
              );
            });
  }

  Widget _buildBottomWidget() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (!userInfoModel.isLogin) {
                VideoSheet.showLoginSheet(context);
              } else {
                _showCommond();
              }
            },
            child: Container(
              height: Constants.SPACE_40,
              padding: const EdgeInsets.all(Constants.SPACE_10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constants.SPACE_24),
                border:
                    Border.all(color: Colors.black12, width: Constants.SPACE_1),
                color: settingInfo.darkSwitch
                    ? Colors.grey[800]
                    : Colors.grey[200],
              ),
              child: Text(
                '发表评论',
                style: TextStyle(
                    color:
                        settingInfo.darkSwitch ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        GestureDetector(
          onTap: () {
            VideoSheet.showShareSheet(context, model.title);
          },
          child: _buildSideBarItemBuilder(
            Constants.icShareImage,
            '分享',
            settingInfo.darkSwitch ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(
          width: Constants.SPACE_20,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (!userInfoModel.isLogin) {
                VideoSheet.showLoginSheet(context);
              } else {
                model.isLiked = !model.isLiked;
                if (model.isLiked) {
                  MineServiceApi.addLike(model.id);
                  model.likeCount++;
                } else {
                  MineServiceApi.cancelLike(model.id);
                  model.likeCount--;
                }
              }
            });
          },
          child: _buildSideBarItemBuilder(
            model.isLiked ? Constants.icLikeImage : Constants.icUnlikeImage,
            model.likeCount.toString(),
            model.isLiked
                ? Colors.red
                : (settingInfo.darkSwitch ? Colors.white : Colors.black87),
          ),
        ),
        const SizedBox(
          width: Constants.SPACE_10,
        ),
      ],
    );
  }

  Widget _buildSideBarItemBuilder(String imageUrl, String text, Color color) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            imageUrl,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            fit: BoxFit.contain,
            width: Constants.SPACE_22,
            height: Constants.SPACE_22,
          ),
          const SizedBox(
            height: Constants.SPACE_3,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: Constants.FONT_10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showCommond() {
    commentSheetOpen(
      context,
      '',
      (content) {
        PublishCommentRequest params = PublishCommentRequest(
            newsId: model.id, content: content, parentCommentId: '');
        MineServiceApi.publishComment(params).then((value) {
          setState(() {
            model.commentCount++;
            model.comments.add(value);
          });
        });
      },
      false,
    );
  }

  @override
  void onMarkLikeUpdated(MarkLikeUpdateType type) {
    // 当点赞或收藏状态更新时，更新当前视频的状态
    if (type == MarkLikeUpdateType.Like ||
        type == MarkLikeUpdateType.Mark ||
        type == MarkLikeUpdateType.All) {
      final news = BaseNewsServiceApi.queryRawNews(model.id);
      if (news != null) {
        setState(() {
          model.isLiked = news.isLiked ?? false;
          model.likeCount = news.likeCount ?? 0;
          model.isMarked = news.isMarked ?? false;
          model.markCount = news.markCount ?? 0;
        });
      }
    }
  }
}
