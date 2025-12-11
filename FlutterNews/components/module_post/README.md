# 发帖组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件支持编辑互动发帖。

| 发表图片&文字                                              | 发表视频&文字                                              |
|------------------------------------------------------|------------------------------------------------------|
| <img src="./screenshots/text_image.jpg" width="300"> | <img src="./screenshots/text_video.jpg" width="300"> |


## 约束与限制

### 环境

- `DevEco Studio`版本：`DevEco Studio` `5.1.0 Release`及以上
- `HarmonyOS SDK`版本：`HarmonyOS` `5.1.0 Release` SDK及以上
- 设备类型：华为手机（包括双折叠）
- 系统版本：`HarmonyOS 5.1.0(18)`及以上
- `Flutter`版本：`Flutter 3.22.1-ohos-1.0.4`
- `Dart`版本：`Dart 3.4.0`及以上

### 权限

- 存储权限：用于读取和保存图片/视频
- 相册权限：用于从相册选择媒体文件
- 相机权限：用于拍照、录像功能

## 快速入门

1. 安装组件。

   如果是从生态市场下载组件，请参考以下步骤安装组件。

   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的`components`目录下。

   b. 在项目根目录`pubspec.yaml`添加`module_post`模块。

   ```yaml
   dependencies:
     module_post:
       path: ../../xxx/module_post
   ```

   c. 运行命令获取依赖：

   ```bash
   flutter pub get
   ```

2. 引入组件。

   ```dart
   import 'package:module_post/module_setfontsize.dart';
   ```

3. 调用组件，详细参数配置说明参见[API参考](#API参考)。

   ```dart
   PublishPostComp(
     fontRatio: 1.0,
     imageParams: DEFAULT_IMAGE_PARAM,
     videoParams: DEFAULT_VIDEO_PARAM,
     onChange: (body, mediaList) {
       print('内容: $body');
     },
   )
   ```

## API参考

### 接口

PublishPostComp(option: [PublishPostCompOptions](#publishpostcompoptions对象说明))

发帖组件

**参数：**

| 参数名     | 类型                                | 是否必填 | 说明         |
|:--------|:----------------------------------|:-----|:-----------|
| options | PublishPostCompOptions | 否    | 配置发帖组件的参数。 |

### PublishPostCompOptions对象说明

| 参数名         | 类型                                                                         | 是否必填 | 说明            |
|:------------|:---------------------------------------------------------------------------|:-----|:--------------|
| `fontRatio`   | `double`                                                                     | 否    | 字体大小比例        |
| `imageParams` | [MediaParams](#mediaparams对象说明)                                                               | 是    | 图片参数          |
| `videoParams` | [MediaParams](#mediaparams对象说明)                                                             | 是    | 视频参数          |
| `columnsNum`  | `int`                                                                       | 否    | 媒体网格列数        |
| `onChange`    | `Function`(`String` `body`, List<[PostImgVideoItem](#postimgvideoitem对象说明)> mediaList)                 | 是    | 文字、图片、视频变化的回调 |
| `isDark`      | `bool`                                                                       | 否    | 是否暗色模式        |

### MediaParams对象说明

| 参数名      | 类型     | 是否必填 | 说明         |
|:---------|:-------|:-----|:-----------|
| `type`     | `String` | 是    | 媒体文件类型     |
| `maxLimit` | `int`    | 是    | 限制资源选择最大数量 |
| `maxSize`  | `int`    | 否    | 限制资源选择最大大小 |

### PostImgVideoItem对象说明

| 参数名         | 类型     | 说明       |
|:------------|:-------|:---------|
| `picVideoUrl` | `String` | 图片/视频url |
| `surfaceUrl`  | `String` | 视频封面图url |

## 示例代码

```dart
import 'package:flutter/material.dart';
import 'package:module_post/module_setfontsize.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String _postContent = '';
  List<PostImgVideoItem> _mediaList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发表动态'),
        actions: [
          TextButton(
            onPressed: _canPublish() ? _publishPost : null,
            child: const Text('发布'),
          ),
        ],
      ),
      body: PublishPostComp(
        fontRatio: 1.0,
        imageParams: DEFAULT_IMAGE_PARAM,
        videoParams: DEFAULT_VIDEO_PARAM,
        columnsNum: 3,
        isDark: false,
        onChange: (body, mediaList) {
          setState(() {
            _postContent = body;
            _mediaList = mediaList;
          });
        },
      ),
    );
  }

  bool _canPublish() {
    return _postContent.trim().isNotEmpty || _mediaList.isNotEmpty;
  }

  void _publishPost() {
    print('发布内容: $_postContent');
    print('媒体数量: ${_mediaList.length}');
  }
}
```
