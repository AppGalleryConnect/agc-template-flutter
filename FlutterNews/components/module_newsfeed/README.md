# 新闻流组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供新闻流/动态卡片展示功能，支持文章、视频、动态（图文）三种内容类型的展示。

## 约束与限制

### 环境

- `DevEco Studio`版本：`DevEco Studio` `5.1.0 Release`及以上
- `HarmonyOS SDK`版本：`HarmonyOS` `5.1.0 Release` SDK及以上
- 设备类型：华为手机（包括双折叠）
- 系统版本：`HarmonyOS 5.1.0(18)`及以上
- `Flutter`版本：`Flutter 3.22.1-ohos-1.0.4`
- `Dart`版本：`Dart 3.4.0`及以上

### 权限

- 网络权限：需要`Internet`连接获取内容

## 快速入门

1. 安装组件。

   如果是在`DevEco Studio`使用插件集成组件，则无需安装组件，请忽略此步骤。

   如果是从生态市场下载组件，请参考以下步骤安装组件。

   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的`components`目录下。

   b. 在项目根目录`pubspec.yaml`添加`module_newsfeed`模块及其依赖。

    ```yaml
    dependencies:
         module_newsfeed:
           path: ./components/module_newsfeed
         lib_common:
           path: ./commons/lib_common
         lib_news_api:
           path: ./commons/lib_news_api
         lib_widget:
           path: ./commons/lib_widget
    ```

    c. 运行命令获取依赖：

    ```bash
    flutter pub get
    ```

2. 引入组件。

    ```dart
    import 'package:module_newsfeed/module_newsfeed.dart';
    ```

