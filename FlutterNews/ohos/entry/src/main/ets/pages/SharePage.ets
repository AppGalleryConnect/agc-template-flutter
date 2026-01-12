/**
 * 鸿蒙原生搜索页面
 * 用于从 Flutter 跳转过来
 */
import { router } from '@kit.ArkUI';
import { Share } from '../pages/views/Share'
import window from '@ohos.window';


@Entry
@Component
struct SharePage {
  @State newsId: string = '';
  @State newsContent: string = '';
  @State newsTitle: string = '';
  @State newsAuthor: string = '';
  @State newsDate: string = '';
  @State bundleName: string = '';
  @State coverImage: string = '';
  @State fromPage: string = '';
  context = this.getUIContext();

  // 获取页面参数
  getParams(): Record<string, Object> {
    try {
      // 尝试从路由参数获取
      const routeParams = router.getParams();
      if (routeParams) {
        return routeParams as Record<string, Object>;
      }
    } catch (error) {
      console.warn('ReadPage', `获取路由参数失败: ${error.message}`);
    }

    // 返回空对象
    return {};
  }

  aboutToAppear() {
    console.info('ReadPage', '页面开始初始化');

    try {
      // 从页面参数获取从 Flutter 传递过来的参数
      const params = this.getParams();
      console.info('ReadPage', `获取到参数: ${JSON.stringify(params)}`);

      if (params && Object.keys(params).length > 0) {
        if (params instanceof Map) {
          // params 是 Map 对象
          const paramsMap = params as Map<string, string>;
          this.newsContent = paramsMap.get('body') || '';
          this.newsTitle = paramsMap.get('title') || '';
          this.newsAuthor = paramsMap.get('author') || '';
          this.newsDate = paramsMap.get('date') || '';
          this.bundleName = paramsMap.get('bundleName') || '';
          this.newsId = paramsMap.get('currentId') || '';
          this.coverImage = paramsMap.get('coverImage') || '';
          this.fromPage = paramsMap.get('from') || 'Flutter';
        } else {
          // params 是普通对象
          const paramsObj = params as Record<string, string>;
          this.newsId = paramsObj['currentId'] || '';
          this.newsContent = paramsObj['body'] || '';
          this.newsTitle = paramsObj['title'] || '';
          this.newsAuthor = paramsObj['author'] || '';
          this.newsDate = paramsObj['date'] || '';
          this.bundleName = paramsObj['bundleName'] || '';
          this.coverImage = paramsObj['coverImage'] || '';
          this.fromPage = paramsObj['from'] || 'Flutter';
        }
        console.info('ReadPage', `参数解析完成: title=${this.newsTitle}, author=${this.newsAuthor}`);
      } else {
        console.warn('ReadPage', '未获取到参数');
        // 设置默认值用于测试
        this.newsTitle = '测试标题';
        this.newsAuthor = '测试作者';
        this.newsContent = '这是测试内容...';
        this.newsDate = '2024-01-01';
        this.newsId = 'test_001';
        this.bundleName = 'com.news.flutter';
        this.coverImage = 'https://example.com/test.jpg';
        this.fromPage = 'Flutter';
      }
    } catch (error) {
      console.error('ReadPage', `参数解析失败: ${error.message}`);
      // 设置默认值
      this.newsTitle = '默认标题';
      this.newsAuthor = '默认作者';
      this.newsContent = '这是默认内容...';
    }

    // 设置窗口背景
    try {
      window.getLastWindow(this.context.getHostContext(), (err, subWindow) => {
        if (err) {
          console.error('ReadPage', `获取窗口失败: ${err.message}`);
          return;
        }
        subWindow.setWindowBackgroundColor('#00000000');
        console.info('ReadPage', '窗口背景设置完成');
      });
    } catch (error) {
      console.error('ReadPage', `窗口设置失败: ${error.message}`);
    }
  }


  build() {
    Column() {
      Share()
        .height('50%')
        .width('50%').backgroundColor(Color.Pink)


    }
    .height('100%')
    .width('100%')
    .backgroundColor('#55000000')  // 20%透明度的黑色背景
    .backgroundBlurStyle(BlurStyle.Thin, {
      colorMode: ThemeColorMode.LIGHT,
      adaptiveColor: AdaptiveColor.DEFAULT,
    })

  }
}



