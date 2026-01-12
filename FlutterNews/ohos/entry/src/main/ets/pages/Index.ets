import common from '@ohos.app.ability.common';
import { FlutterPage, MethodChannel } from '@ohos/flutter_ohos'
import { emitter } from '@kit.BasicServicesKit';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
import * as wXOpenSdk from '@tencent/wechat_open_sdk';
import { JSON } from '@kit.ArkTS';
import { ReadStateCode, TextReader } from '@kit.SpeechKit';


interface HoveringEventData {
  isHovering: boolean;
  angle: number;
  timestamp: number;
  deviceType: string;
  accuracy: string;
}

interface DisplayFeaturesInfo {
  isDualScreen: boolean;
  hingeAngle: number;
  isHovering: boolean;
  deviceType: string;
  timestamp: number;
  foldStatus?: number;
  foldStatusText?: string;
}

let storage = LocalStorage.getShared()
const EVENT_BACK_PRESS = 'EVENT_BACK_PRESS'
const METHOD_CHANNEL_NAME = 'com.news.flutter/navigation'


@Entry(storage)
@Component
struct Index {
  @LocalStorageLink('viewId') viewId: string = "";
  private context = getContext(this) as common.UIAbilityContext
  @State readInfoList: TextReader.ReadInfo[] = []
  @State localCoverImage: PixelMap | undefined = undefined
  @State readState: ReadStateCode = ReadStateCode.WAITING;
  @State isInit: boolean = false;
  @State readInfoId: string = '';
  @State newsId: string = '';
  @State newsContent: string = '';
  @State newsTitle: string = '';
  @State newsAuthor: string = '';
  @State newsDate: string = '';
  @State bundleName: string = '';
  @State coverImage: string = '';
  @State fromPage: string = '';
  @State isReading: boolean = false;
  @State showFloatingComponent: boolean = false;
  @State isMonitoringHinge: boolean = false



  async aboutToAppear() {
    // 初始化TextReader
    await this.initTextReader();
    // 开始朗读
    this.setActionListener();

    let event: emitter.InnerEvent = {
      eventId: 10000,
      priority: emitter.EventPriority.IMMEDIATE,
    };
    emitter.on(event, (data) => {
      console.log(JSON.stringify(data) + '分享点击事件')
      let contentStr = data['data'] as Record<string, string>;
      let contentTitle = contentStr["params"];
      let sharedData: systemShare.SharedData = new systemShare.SharedData({
        utd: utd.UniformDataType.TEXT,
        content: contentTitle
      });
      let controller: systemShare.ShareController = new systemShare.ShareController(sharedData);
      let uiContext: UIContext = this.getUIContext();
      let context: common.UIAbilityContext = uiContext.getHostContext() as common.UIAbilityContext;
      controller.on('dismiss', () => {
        console.info('Share panel closed');
      });
      controller.show(context, {
        anchor: 'shareButtonId'
      });
      controller.show(context, {
        anchor: {
          windowOffset: { x: 100, y: 100 },
          size: { width: 0, height: 0 }
        }
      });
    })
    let wxEvent: emitter.InnerEvent = {
      eventId: 10001,
      priority: emitter.EventPriority.IMMEDIATE,
    };
    emitter.on(wxEvent, async (data1) => {
      let wXApi = wXOpenSdk.WXAPIFactory.createWXAPI('wxc92d9d6570127a32')
      if (!wXApi.isWXAppInstalled()) {
        AlertDialog.show({ message: JSON.stringify('请先安装微信') })
      } else {
        const sendAuthReq = new wXOpenSdk.SendAuthReq();
        sendAuthReq.scope = "snsapi_userinfo";
        sendAuthReq.state = Math.random().toString(36).substring(2);
        wXApi.sendReq(getContext() as common.UIAbilityContext, sendAuthReq)
      }
    })
    let AIEvent: emitter.InnerEvent = {
      eventId: 10003,
      priority: emitter.EventPriority.IMMEDIATE,
    };
    emitter.on(AIEvent, async (data1) => {
      if (data1?.data?.['params']) {
        this.readInfoId = data1?.data?.params.get('currentId') ?? ''
        this.readInfoList = [
          {
            id: this.readInfoId ?? '',
            title: {
              text: data1?.data?.params.get('title') ?? '',
              isClickable: true,
            },
            author: {
              text: data1?.data?.params.get('author') ?? '',
              isClickable: true,
            },
            date: {
              text: data1?.data?.params.get('date') ?? '',
              isClickable: true,
            },
            imageUrl: data1?.data?.params.get('coverImage') ?? '',
            bodyInfo: data1?.data?.params.get('body') ?? '',
          }
        ];
      }
      try {
        if (!this.isReading) {
          if (this.readInfoList) {
            await TextReader.start(this.readInfoList, this.readInfoId);
            this.isReading = true;
          }
        } else {
          await TextReader.stop();
          TextReader.off('stateChange');
          TextReader.off('requestMore');
          TextReader.off('eventPanel');
          this.isReading = false;
          this.readState = ReadStateCode.WAITING;
        }
      } catch (err) {
        console.error(`TextReader failed to start/stop. Code: ${err.code}, message: ${err.message}`);
      }
    })
    this.cleanupTextReader();
  }

