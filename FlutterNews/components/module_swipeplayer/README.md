# 短视频滑动组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#api参考)
- [示例代码](#示例代码)

## 简介

本组件实现短视频切换场景，提供了短视频上下滑动、横竖屏切换、长按倍速、播放进度条拖动、音量和亮度调节等能力。

| 竖屏                                                         | 横屏                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/img_player_vertical.png" width="300"> | <img src="./screenshots/img_player_horizontal.png" width="400"> |


## 约束与限制

### 环境

- `DevEco Studio`版本：`DevEco Studio 5.1.0` Release及以上
- `HarmonyOS SDK`版本：`HarmonyOS 5.1.0` Release SDK及以上
- 设备类型：华为手机（包括双折叠）
- 系统版本：`HarmonyOS 5.1.0(18)`及以上
- `Flutter`版本：`Flutter 3.22.1-ohos-1.0.4`
- `Dart`版本：`Dart 3.4.0`及以上

## 快速入门

1. 安装组件。

   如果是从生态市场下载组件，请参考以下步骤安装组件。

   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的`components`目录下。

   b. 在项目根目录`pubspec.yaml`添加`module_swipeplayer`模块。

   ```yaml
   dependencies:
     module_swipeplayer:
       path: ./components/module_swipeplayer
   ```

   c. 运行命令获取依赖：

   ```bash
   flutter pub get
   ```

2. 引入组件。

   ```dart
   import 'package:module_swipeplayer/views/video_page.dart';
   import 'package:module_swipeplayer/model/video_model.dart';
   import 'package:module_swipeplayer/views/video_view.dart';
   import 'package:module_swipeplayer/views/live_view.dart';
   ```

3. 调用组件，详细组件调用参见[示例代码](#示例代码)。


## API参考

### `VideoPage`对象说明
全屏视频播放

**参数：**

| 参数名     | 类型                      | 是否必填 | 说明           |
|:--------|:------------------------|:-----|:-------------|
| `videoModel` | `VideoModel`  | 是    | 视频模型 |
| `onTap` | `Function(bool isPlaying)`  | 是    | 页面点击事件 |
| `onClick` | `Function()`  | 是    | 点击头像时间 |
| `onFollow` | `Function(bool isFollow)`  | 是    | 关注 |
| `onLike` | `Function(bool isLike)`  | 是    | 点赞 |
| `onCommond` | `Function(bool isFromBottom)`  | 是    | 评论 |
| `onCollect` | `Function(bool isCollect)`  | 是    | 收藏 |
| `onShare` | `Function()`  | 是    | 分享 |
| `onFinish` | `Function()`  | 是    | 视频播放结束 |
| `onSlider` | `Function(Duration duration)`  | 是    | 视频播放进度 |
| `isCommend` | `bool`  | 否    | 是否是评论状态 |
| `onCommendChange` | `Function()`  | 是    | 评论状态页面点击事件 |

### `VideoView`对象说明
推荐视频

**参数：**

| 参数名     | 类型                      | 是否必填 | 说明           |
|:--------|:------------------------|:-----|:-------------|
| [videoModel](#videomodel对象说明) | [VideoModel](#videomodel对象说明)  | 是    | 视频模型 |
| `canPlayVideo` | `bool`  | 是    | 是否可以播放 |
| `autoPlayVideo` | `bool`  | 否    | 是否自动播放 |
| `onClick` | `Function()`  | 是    | 点击事件 |
| `onPushDetail` | `Function(Duration duration)`  | 是    | 跳转到详情 |
| `onFinish` | `Function()`  | 是    | 视频播放结束 |
| `onClose` | `Function()`  | 是    | 关闭 |
| `isDark` | `bool`  | 否    | 是否是黑暗模式 |

### `LiveView`对象说明
直播

**参数：**

| 参数名     | 类型                      | 是否必填 | 说明           |
|:--------|:------------------------|:-----|:-------------|
| [videoModel](#videomodel对象说明) | [VideoModel](#videomodel对象说明)  | 是    | 视频模型 |
| `isFullScreen` | `bool`  | 否    | 是否是全屏 |
| `onFullScreen` | `Function(bool isFullScreen)`  | 是    | 全屏事件 |

### `VideoModel`对象说明

| 参数名              | 类型     | 是否必填 | 说明       |
|:-----------------|:-------|:-----|:---------|
| `videoUrl`         | `String` | 是    | 视频URL    |
| `coverUrl`         | `String` | 是    | 封面图URL   |
| `id`               | `String` | 是    | 视频id   |
| `title`            | `String` | 否    | 视频标题     |
| `author`           | `String` | 否    | 作者名称     |
| `authorIcon`       | `String` | 否    | 作者头像     |
| `likeCount`        | `int`    | 否    | 点赞数      |
| `commentCount`     | `int`    | 否    | 评论数      |
| `isLike`           | `bool`   | 否    | 是否已点赞    |
| `isFollowe`        | `bool`   | 否    | 是否已关注    |
| `isCollecte`       | `bool`   | 否    | 是否已收藏    |
| `collectCount`     | `int`    | 否    | 收藏数      |
| `videoDuration`    | `int`    | 否    | 视频时长      |
| `createTime`       | `int`    | 否    | 创建时间     |
| `currentDuration`  | `int`    | 否    | 当前进度      |
| `videoType`        | `VideoEnum`    | 否    | 视频类型      |
   
### `VideoEnum`枚举说明
- `Live`: 直播
- `Video`: 视频
- `Ad`: 广告


## 示例代码

```dart
import 'package:flutter/material.dart';
import 'package:module_swipeplayer/views/video_page.dart';
import 'package:module_swipeplayer/model/video_model.dart';
import 'package:module_swipeplayer/views/video_view.dart';
import 'package:module_swipeplayer/views/live_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<VideoModel> videoList = [
    VideoModel(
        title: '新通话，让每一次连接超越想象',
        id: 'video1',
        coverUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg',
        videoUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/a20e0965e56a4dc498fc33ee23750c0d.mp4',
        videoDuration: 134506,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '星联光模块',
        id: 'video2',
        coverUrl:
            'https://e-file.huawei.com/mediares/Video_MCD/EBG/PUBLIC/zh/2025/04/3c04b872-197d-4551-a353-0eb99def6ca2.png',
        videoUrl:
            'https://e-file.huawei.com/mediares/MarketingMaterial_MCD/EBG/PUBLIC/zh/2025/04/5feb8457-d5e9-4949-a181-795e4d873af9.mp4',
        videoDuration: 48234,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '新通话，让每一次连接超越想象',
        id: 'video1',
        coverUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg',
        videoUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/a20e0965e56a4dc498fc33ee23750c0d.mp4',
        videoDuration: 134506,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '星联光模块',
        id: 'video2',
        coverUrl:
            'https://e-file.huawei.com/mediares/Video_MCD/EBG/PUBLIC/zh/2025/04/3c04b872-197d-4551-a353-0eb99def6ca2.png',
        videoUrl:
            'https://e-file.huawei.com/mediares/MarketingMaterial_MCD/EBG/PUBLIC/zh/2025/04/5feb8457-d5e9-4949-a181-795e4d873af9.mp4',
        videoDuration: 48234,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '新通话，让每一次连接超越想象',
        id: 'video1',
        coverUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg',
        videoUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/a20e0965e56a4dc498fc33ee23750c0d.mp4',
        videoDuration: 134506,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '星联光模块',
        id: 'video2',
        coverUrl:
            'https://e-file.huawei.com/mediares/Video_MCD/EBG/PUBLIC/zh/2025/04/3c04b872-197d-4551-a353-0eb99def6ca2.png',
        videoUrl:
            'https://e-file.huawei.com/mediares/MarketingMaterial_MCD/EBG/PUBLIC/zh/2025/04/5feb8457-d5e9-4949-a181-795e4d873af9.mp4',
        videoDuration: 48234,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '新通话，让每一次连接超越想象',
        id: 'video1',
        coverUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg',
        videoUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/a20e0965e56a4dc498fc33ee23750c0d.mp4',
        videoDuration: 134506,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '星联光模块',
        id: 'video2',
        coverUrl:
            'https://e-file.huawei.com/mediares/Video_MCD/EBG/PUBLIC/zh/2025/04/3c04b872-197d-4551-a353-0eb99def6ca2.png',
        videoUrl:
            'https://e-file.huawei.com/mediares/MarketingMaterial_MCD/EBG/PUBLIC/zh/2025/04/5feb8457-d5e9-4949-a181-795e4d873af9.mp4',
        videoDuration: 48234,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '新通话，让每一次连接超越想象',
        id: 'video1',
        coverUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg',
        videoUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/a20e0965e56a4dc498fc33ee23750c0d.mp4',
        videoDuration: 134506,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '星联光模块',
        id: 'video2',
        coverUrl:
            'https://e-file.huawei.com/mediares/Video_MCD/EBG/PUBLIC/zh/2025/04/3c04b872-197d-4551-a353-0eb99def6ca2.png',
        videoUrl:
            'https://e-file.huawei.com/mediares/MarketingMaterial_MCD/EBG/PUBLIC/zh/2025/04/5feb8457-d5e9-4949-a181-795e4d873af9.mp4',
        videoDuration: 48234,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '新通话，让每一次连接超越想象',
        id: 'video1',
        coverUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg',
        videoUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/a20e0965e56a4dc498fc33ee23750c0d.mp4',
        videoDuration: 134506,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '星联光模块',
        id: 'video2',
        coverUrl:
            'https://e-file.huawei.com/mediares/Video_MCD/EBG/PUBLIC/zh/2025/04/3c04b872-197d-4551-a353-0eb99def6ca2.png',
        videoUrl:
            'https://e-file.huawei.com/mediares/MarketingMaterial_MCD/EBG/PUBLIC/zh/2025/04/5feb8457-d5e9-4949-a181-795e4d873af9.mp4',
        videoDuration: 48234,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '新通话，让每一次连接超越想象',
        id: 'video1',
        coverUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg',
        videoUrl:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/a20e0965e56a4dc498fc33ee23750c0d.mp4',
        videoDuration: 134506,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
    VideoModel(
        title: '星联光模块',
        id: 'video2',
        coverUrl:
            'https://e-file.huawei.com/mediares/Video_MCD/EBG/PUBLIC/zh/2025/04/3c04b872-197d-4551-a353-0eb99def6ca2.png',
        videoUrl:
            'https://e-file.huawei.com/mediares/MarketingMaterial_MCD/EBG/PUBLIC/zh/2025/04/5feb8457-d5e9-4949-a181-795e4d873af9.mp4',
        videoDuration: 48234,
        createTime: 00,
        author: '华为',
        authorIcon:
            'https://www-file.huawei.com/admin/asset/v1/pro/view/6c813cb0874744f4b54fd61f1f9e8f24.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return 
      VideoSliderPage(
        videoList: videoList,
      );
      // VideoListPage(
      //   videoList: videoList,
      // );
  }
}

class VideoSliderPage extends StatefulWidget {
  final List<VideoModel> videoList;

  const VideoSliderPage({
    super.key,
    required this.videoList,
  });

  @override
  State<VideoSliderPage> createState() => _VideoSliderPageState();
}

class _VideoSliderPageState extends State<VideoSliderPage> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.videoList.length,
        controller: _pageController,
        onPageChanged: (index) => {
          setState(() {
            _currentIndex = index;
          }),
        },
        itemBuilder: (context, index) => VideoPage(
          videoModel: widget.videoList[index],
          canPlayVideo: _currentIndex == index,
          onTap: (isPlaying) => {
            print('点击了视频 $isPlaying'),
          },
          onClick: () => {
            print('点击了跳转'),
          },
          onFollow: (isFollow) => {
            print('点击了关注'),
          },
          onLike: (isLike) => {
            print('点击了点赞'),
          },
          onCommond: (isCommond) => {
            print('点击了评论'),
          },
          onCollect: (isCollect) => {
            print('点击了收藏'),
          },
          onShare: () => {
            print('点击了分享'),
          },
          onFinish: () => {},
          onSlider: (duration) => {},
          onCommendChange: () => {},
        )
      ),
    );
  }
}


class VideoListPage extends StatefulWidget {
  final List<VideoModel> videoList;

  const VideoListPage({
    super.key,
    required this.videoList,
  });

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.videoList.length,
        itemBuilder: (context, index) {
          return VideoView(
            videoModel: widget.videoList[index],
            canPlayVideo: _currentIndex == index,
            autoPlayVideo: true,
            onClick: () => {
              setState(() {
                _currentIndex = index;
              })
            },
            onPushDetail: (Duration duration) => {
              setState(() {
                _currentIndex = -1;
              })
            },
            onFinish: () => {},
            onClose: () => {
              setState(() {
                _currentIndex = -1;
              })
            },
          );
        }
      )
    );
  }
}

```
