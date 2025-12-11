# 字体大小调节组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件支持实时查看字体大小调整效果，提供列表和详情两种预览模式。

| 列表页                                            | 详情页                                              |
|------------------------------------------------|--------------------------------------------------|
| <img src="./screenshots/list.jpg" width="300"> | <img src="./screenshots/detail.jpg" width="300"> |

## 约束与限制

### 环境

- `DevEco Studio`版本：`DevEco Studio` `5.1.0 Release`及以上
- `HarmonyOS SDK`版本：`HarmonyOS` `5.1.0 Release` SDK及以上
- 设备类型：华为手机（包括双折叠）
- 系统版本：`HarmonyOS 5.1.0(18)`及以上
- `Flutter`版本：`Flutter 3.22.1-ohos-1.0.4`
- `Dart`版本：`Dart 3.4.0`及以上

## 快速入门

1. 安装组件。

   如果是在`DevEco Studio`使用插件集成组件，则无需安装组件，请忽略此步骤。

   如果是从生态市场下载组件，请参考以下步骤安装组件。

   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的`components`目录下。

   b. 在项目根目录`pubspec.yaml`添加`module_setfontsize`模块。

   ```yaml
   dependencies:
     module_setfontsize:
       path: ./components/module_setfontsize
   ```

   c. 运行命令获取依赖：

   ```bash
   flutter pub get
   ```

2. 引入组件。

   ```dart
   import 'package:module_setfontsize/module_setfontsize.dart';
   ```