3. 调用组件，详细组件调用参见[示例代码](#示例代码)。

    ```dart
    FeedCard(
      feedCardInfo: feedCardInfo,
      componentId: 'home_feed',
      fontSizeRatio: 1.0,
      shareBuilder: () => const Icon(Icons.share),
      onArticle: () => print('查看文章'),
      onVideo: () => print('播放视频'),
      onWatch: () => print('关注'),
      onLike: () => print('点赞'),
      onComment: () => print('评论'),
      onGoUserInfo: (userId) => print('用户: $userId'),
    )
    ```

## API参考

### 接口

`FeedCard`(option: [FeedCardOptions](#feedcardoptions对象说明))

新闻流卡片组件。

**参数：**

| 参数名     | 类型              | 是否必填 | 说明       |
|:--------|:----------------|:-----|:---------|
| `options` | [FeedCardOptions](#feedcardoptions对象说明) | 是    | 卡片配置参数 |

### FeedCardOptions对象说明

| 参数名             | 类型                                                         | 是否必填 | 说明                |
|:----------------|:-----------------------------------------------------------|:-----|:------------------|
| `feedCardInfo`    | [FeedCardInfo](#feedcardinfo对象说明)                                               | 是    | 卡片数据模型            |
| `componentId`     | `String`                                                     | 是    | 组件唯一标识，用于埋点统计     |
| `index`           | `int`                                                   | 否    | 卡片在列表中的索引         |
| `fontSizeRatio`   | `double`                                                 | 否    | 字体大小比例            |
| `isDark`          | `bool`                                                       | 否    | 是否为暗色模式           |
| `searchKey`       | `String`                                                     | 否    | 搜索关键词，用于高亮显示      |
| `shareBuilder`    | `Widget Function()`                                          | 是    | 分享按钮构建器           |
| `onArticle`       | `VoidCallback`                                               | 是    | 点击文章回调            |
| `onVideo`         | `VoidCallback`                                               | 是    | 点击视频回调            |
| `onWatch`         | `VoidCallback`                                               | 是    | 关注/取消关注回调         |
| `onLike`          | `VoidCallback`                                               | 是    | 点赞/取消点赞回调         |
| `onComment`       | `VoidCallback`                                               | 是    | 评论回调              |  
| `onGoUserInfo`    | `Function(String)?`                                          | 否    | 跳转到用户主页回调，参数为用户ID |
| `commentList`     | [CommentList](#commentlist-对象说明)                                                | 是    | 评论列表模型            |

### FeedCardInfo对象说明

| 属性名           | 类型                  | 说明             |
|:--------------|:--------------------|:---------------|
| `id`            | `String`              | 内容唯一标识         |
| `type`          | `NewsType`            | 内容类型（文章/视频/动态）  |
| `title`         | `String`              | 标题             |
| `author`        | `AuthorInfo`          | 作者信息           |
| `createTime`    | `int`                 | 创建时间戳（秒）       |
| `commentCount`  | `int`                 | 评论总数           |
| `likeCount`     | `int`                 | 点赞数            |
| `shareCount`    | `int`                 | 分享数            |
| `isLiked`       | `bool`                | 当前用户是否已点赞      |
| `richContent`   | `String?`             | 富文本内容（文章）      |
| `videoUrl`      | `String?`             | 视频地址（视频）       |
| `coverUrl`      | `String?`             | 封面图地址          |
| `postBody`      | `String?`             | 动态文本内容（动态）     |
| `postMedias`    | `List<PostMedia>`     | 动态媒体列表（动态）     |

## 示例代码

```dart
import 'package:flutter/material.dart';
import 'package:module_newsfeed/module_newsfeed.dart';

class NewsFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final feedCardInfo = FeedCardInfo(
      id: '1',
      type: NewsType.article,
      title: '这是一篇新闻标题',
      author: AuthorInfo(
        authorId: 'user_001',
        authorNickName: '新闻作者',
        authorIcon: 'https://example.com/avatar.jpg',
      ),
      createTime: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      commentCount: 123,
      likeCount: 456,
      shareCount: 78,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('新闻流')),
      body: ListView(
        children: [
          FeedCard(
            feedCardInfo: feedCardInfo,
            componentId: 'feed_home',
            fontSizeRatio: 1.0,
            shareBuilder: () => const Icon(Icons.share),
            onArticle: () => print('查看文章详情'),
            onVideo: () => print('播放视频'),
            onWatch: () => print('关注用户'),
            onLike: () => print('点赞'),
            onComment: () => print('评论'),
            onGoUserInfo: (userId) => print('查看用户: $userId'),
          ),
        ],
      ),
    );
  }
}
```



### `CommentList` 对象说明

| 属性名                    | 类型           | 说明          |
|:-----------------------|:-------------|:------------|
| `cardData`               | 新闻模型         | 内容唯一标识      |
| `key`                    | 可选的 String?  | 评论的置顶键      |
| `showInteractiveButtons` | 可选的 bool?    | 是否显示交互按钮    |
| `onPullUpKeyboard`       | 可选的 bool?    | 键盘弹起时，是否显示交互按钮 |
| `commentResponse`        | 评论基础模型       | 评论基础模型      |
| `onCommentLike`          | `VoidCallback` | 评论总数        |
| `onReplyToComment`       | `VoidCallback` | 点赞数         |


## 示例代码

```dart
import 'package:flutter/material.dart';
import 'package:module_newsfeed/module_newsfeed.dart';

class NewsDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final feedCardInfo = FeedCardInfo(
      id: '1',
      type: NewsType.article,
      title: '这是一篇新闻标题',
      author: AuthorInfo(
        authorId: 'user_001',
        authorNickName: '新闻作者',
        authorIcon: 'https://example.com/avatar.jpg',
      ),
      createTime: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      commentCount: 123,
      likeCount: 456,
      shareCount: 78,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('新闻流')),
      body: CommentList(
              // fontSizeRatio: 0.3,
              cardData: news,
              key: commentListKey,
              showInteractiveButtons: false,
              onPullUpKeyboard: _handlePullUpKeyboard,
              commentResponse: commentResponse,
              onCommentLike: (String commentId, bool isLiked) {
                 // 未登录则跳转到登录页面
                 print('点赞：ID=$commentId，当前状态=$isLiked');
              },

              onReplyToComment: (
                      {required CommentResponse targetComment,
                         CommentResponse? targetReply}) {
                 // 未登录则跳转到登录页面
                 // 1. 记录回复目标（由CommentList触发）
                 print('回复目标：$targetComment');
                 _activateReplyInput();
              },
           ),
     );
  }
  // 通过mock 获取动态数据  ---》news 模型
  Future<void> getNewsDynamicData(String resource) async {
     List<RequestListData> newsList = []; // 临时变量存新数据
     newsList = await HomeServiceApi.queryHomeRecommendList(resource);
     // 2. 原子化更新：只在数据完整后，通过一次 setState 刷新
     setState(() {
        newNewsList = newsList; // 直接替换整个列表，而非局部修改
        news = newNewsList[0].articles.first;
     });
  }
}
```
