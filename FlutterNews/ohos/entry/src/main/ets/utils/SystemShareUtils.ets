import { window } from '@kit.ArkUI';
import { harmonyShare, systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
import { fileUri, fileIo as fs } from '@kit.CoreFileKit';
import { UtilLog } from '@hw-agconnect/util-log';
import { TimeUtils } from '../pages/utils/TimeUtils';
import { FileUtils } from '../pages/utils/FileUtils';

const TAG = '[SystemShareUtils]';

/**
 * 系统分享
 */
export class SystemShareUtils {
  private static _instance: SystemShareUtils;
  /**
   * todo: 配置应用实际的AppLinking网址域名
   */
  APP_LINKING_URL: string = 'https://linking.xiaobingtang.cn';
  private uiContext: UIContext | undefined = undefined;
  private shareData: systemShare.SharedData = new systemShare.SharedData({
    utd: utd.UniformDataType.TEXT,
  });

  /**
   * 获取实例
   * @returns
   */
  public static get instance() {
    if (!SystemShareUtils._instance) {
      SystemShareUtils._instance = new SystemShareUtils();
    }
    return SystemShareUtils._instance;
  }

  /**
   * 初始化数据
   * @param data
   */
  public async init(uiContext: UIContext) {
    this.uiContext = uiContext;
  }

  /**
   * 获取缩略图
   * @param thumbUrl
   * @returns
   */
  private async getThumbnail(thumbUrl: ResourceStr) {
    let thumbUri: string = '';

    try {
      if (thumbUrl) {
        let thumbBuffer = new ArrayBuffer(100);
        if (typeof thumbUrl !== 'string') {
          if (this.uiContext) {
            const context = this.uiContext.getHostContext() as Context;
            const content = await context.resourceManager.getMediaContent(thumbUrl.id);
            thumbBuffer = content.buffer as ArrayBuffer;
          }
        }
        if (this.uiContext) {
          thumbUri = await this.saveToSandbox(this.uiContext, thumbBuffer);
        }
      }
    } catch (e) {
      UtilLog.error(TAG, 'getThumbnail failed, error: ' + JSON.stringify(e));
    }

    return thumbUri;
  }

  /**
   * 写入数据到沙箱
   * @param uiContext
   * @param buffer
   * @returns
   */
  public async saveToSandbox(uiContext: UIContext, buffer: ArrayBuffer): Promise<string> {
    let file: fs.File | null = null;
    try {
      const savePath = `${uiContext.getHostContext()?.cacheDir}/${new Date().getTime()}.png`;
      file = fs.openSync(savePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.writeSync(file.fd, buffer);

      // 记录缓存文件路径
      const files: string[] = AppStorage.get('cacheFiles') ?? [];
      files.push(savePath);
      AppStorage.set('cacheFiles', files);

      return fileUri.getUriFromPath(savePath);
    } catch (e) {
      return '';
    } finally {
      try {
        if (file) {
          fs.closeSync(file);
        }
      } catch (e) {
        UtilLog.error(TAG, 'fs.closeSync error: ' + JSON.stringify(e));
      }
    }
  }


  /**
   * 获取华为分享的数据
   * @param data
   * @returns
   */
  public async getShareData(data: Record<string, Object>) {
    let contentTitle = data['title'] as string;
    const thumbUri = await this.getThumbnail($r('app.media.startIcon'));
    let sharedData: systemShare.SharedData = new systemShare.SharedData({
      utd: utd.UniformDataType.TEXT,
      title: contentTitle,
      description: `${data['author']} | ${TimeUtils.formatTimestamp(data['time'] as number)}`,
      content: contentTitle,
      thumbnailUri: thumbUri,
    });
    this.shareData = sharedData;
  }

  /**
   * 发起碰一碰
   */
  private callback = async (sharableTarget: harmonyShare.SharableTarget) => {
    sharableTarget.share(this.shareData);
  }

  /**
   * 监听碰一碰
   */
  public onKnockShare() {
    harmonyShare.on('knockShare', this.callback);
  }

  /**
   * 取消监听碰一碰
   */
  public offKnockShare() {
    harmonyShare.off('knockShare', this.callback);
  }

  private async gestureCallback(target: harmonyShare.SharableTarget, shareParams: Record<string, Object>) {
    // 构造分享数据
    let shareData: systemShare.SharedData = new systemShare.SharedData({
      utd: utd.UniformDataType.HYPERLINK,
      // 设置为AppLinking链接
      content: `${this.APP_LINKING_URL}/newsDetail?id=${shareParams['newsId']}&type=${shareParams['newsType']}`,
      title: shareParams['title'] as string,
      description: `${shareParams['author']} | ${TimeUtils.formatTimestamp(shareParams['time'] as number)}`,
      thumbnailUri: await this.getNewsImageUri(shareParams['newsImageUri'] as string),
    });
    target.share(shareData);
  }

  /**
   * 注册隔空传送的事件监听
   * @param context
   * @param callback
   */
  public registerGestureShareListener(context: Context, shareParams: Record<string, Object>) {
    if (canIUse('SystemCapability.Collaboration.HarmonyShare')) {
      window.getLastWindow(context).then((data) => {
        try {
          const mainWindowID: number = data.getWindowProperties().id;
          harmonyShare.on('gesturesShare', { windowId: mainWindowID }, (target: harmonyShare.SharableTarget) => {
            this.gestureCallback(target, shareParams)
          });
        } catch (error) {
          UtilLog.error(TAG, `getWindowProperties error: ${error.code} ${error.message}`);
        }
      }).catch((error: ESObject) => {
        UtilLog.error(TAG, `registerGestureShareListener getLastWindow error: ${error.code} ${error.message}`);
      })
    }
  }

  /**
   * 取消注册隔空传送的事件监听
   * @param context
   * @param callback
   */
  public unRegisterGestureShareListener(context: Context) {
    if (canIUse('SystemCapability.Collaboration.HarmonyShare')) {
      window.getLastWindow(context).then((data) => {
        try {
          const mainWindowID: number = data.getWindowProperties().id;
          harmonyShare.off('gesturesShare', { windowId: mainWindowID });
        } catch (error) {
          UtilLog.error(TAG, `getWindowProperties error ${error.code} ${error.message}`);
        }
      }).catch((error: ESObject) => {
        UtilLog.error(TAG, `unRegisterGestureShareListener getLastWindow error ${error.code} ${error.message}`);
      })
    }
  }

  async getNewsImageUri(imageUrl: string): Promise<string> {
    const firstImg = imageUrl;
    let newsImageUri = ''
    if (firstImg.startsWith('file')) {
      newsImageUri = firstImg;
    } else if (firstImg.startsWith('http')) {
      const buf = await FileUtils.downloadImage(firstImg);
      newsImageUri = FileUtils.saveBufferToSandbox(this.uiContext!,buf);
    } else {
      newsImageUri = '';
    }
    return newsImageUri
  }
}