import { TextReader, TextReaderIcon, ReadStateCode } from '@kit.SpeechKit';
import { emitter, print } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

@Component
export struct FloatingReadNewsComponent {
  @State @Require currentId: string
  @State @Require body: string
  @State @Require title: string
  @State @Require author: string
  @State @Require date: string
  @State bundleName: string = '小艺朗读'
  @State coverImage: string = ''
  @State readInfoList: TextReader.ReadInfo[] = []
  @State localCoverImage: PixelMap | undefined = undefined

  // 朗读状态
  @State readState: ReadStateCode = ReadStateCode.WAITING;
  @State isInit: boolean = false;
  @State readInfo: TextReader.ReadInfo | undefined = undefined;

  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  /**
   * 组件即将出现时的异步回调函数
   */
  async aboutToAppear() {
    // 初始化阅读信息列表
    this.readInfoList = [{
      id: this.currentId,
      title: {
        text: this.title,
        isClickable: true,
      },
      author: {
        text: this.author,
        isClickable: true,
      },
      imageUrl: this.coverImage,
      date: {
        text: this.date,
        isClickable: false,
      },
      bodyInfo: this.body,
    }];

    // 设置当前阅读信息
    this.readInfo = this.readInfoList[0];

    // 初始化TextReader
    await this.initTextReader();

    // 创建事件监听器
    let event: emitter.InnerEvent = {
      eventId: 1,
      priority: emitter.EventPriority.IMMEDIATE,
    };

    // 监听事件并处理回调数据
    emitter.on(event, (data) => {
      console.log(JSON.stringify(data) + '点击事件')
    })
  }

  /**
   * 初始化TextReader
   */
  async initTextReader() {
    const readerParam: TextReader.ReaderParam = {
      isVoiceBrandVisible: true,
      businessBrandInfo: {
        panelName: this.bundleName,
        panelIcon: $r('app.media.startIcon'),
      },
    }
    try {
      await TextReader.init(this.context, readerParam);
      this.isInit = true;
    } catch (err) {
      console.error(`TextReader failed to init. Code: ${err.code}, message: ${err.message}`);
    }
  }

  /**
   * 处理朗读状态变化
   */
  onStateChanged = (state: TextReader.ReadState) => {
    if (this.readInfo?.id === state.id) {
      this.readState = state.state;
    } else {
      this.readState = ReadStateCode.WAITING;
    }
  }

  /**
   * 设置操作监听器
   */
  setActionListener() {
    TextReader.on('stop',()=>{
      console.error('停止播放1')
    });
    TextReader.on('release',()=>{
      console.error('停止播放2')
    });
    TextReader.on('stateChange', (state: TextReader.ReadState) => {
      this.onStateChanged(state)
    });
    TextReader.on('requestMore', () => this.onStateChanged);
    TextReader.on('eventPanel', (pe: TextReader.PanelEvent) => {
      // 监听点击上一条或者下一条音频
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
        // 发送事件
        emitter.emit(event, eventData);
      }
    });
  }
aboutToDisappear(): void {
  TextReader.off('stop');
  TextReader.off('release');
}
  build() {
    Column() {
      // 主要内容区域可以放置新闻详情等

      // 悬浮朗读按钮
      TextReaderIcon({ readState: this.readState })
        .position({ x: '85%', y: '85%' }) // 悬浮定位到右下角
        .zIndex(999)
        .width(48)
        .height(48)
        .backgroundColor('#ffffff')
        .borderRadius(24)
        .shadow({ radius: 6, color: '#00000033' })
        .onClick(async () => {
          try {
            this.setActionListener();
            if (this.readInfoList !== undefined) {
              await TextReader.start(this.readInfoList, this.readInfo?.id);
            }
          } catch (err) {
            console.error(`TextReader failed to start. Code: ${err.code}, message: ${err.message}`);
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
