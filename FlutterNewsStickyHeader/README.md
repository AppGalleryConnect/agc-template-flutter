# 新闻列表滑动吸附头Flutter组件快速入门

## 目录

- [简介](#简介)
- [约束和限制](#约束和限制)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)
- [参考文档](#参考文档)

## 简介

如果您的新闻类Flutter项目中需要使用滑动列表吸附头的功能，可以直接将此组件集成到项目中。本组件提供了分区展示、新闻加载、滚动吸附等常规功能，满足基本的新闻浏览需求，从而可以提高开发效率。

组件包含的主要功能如下：

- 专题介绍：展示专题标题、描述和专题图片。
- 分区展示
    - 分区标题：每个分区的标题左侧带有颜色竖线。
    - 新闻列表：每个新闻项包含标题、作者、发布时间和新闻内容。
    - “查看更多”按钮：点击后加载更多新闻，按钮包含“查看更多”文字和向下箭头图标。
- 滚动吸附头
    - 当滚动超过专题介绍板块后，分区标题会吸附在导航栏下方。
    - 吸附头会根据当前滚动位置显示对应的分区标题。
- 动态加载
    - 初始加载：页面初始化时加载所有分区及其新闻内容。
    - 切换加载：点击吸附头的分区标签可以加载对应分区及其新闻内容。
    - 动态加载更多：点击“查看更多”按钮后，动态加载更多新闻。

<img src="screenshots/sticky_header.png" width="300">

本组件工程代码如下所示：

```ts
├── lib / news /                     // 主要代码目录
│   ├── constants /                  // 常量文件
│   │   └── app_constants.dart
│   ├── models /                     // 数据模型
│   │   └── news_model.dart
│   ├── services /                   // 服务逻辑
│   │   └── news_service.dart
│   ├── widgets /                    // UI 组件
│   │   ├── more_button.dart
│   │   ├── news_item.dart
│   │   ├── section_indicator.dart
│   │   ├── section_title.dart
│   │   └── topic_intro.dart
│   └── news_list_screen.dart        // 主页面
├── assets /                         // 资源文件
│   ├── images /                     // 图片资源
│   │   ├── intro.jpg
│   │   └── news.jpeg
│   └─string.json                    // 组件模板身份标识
├── ohos /                           // openHarmony工程目录，由开发者创建   
└── pubspec.yaml                     // 项目配置文件
```

## 约束和限制

### 环境

- DevEco Studio版本：DevEco Studio 5.0.5 Release及以上
- HarmonyOS SDK版本：HarmonyOS 5.0.5 Release SDK及以上
- 设备类型：华为手机（包括双折叠和阔折叠）
- 系统版本：HarmonyOS 5.0.5(17)及以上
- Flutter SDK版本：基于Flutter 3.22.0适配的OpenHarmony发行版本，tag:3.22-ohos-1.0.1

### 权限

- 网络权限：ohos.permission.INTERNET

## 使用

### 配置环境

以下环境变量配置，类似Unix系统（Linux、Mac），可参照配置，Windows下环境变量配置请在“编辑系统环境变量”中设置。

1. 配置HarmonyOS环境变量 (HarmonyOS SDK、node、ohpm、hvigor)。
   ```sh
   export TOOL_HOME=/Applications/DevEco-Studio.app/Contents # mac环境
   export DEVECO_SDK_HOME=$TOOL_HOME/sdk 
   export PATH=$TOOL_HOME/tools/ohpm/bin:$PATH 
   export PATH=$TOOL_HOME/tools/hvigor/bin:$PATH 
   export PATH=$TOOL_HOME/tools/node/bin:$PATH
   ```
   在 Windows 上还需要配置一个名为HOS_SDK_HOME的系统变量，值为DevEco Studio sdk的安装路径，示例如下：
   
   ![img_1.png](screenshots/readme/img_1.png)


2. 通过代码工具下载flutter sdk仓库代码，tag为 `3.22.1-ohos-1.0.1`。

   ```sh
    git clone -b 3.22.1-ohos-1.0.1 https://gitcode.com/openharmony-tpc/flutter_flutter.git
   ```

   并配置如下环境：

   ```sh
    export PUB_CACHE=D:/PUB(自定义路径)
    export PATH=<flutter_flutter path>/bin:$PATH
    export FLUTTER_GIT_URL=https://gitcode.com/openharmony-tpc/flutter_flutter.git
    export PUB_HOSTED_URL=https://pub.flutter-io.cn #国内的镜像，也可以使用其他镜像，比如清华镜像源
    export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn #国内的镜像，也可以使用其他镜像，比如清华镜像源
   ```
   Windows 环境变量配置示例如下（请按照实际安装目录配置）：
    - 系统变量

      ![img_2.png](screenshots/readme/img_2.png)
    - 环境变量

      ![img_3.png](screenshots/readme/img_3.png)

### 检查环境

运行 `flutter doctor -v` 检查环境变量配置是否正确，**Futter**与**OpenHarmony**应都为ok标识，若两处提示缺少环境，按提示补充相应环境即可（
**Futter**处为感叹号标识无影响）。

<img src="screenshots/readme/img_4.png" width="700">

### 运行调试工程

#### 方式一：基于本flutter工程直接运行

1. 进入本组件的flutter工程目录，通过终端执行 `flutter pub get`和 `flutter build hap`。
2. 通过DevEco Studio打开工程目录中 `ohos`工程，连接模拟器或者真机，手工配置签名。
3. 在flutter工程目录或者子目录 `ohos`中，通过 `flutter devices`指令发现ohos设备。
4. 在flutter工程目录中，通过`flutter run -d <device-id>`指令运行调试，也可以通过DevEco Studio点击Run运行ohos工程（适合真机，模拟器不适用）。

#### 方式二：创建flutter工程运行

1. 创建工程。

   ```
   # 创建工程，工程名支持小写和下划线
   flutter create --platforms ohos <projectName>
   ```
2. 拷贝flutter工程内容和配置身份标识。

   将本组件flutter工程中`lib`、`assets`、`pubspec.yaml`等文件拷贝到当前新建工程中，并且将身份标识`assets/string.json`
   文件中的内容，附加在当前新建工程的文件`ohos/entry/src/main/resources/base/element/string.json`中。
3. 编译运行。

   在当前新建的flutter工程目录下，编译运行的详细步骤请参考 [运行调试工程](#运行调试工程) 的方式一。

## API参考

### 子组件

无

### 接口

NewsListScreen()

新闻滑动列表。

### 接口

SectionIndicator(String activeSection, ValueChanged`<String>` onSectionChanged)

分区指示器。

**参数：**

| 参数名              | 类型                     | 是否必填 | 说明       |
|------------------|------------------------|------|----------|
| activeSection    | string                 | 是    | 活跃的分区名   |
| onSectionChanged | ValueChanged`<String>` | 是    | 分区活动回调函数 |

### 事件

支持以下事件

#### handleScroll

void _handleScroll()

新闻列表页上下滑动触发事件

#### fetchMoreNews

Future<List`<NewsItem>`> _fetchMoreNews(String sectionTitle, int limit)

点击新闻列表中“加载更多”按钮触发事件

#### loadSectionData

void _loadSectionData(String sectionTitle)

点击列表吸附头中的标题触发事件

## 示例代码

### 示例1：使用新闻列表页作为入口页

`main.dart`文件定义如下，请确保引入本组件工程目录下的 `lib/news`下的所有文件

```dart
import 'package:flutter/material.dart';
import 'news/news_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NewsListScreen(),
    );
  }
}
```

## 参考文档

[OpenHarmony Flutter SDK开发文档](https://gitcode.com/openharmony-tpc/flutter_flutter/blob/3.22.1-ohos-1.0.1/README.md)

[鸿蒙版Flutter环境搭建指导](https://gitcode.com/openharmony-tpc/flutter_samples/blob/master/ohos/docs/03_environment/openHarmony-flutter%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA%E6%8C%87%E5%AF%BC.md)