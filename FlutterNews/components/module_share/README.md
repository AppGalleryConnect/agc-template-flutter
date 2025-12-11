# 分享组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件支持微信、朋友圈、qq、生成海报、系统分享等分享功能。

<img src="./screenshots/share.png" width="300">


## 约束与限制

### 环境

- `DevEco Studio`版本：`DevEco Studio` `5.1.0 Release`及以上
- `HarmonyOS SDK`版本：`HarmonyOS` `5.1.0 Release` SDK及以上
- 设备类型：华为手机（包括双折叠）
- 系统版本：`HarmonyOS 5.1.0(18)`及以上
- `Flutter`版本：`Flutter 3.22.1-ohos-1.0.4`
- `Dart`版本：`Dart 3.4.0`及以上

### 权限

- 网络权限：分享到社交平台需要Internet连接
- 存储权限：保存海报到相册需要写入存储权限

## 快速入门

1. 安装组件。

   如果是从生态市场下载组件，请参考以下步骤安装组件。

   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的`components`目录下。

   b. 在项目根目录`pubspec.yaml`添加`module_share`模块。

   ```yaml
   dependencies:
     module_share:
       path: ./components/module_share
   ```

   c. 运行命令获取依赖：

   ```bash
   flutter pub get
   ```

2. 引入组件。

   ```dart
   import 'package:module_share/module_share.dart';
   ```

3. 接入微信`SDK`。
   前往微信开放平台申请AppID并配置鸿蒙应用信息，详情参考：[鸿蒙接入指南](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/ohos.html)。

4. 接入`QQ`。
   前往`QQ`开放平台申请`AppID`并配置鸿蒙应用信息，详情参考：[鸿蒙接入指南](https://wiki.connect.qq.com/sdk%e4%b8%8b%e8%bd%bd)。

5. 调用组件，详细组件调用参见[示例代码](#示例代码)。

```dart
Share(
  qrCodeInfo: ShareOptions(
    id: 'post_1',
    title: '文章标题',
    articleFrom: 'https://example.com/article/001',
  ),
  onClose: () {},
  onOpen: () {},
)
```

## API参考

### 接口

`Share`(option: [ShareOptions](#shareoptions对象说明))

分享组件的参数

**参数：**

| 参数名     | 类型          | 是否必填 | 说明         |
|:--------|:------------|:-----|:-----------|
| `options` | [ShareOptions](#shareoptions对象说明) | 否    | 配置分享组件的参数。 |

### ShareOptions对象说明

| 参数名                | 类型                  | 是否必填 | 说明            |
|:-------------------|:--------------------|:-----|:--------------|
| `qrCodeInfo`         | [QrCodeInfoOptions](#qrcodeinfooptions对象说明)   | 是    | 生成海报二维码的相关信息  |
| `shareRenderBuilder` | `WidgetBuilder? `     | 否    | 自定义分享入口图片内容等  |
| `onClose`            | `VoidCallback? `        | 是    | 分享弹窗关闭的回调     |
| `onOpen`             | `VoidCallback? `        | 是    | 分享弹窗打开的回调     |

### QrCodeInfoOptions对象说明

| 参数名         | 类型     | 是否必填 | 说明      |
|:------------|:-------|:-----|:--------|
| `id`          | String | 否    | 分享文章的id |
| `title`       | String | 否    | 分享文章的标题 |
| `articleFrom` | String | 否    | 分享文章的来源 |

## 示例代码

```dart
import 'package:flutter/material.dart';
import 'package:module_share/module_share.dart';

class ShareTestPage extends StatefulWidget {
  const ShareTestPage({super.key});

  @override
  State<ShareTestPage> createState() => _ShareTestPageState();
}

class _ShareTestPageState extends State<ShareTestPage> {
  final ShareOptions shareOptions = ShareOptions(
    id: 'test_123',
    title: '测试分享标题',
    articleFrom: '测试来源',
  );

  VoidCallback? _shareTrigger;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share组件测试')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('点击下方按钮测试分享功能'),
            const SizedBox(height: 20),
            Share(
              qrCodeInfo: shareOptions,
              onClose: () => print('分享弹窗关闭'),
              onOpen: () => print('分享弹窗打开'),
              onTriggerShare: (trigger) {
                _shareTrigger = trigger;
              },
              shareRenderBuilder: (context) => ElevatedButton(
                onPressed: () {
                  _shareTrigger?.call();
                },
                child: const Text('打开分享'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
