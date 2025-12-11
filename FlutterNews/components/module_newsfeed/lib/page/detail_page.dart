import 'package:flutter/material.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/utils/router_utils.dart';
import '../components/feed_detail.dart';
import '../model/recommend_model.dart';
import '../utils/utils.dart';
import 'package:module_newsfeed/constants/constants.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({super.key});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late FeedCardInfo testFeedData;

  @override
  void initState() {
    super.initState();
    testFeedData = FeedCardInfo(
      id: 'test_001',
      type: NewsType.article,
      title: '测试动态标题 这是一条用于测试的动态内容，包含文字和图片',
      richContent: '这是一条用于测试的动态内容，包含文字和图片',
      createTime: DateTime.now()
          .subtract(const Duration(hours: 2))
          .millisecondsSinceEpoch, 
      shareCount: 1500,
      commentCount: 56,
      likeCount: 2800,
      isLiked: false, 
      author: AuthorInfo(
        authorId: 'author_001',
        authorNickName: '测试用户',
        authorIcon: 'https://picsum.photos/200/200', 
      ),
      postMedias: [
        PostMedia(
          url: 'https://picsum.photos/800/600', 
          thumbnailUrl: '', 
        ),
        PostMedia(
          url: 'https://picsum.photos/800/600', 
          thumbnailUrl: '', 
        ),
        PostMedia(
          url: 'https://picsum.photos/800/600', 
          thumbnailUrl: '',
        ),
      ],
    );
  }

  void _handleAddWatch() {
    
  }

  void _handleAddLike() {
    setState(() {
      
    });
  }

  void _handleAddComment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('打开评论区')),
    );
  }

  void _handleVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('播放视频')),
    );
  }

  void _handleGoUserInfo(String userId) {
    RouterUtils.of
        .pushPathByName(RouterMap.PROFILE_HOME, param: userId);
  }

  Widget _followBuilder() {
    return GestureDetector(
      onTap: _handleAddWatch,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16, vertical: Constants.SPACE_6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.SPACE_14),
        ),
      ),
    );
  }

  Widget _publishTimeBuilder() {
    return Text(
      getDateDiff(testFeedData.createTime),
      style: const TextStyle(
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FeedDetail 测试'),
      ),
      body: SingleChildScrollView(
        child: FeedDetail(
          componentId: 'feed_detail_001', 
          curFeedCardInfo: testFeedData, 
          isDynamicsSingleDetail: true, 
          fontSizeRatio: 1.0, 
          searchKey: '', 
          showUserBar: true, 
          showTimeBottom: false, 
          isFeedSelf: false,
          followBuilderParam: _followBuilder, 
          publishCustomTimeBuilder: _publishTimeBuilder, 
          onGoUserInfo: _handleGoUserInfo, 
          onAddWatch: _handleAddWatch, 
          onAddLike: _handleAddLike,
          onAddComment: _handleAddComment,
          onVideo: _handleVideo,
        ),
      ),
    );
  }
}
