import { Want } from '@kit.AbilityKit';
import { AppStorageV2 } from '@kit.ArkUI';
import { BinaryMessenger, MethodChannel } from '@ohos/flutter_ohos';
import { PushActionParams } from '../push/Model';
import { PushUtils } from '../push/PushUtils';
import { AppLinkingRouter, FormCardRouter, ShortcutRouter } from './Types';
import { url } from '@kit.ArkTS';
import { UtilLog } from '@hw-agconnect/util-log';

const TAG = '[WantUtils]';
 const SOURCE_FORM_CARD: string = 'FormCard';

/**
 * 应用want处理工具类
 */
export class WantUtils {
  /**
   * 冷启动点击推送信息
   * @param want
   */
  public static async handlePushCall(want: Want) {
    let pushToken: string = await PushUtils.getTokenSyn();
    AppStorage.setOrCreate('pushToken', pushToken);
  }

  /**
   * 热启动点击推送信息
   * @param want
   */
  public static handlePushWant(want: Want) {
    /*
    * 获取push卡片点击进入携带参数
    * */
    const articleInfo = want.parameters?.articleInfo as PushActionParams;
    if (articleInfo) {
      const formPushRouter: FormCardRouter =
        AppStorageV2.connect(FormCardRouter, () => new FormCardRouter())!;
      formPushRouter.newsId = articleInfo?.newsId as string ?? '';
      let binding: BinaryMessenger = AppStorage.get('binding') as BinaryMessenger
      if (binding) {
        let methodChannel = new MethodChannel(binding, `com.news.flutter/formCardChannel`);
        if (methodChannel) {
          methodChannel.invokeMethod('getFormCardData', formPushRouter);
        }
      }
    }
  }

  /**
   * 快捷方式处理
   * @param want
   */
  public static handleShortcutWant(want: Want) {
    const shortCutKey = want?.parameters?.shortCutKey as string ?? '';
    if (shortCutKey) {
      const shortcutRouter: ShortcutRouter = AppStorageV2.connect(ShortcutRouter, () => new ShortcutRouter())!;
       shortcutRouter.pageName = shortCutKey;
      let binding: BinaryMessenger = AppStorage.get('binding') as BinaryMessenger
      if (binding) {
        let methodChannel = new MethodChannel(binding, `com.news.flutter/shortcutChannel`);
        if (methodChannel) {
          methodChannel.invokeMethod('getShortcutData', shortcutRouter);
        }
      }
    }
  }

  /**
   * 服务卡片事件处理
   * @param want
   */
  public static handleFormCardCall(want: Want) {
    if (want?.parameters?.source === SOURCE_FORM_CARD) {
      const formCardRouter: FormCardRouter =
        AppStorageV2.connect(FormCardRouter, () => new FormCardRouter())!;
      formCardRouter.id = new Date().getTime();
      formCardRouter.pageUrl = want?.parameters?.pageUrl as string ?? '';
      formCardRouter.newsId = want?.parameters?.newsId as string ?? '';
      formCardRouter.newsType = want?.parameters?.newsType as number ?? 0;
      let binding: BinaryMessenger = AppStorage.get('binding') as BinaryMessenger
      if (binding) {
        let methodChannel = new MethodChannel(binding, `com.news.flutter/formCardChannel`);
        if (methodChannel) {
          methodChannel.invokeMethod('getFormCardData', formCardRouter);
        }
      }
    }
  }

  /**
   * AppLinking链接处理
   * @param want
   */
  public static handleAppLinkingWant(want: Want) {
    /**
     * todo: 从链接中解析query参数，拿到参数后，可根据自己的业务需求进行后续的处理。
     * 例如传入的url为：https://linking.xiaobingtang.cn/newsDetail?id=article_1&type=0
     */
    const uri = want?.uri;
    if (uri) {
      try {
        const urlObject = url.URL.parseURL(uri);
        const newsId = urlObject.params.get('id');
        const newsType = urlObject.params.get('type');
        if (urlObject.pathname.includes('newsDetail') && newsId) {
          const appLinkRouter: AppLinkingRouter =
            AppStorageV2.connect(AppLinkingRouter, () => new AppLinkingRouter())!;
          appLinkRouter.id = new Date().getTime();
          appLinkRouter.newsId = newsId;
          appLinkRouter.newsType = Number(newsType) ?? 0;
          let binding: BinaryMessenger = AppStorage.get('binding') as BinaryMessenger
          if (binding) {
            let methodChannel = new MethodChannel(binding, `com.news.flutter/formCardChannel`);
            if (methodChannel) {
              methodChannel.invokeMethod('getFormAppLinkingData', appLinkRouter);
            }
          }
        }
        UtilLog.info(TAG, `Success to handle applinking want. pathname: ${urlObject.pathname}, newsId: ${newsId}`)
      } catch (e) {
        UtilLog.error(TAG, `Failed to handle applinking want. uri: ${uri}, Code: ${e.code}, message: ${e.message}`);
      }
    }
  }

}