3. 调用组件，详细参数配置说明参见[API参考](#api参考)。

   ```dart
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => const SettingFont(),
     ),
   );
   ```

## API参考

### 接口

`SettingFont`({Key? key})

字体大小调节页面组件，提供完整的字体设置界面。

**参数：**

| 参数名 | 类型   | 是否必填 | 说明       |
|:----|:-----|:-----|:---------|
| `key` | `Key?` | 否    | Widget的键 |

### 功能特性

1. **双预览模式**
   - 列表预览：展示新闻列表卡片的字体效果
   - 详情预览：展示新闻详情页面的字体效果

2. **字体比例级别**

| 级别 | 显示名称 | 字体比例 | 说明   |
|:---|:-----|:-----|:-----|
| `0`  | 小    | `0.85` | 最小字体 |
| `1`  | 标准   | `1.0`  | 标准字体 |
| `2`  | 大    | `1.15` | 较大字体 |
| `3`  | 特大   | `1.45` | 超大字体 |

3. **实时预览**
   - 拖动滑块实时查看字体大小变化
   - 支持列表和详情两种预览模式切换

4. **持久化存储**
   - 自动保存字体设置到本地
   - 应用重启后自动恢复字体大小

5. **主题适配**
   - 支持深色模式和浅色模式
   - 自动适配系统主题

### SettingFontViewModel

字体设置的ViewModel，提供以下功能：

| 方法名              | 说明                |
|:-----------------|:------------------|
| `updateFontRatio`  | 更新字体比例            |
| `switchButton`     | 切换预览模式（列表/详情）     |
| `confirm`          | 确认并保存字体设置         |
| `resetToDefault`   | 重置为默认字体大小（`1.0`）    |

### FontScaleUtils

字体缩放工具类，提供全局字体缩放功能。

| 属性/方法           | 类型     | 说明            |
|:----------------|:-------|:--------------|
| `fontSizeRatio`   | `double` | 当前字体缩放比例      |
| `updateRatio`     | `void`   | 更新全局字体缩放比例    |

## 示例代码

### 基础使用

```dart
import 'package:flutter/material.dart';
import 'package:module_setfontsize/module_setfontsize.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('字体大小'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // 跳转到字体设置页面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingFont(),
                ),
              );
            },
          ),
          // 其他设置项...
        ],
      ),
    );
  }
}
```

### 在路由中使用

```dart
import 'package:flutter/material.dart';
import 'package:module_setfontsize/module_setfontsize.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '新闻应用',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/setting/font': (context) => const SettingFont(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('首页')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 使用命名路由跳转
            Navigator.pushNamed(context, '/setting/font');
          },
          child: const Text('设置字体大小'),
        ),
      ),
    );
  }
}
```

### 自定义字体缩放应用

```dart
import 'package:flutter/material.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 标题文字 - 应用字体缩放
        Text(
          '新闻标题',
          style: TextStyle(
            fontSize: 20 * FontScaleUtils.fontSizeRatio, // 应用缩放比例
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // 正文文字 - 应用字体缩放
        Text(
          '这是新闻正文内容...',
          style: TextStyle(
            fontSize: 16 * FontScaleUtils.fontSizeRatio, // 应用缩放比例
          ),
        ),
        
        // 次要信息 - 不应用缩放（固定大小）
        Text(
          '2小时前',
          style: TextStyle(
            fontSize: 12 * FontScaleUtils.fontSizeRatio, // 次要信息也建议缩放
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
```

### 监听字体大小变化

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:module_setfontsize/module_setfontsize.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 GetX 监听字体比例变化
    final controller = Get.find<SettingFontViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('新闻详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingFont(),
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题 - 动态响应字体变化
            Text(
              '住建部称住宅层高标准将提至不低于3米',
              style: TextStyle(
                fontSize: 20 * controller.currentRatio.value,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // 正文 - 动态响应字体变化
            Text(
              '竞高品质住宅建设方案是北京今年首批集中供地提出的竞拍规则之一...',
              style: TextStyle(
                fontSize: 16 * controller.currentRatio.value,
                height: 1.6,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
```

## 使用说明

### 1. 字体缩放范围

组件支持 **`0.85 ~ 1.45`** 的字体缩放比例，分为4个级别：

- **小**（`0.85`）：最小字体，适合空间有限的场景
- **标准**（`1.0`）：默认标准大小
- **大**（`1.15`）：较大字体，适合一般用户
- **特大**（`1.45`）：最大字体，适合老年用户或视力较弱的用户

### 2. 实时预览

- **列表预览**：展示新闻卡片列表的字体效果
- **详情预览**：展示新闻详情页面的字体效果
- 切换预览模式可以更直观地查看字体大小对不同场景的影响

### 3. 字体应用

在需要应用字体缩放的文本组件中，使用以下方式：

```dart
Text(
  '文本内容',
  style: TextStyle(
    fontSize: 基础字号 * FontScaleUtils.fontSizeRatio,
  ),
)
```

### 4. 建议缩放的元素

✅ **应该缩放的文本：**
- 新闻标题
- 新闻正文
- 评论内容
- 按钮文字
- 次要信息（时间、来源等）

❌ **不建议缩放的元素：**
- 图标大小（保持视觉平衡）
- 固定尺寸的UI元素
- 装饰性文字

### 5. 持久化存储

组件会自动将用户选择的字体大小保存到本地存储，应用重启后会自动恢复。无需额外配置。

### 6. 深色模式支持

组件完全支持深色模式，会自动适配当前主题：
- 浅色模式：白色背景 + 黑色文字
- 深色模式：深色背景 + 白色文字

### 7. 性能优化

- 使用 GetX 状态管理，性能优秀
- 实时预览采用响应式更新，流畅无卡顿
- 字体缩放比例全局共享，避免重复计算

## 常见问题

### Q1: 如何在整个应用中应用字体缩放？

**A:** 在需要缩放的文本组件中，使用 `fontSize: 基础字号 * FontScaleUtils.fontSizeRatio` 即可。建议在自定义文本组件或主题中统一处理。

### Q2: 字体设置不生效？

**A:** 
1. 确保已引入 `module_setfontsize` 组件
2. 确保文本使用了 `FontScaleUtils.fontSizeRatio` 进行缩放
3. 检查是否使用了 GetX 状态管理

### Q3: 如何重置字体大小？

**A:** 
```dart
final controller = Get.find<SettingFontViewModel>();
controller.resetToDefault(); // 重置为1.0
```

### Q4: 如何获取当前字体比例？

**A:** 
```dart
double currentRatio = FontScaleUtils.fontSizeRatio;
```

### Q5: 如何监听字体变化？

**A:** 使用 GetX 的 Obx 监听：
```dart
Obx(() => Text(
  '文本',
  style: TextStyle(
    fontSize: 16 * controller.currentRatio.value,
  ),
))
```

## 注意事项

1. **GetX 依赖**：本组件依赖 GetX 状态管理，请确保项目已集成 GetX
2. **主题适配**：组件会读取全局主题配置，请确保项目中已配置 `ThemeColors`
3. **图片资源**：预览示例中的图片需要放置在 `assets/` 目录下
4. **字体比例应用**：建议在全局文本样式中统一应用字体缩放，而不是单独处理每个文本
