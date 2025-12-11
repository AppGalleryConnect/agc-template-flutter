# 图片预览组件 (module_imagepreview)

## 目录

- [简介](#简介)
- [特性](#特性)
- [架构设计](#架构设计)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)
- [使用场景](#使用场景)

## 简介

`module_imagepreview` 是一个**完全独立、无业务依赖**的图片预览组件，完全对齐鸿蒙架构设计。

### 核心功能

- ✅ **图片浏览**：支持滑动切换、双指缩放、双击放大
- ✅ **长图支持**：自动识别长图，支持上下拖动
- ✅ **交互功能**：点赞、评论、分享、关注（通过回调实现）
- ✅ **Hero动画**：支持图片预览的平滑过渡动画
- ✅ **完全解耦**：不依赖任何业务模型，纯UI组件

<img src="./screenshots/preview.png" width="300" height="600">

## 特性

### 🎯 架构优势

- **完全独立**：不依赖 `NewsResponse`、`UserInfoModel` 等业务模型
- **纯UI组件**：只关注展示和交互，业务逻辑由父组件处理
- **易于测试**：参数简单明确，无需构造复杂对象
- **完全对齐鸿蒙**：架构设计与鸿蒙原生保持一致

### 📦 依赖关系

```
module_imagepreview (图片预览组件)
    ├── 无业务依赖 ✅
    ├── 只依赖 Flutter 基础库
    └── 通过回调函数与父组件通信
```

## 架构设计

### 设计原则

1. **组件独立性**：图片预览组件不依赖任何业务模块
2. **数据传递**：通过字段参数传递数据，而非模型对象
3. **事件通信**：通过回调函数向外传递用户操作
4. **状态管理**：本地状态用于UI响应，业务状态由父组件管理

### 数据流

```
┌──────────────────────────┐
│   业务组件（父组件）        │
│   - 处理登录检查            │
│   - 调用API接口            │
│   - 更新数据状态           │
│   - 发送事件通知           │
└────────┬──────────────────┘
         │ 回调函数
         │ (onNewsLike/onShare等)
         ↓
┌──────────────────────────┐
│ AdvancedCustomImageViewer│ ← 纯UI组件
│  - 图片展示               │
│  - 用户交互               │
│  - 无业务逻辑             │
└──────────────────────────┘
```

## 快速入门

### 1. 安装组件

在项目根目录 `pubspec.yaml` 添加依赖：

```yaml
dependencies:
  module_imagepreview:
    path: ./components/module_imagepreview
```

运行命令获取依赖：

```bash
flutter pub get
```

### 2. 引入组件

```dart
import 'package:module_imagepreview/AdvancedCustomImageViewer.dart';
```

### 3. 基础使用

```dart
// 简单预览（无交互功能）
AdvancedCustomImageViewer(
  imageProviders: imageUrls,
  initialIndex: 0,
)

// 完整功能（带交互）
final userInfo = AccountApi.getInstance().queryUserInfo();
AdvancedCustomImageViewer(
  imageProviders: imageUrls,
  initialIndex: 0,
  // 用户信息
  isLogin: userInfo.isLogin,
  currentUserId: userInfo.authorId,
  // 作者信息
  authorId: news?.author?.authorId,
  authorIcon: news?.author?.authorIcon,
  authorNickName: news?.author?.authorNickName,
  createTime: news?.createTime,
  // 统计数据
  commentCount: news?.commentCount ?? 0,
  likeCount: news?.likeCount ?? 0,
  isLiked: news?.isLiked ?? false,
  shareCount: news?.shareCount ?? 0,
  // 回调函数
  onNewsLike: () {
    // 处理点赞逻辑
  },
  onAddComment: () {
    // 处理评论逻辑
  },
  onShare: () {
    // 处理分享逻辑
  },
  onWatchOperation: () {
    // 处理关注逻辑
  },
)
```

## API参考

### AdvancedCustomImageViewer

高级图片预览浏览器（完全对齐鸿蒙架构）。

```dart
AdvancedCustomImageViewer({
  required List<String> imageProviders,
  int initialIndex = 0,
  String? heroTagPrefix,
  
  // 用户信息（解耦：不依赖 UserInfoModel）
  bool isLogin = false,
  String? currentUserId,
  
  // 作者信息（解耦：不依赖 NewsResponse）
  String? authorId,
  String? authorIcon,
  String? authorNickName,
  int? createTime,  // 毫秒时间戳
  
  // 统计数据
  int commentCount = 0,
  int likeCount = 0,
  bool isLiked = false,
  int shareCount = 0,
  
  // 回调函数
  VoidCallback? onWatchOperation,
  VoidCallback? onNewsLike,
  VoidCallback? onAddComment,
  VoidCallback? onShare,
})
```

**参数说明：**

#### 必需参数

| 参数名            | 类型            | 说明          |
|:---------------|:--------------|:------------|
| imageProviders | List\<String> | 图片URL列表（支持网络和本地路径） |

#### 可选参数 - 基础配置

| 参数名          | 类型       | 默认值 | 说明                    |
|:-------------|:---------|:-----|:----------------------|
| initialIndex | int      | 0    | 初始显示的图片索引            |
| heroTagPrefix | String? | null | Hero动画标签前缀（用于平滑过渡） |

#### 可选参数 - 用户信息（解耦设计）

| 参数名          | 类型      | 默认值 | 说明              |
|:-------------|:--------|:-----|:----------------|
| isLogin      | bool    | false | 是否已登录          |
| currentUserId | String? | null | 当前用户ID（用于判断是否为自己的内容） |

#### 可选参数 - 作者信息（解耦设计）

| 参数名          | 类型      | 默认值 | 说明              |
|:-------------|:--------|:-----|:----------------|
| authorId     | String? | null | 作者ID            |
| authorIcon   | String? | null | 作者头像URL         |
| authorNickName | String? | null | 作者昵称           |
| createTime   | int?    | null | 创建时间（毫秒时间戳）    |

#### 可选参数 - 统计数据

| 参数名          | 类型   | 默认值 | 说明    |
|:-------------|:-----|:-----|:------|
| commentCount | int  | 0    | 评论数  |
| likeCount    | int  | 0    | 点赞数  |
| isLiked      | bool | false | 是否已点赞 |
| shareCount   | int  | 0    | 分享数  |

#### 可选参数 - 回调函数

| 参数名            | 类型            | 说明                    |
|:---------------|:--------------|:----------------------|
| onWatchOperation | VoidCallback? | 关注/取消关注操作回调          |
| onNewsLike      | VoidCallback? | 点赞/取消点赞操作回调          |
| onAddComment    | VoidCallback? | 评论操作回调（通常用于滚动到评论区） |
| onShare         | VoidCallback? | 分享操作回调              |

**注意**：所有回调函数由父组件实现，组件本身不包含任何业务逻辑。

## 示例代码

### 示例 1：简单预览（无交互功能）

```dart
import 'package:flutter/material.dart';
import 'package:module_imagepreview/AdvancedCustomImageViewer.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AdvancedCustomImageViewer(
      imageProviders: [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
      ],
      initialIndex: 0,
    ),
  ),
);
```

### 示例 2：完整功能（带交互）

```dart
import 'package:flutter/material.dart';
import 'package:module_imagepreview/AdvancedCustomImageViewer.dart';
import 'package:lib_account/services/account_api.dart';
import 'package:lib_news_api/params/response/news_response.dart';

void showImagePreview(BuildContext context, NewsResponse news, List<String> imageUrls) {
  final userInfo = AccountApi.getInstance().queryUserInfo();
  
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AdvancedCustomImageViewer(
        imageProviders: imageUrls,
        initialIndex: 0,
        
        // 用户信息
        isLogin: userInfo.isLogin,
        currentUserId: userInfo.authorId,
        
        // 作者信息
        authorId: news.author?.authorId,
        authorIcon: news.author?.authorIcon,
        authorNickName: news.author?.authorNickName,
        createTime: news.createTime,
        
        // 统计数据
        commentCount: news.commentCount ?? 0,
        likeCount: news.likeCount ?? 0,
        isLiked: news.isLiked ?? false,
        shareCount: news.shareCount ?? 0,
        
        // 回调函数 - 由父组件处理业务逻辑
        onNewsLike: () {
          // 处理点赞：登录检查、API调用、状态更新
          _handleLike(news);
        },
        onAddComment: () {
          // 处理评论：滚动到评论区
          _scrollToComment();
        },
        onShare: () {
          // 处理分享：显示分享面板
          _showShareSheet(news);
        },
        onWatchOperation: () {
          // 处理关注：关注/取消关注
          _handleWatch(news.author?.authorId);
        },
      ),
    ),
  );
}
```

### 示例 3：使用 ImagePreviewPageRoute（带动画）

```dart
import 'package:module_imagepreview/ImagePreviewPageRoute.dart';

Navigator.push(
  context,
  ImagePreviewPageRoute(
    builder: (context) => AdvancedCustomImageViewer(
      imageProviders: imageUrls,
      initialIndex: initialIndex,
      heroTagPrefix: 'image_${news.id}',
      // ... 其他参数
    ),
  ),
);
```

## 使用场景

### 当前使用位置

图片预览组件在以下业务模块中被使用：

| 业务模块 | 文件路径 | 用途 |
|---------|---------|------|
| **新闻详情** | `module_newsfeed/news_detail_page.dart` | 新闻详情页图片预览 |
| **首页信息流** | `business_home/feed_detail.dart` | 信息流卡片图片预览 |
| **首页互动** | `business_home/interaction_feed_card.dart` | 互动卡片图片预览 |
| **互动列表** | `business_interaction/interaction_feed_card.dart` | 互动列表图片预览 |
| **个人主页** | `business_profile/person_home_page.dart` | 个人主页图片预览 |
| **视频直播** | `business_video/video_live_detail_page.dart` | 视频介绍图片预览 |

### 最佳实践

1. **数据传递**：传入具体字段，而非模型对象
2. **业务逻辑**：在回调函数中处理，组件保持纯净
3. **状态同步**：父组件更新数据后，组件会自动同步（通过 `didUpdateWidget`）
4. **Hero动画**：使用 `heroTagPrefix` 实现平滑过渡效果

### 注意事项

- ⚠️ 组件不依赖任何业务模块，保持完全独立
- ⚠️ 所有业务逻辑（登录检查、API调用等）应在回调函数中处理
- ⚠️ `createTime` 参数为毫秒时间戳（`int`），不是 `DateTime` 对象
- ✅ 组件内部使用乐观更新策略，点击后立即更新UI，提升用户体验