  /**
   * 初始化TextReader
   */
  async initTextReader() {
    const readerParam: TextReader.ReaderParam = {
      isVoiceBrandVisible: true,
      businessBrandInfo: {
        panelName: this.bundleName,
        panelIcon: $r('app.media.startIcon')
      }
    }
    try {
      await TextReader.init(this.context, readerParam);
      this.isInit = true;
      console.info("TextReader初始化成功");
    } catch (err) {
      console.error(`初始化失败 Code: ${err.code}, message: ${err.message}`);
      this.isInit = false;
    }
  }

  /**
   * 处理朗读状态变化
   */
  onStateChanged = (state: TextReader.ReadState) => {
    if (this.readInfoId === state.id) {
      this.readState = state.state;
    } else {
      this.readState = ReadStateCode.WAITING;
    }
  }

  /**
   * 设置操作监听器
   */
  setActionListener() {
    TextReader.on('stop', () => {
      console.log('TextReader stopped');
      TextReader.off('stop');
      TextReader.off('release');
      this.isReading = false;
      this.readState = ReadStateCode.WAITING;
    });
    TextReader.on('stop', () => {
      console.log('TextReader released by floating window close button');
      // 完全清理TextReader资源
      this.cleanupTextReader();
    });
    TextReader.on('stateChange', (state: TextReader.ReadState) => {
      this.onStateChanged(state)
    });
    TextReader.on('requestMore', () => this.onStateChanged);
    TextReader.on('eventPanel', (pe: TextReader.PanelEvent) => {
      if (pe.click === 'BPC_03' || pe.click === 'BPC_04') {
        let event: emitter.InnerEvent = {
          eventId: 1,
          priority: emitter.EventPriority.IMMEDIATE,
        };
        let eventData: emitter.EventData = {
          data: {
            state: pe.id,
          },
        };
        emitter.emit(event, eventData);
      }
    });
  }

  /**
   * 清理TextReader资源
   */
  cleanupTextReader() {
    console.log('TextReader resources cleaned up completely');
    TextReader.stop();
    TextReader.off('stateChange');
    TextReader.off('requestMore');
    TextReader.off('eventPanel');
    this.isReading = false;
    this.readState = ReadStateCode.WAITING;

  }

  aboutToDisappear(): void {
    console.log('开始清理资源...');
    if (this.isReading) {
      TextReader.stop().then(() => {
        TextReader.release();
      }).catch(() => {
        console.error(`释放失败: `);
      });
      this.isReading = false;
    }
    this.isInit = false;
    let AIEvent: emitter.InnerEvent = {
      eventId: 10003,
      priority: emitter.EventPriority.IMMEDIATE,
    };
    emitter.off(AIEvent.eventId);
    this.isMonitoringHinge = false;
    this.cleanupTextReader();
    console.log('资源清理完成');
  }

  build() {
    Column() {
      FlutterPage({ viewId: this.viewId })

    }
  }

  onBackPress(): boolean {
    this.context.eventHub.emit(EVENT_BACK_PRESS)
    return true
  }
}