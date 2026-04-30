import { ShareKinds, ShareSheetParams } from '../model/Model'
import { firstShareList } from '../constants/Constants'
import { componentSnapshot } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'
import { PosterShare } from '../utils/SystemShare'
import { WxShareViewModel } from '../viewModel/WxShareViewModel'
import { PopViewUtils } from '../utils/PopViewUtils'
import { UtilLog } from '@hw-agconnect/util-log'

const TAG = '[FirstPosterShare]'

@Builder
export function FirstPosterShareBuilder(params: ShareSheetParams) {
  FirstPosterShare({
    params: params,
  })
}

@ComponentV2
export struct FirstPosterShare {
  @Local shareList: ShareKinds[][] = firstShareList
  @Param posterShare: PosterShare = new PosterShare()
  @Require @Param params: ShareSheetParams
  @Local wxShareViewModel: WxShareViewModel = WxShareViewModel.instance

  build() {
    List() {
      ForEach(this.shareList, (item: ShareKinds[]) => {
        ListItem() {
          Row({ space: 29 }) {
            ForEach(item, (value: ShareKinds) => {
              Column({ space: 8 }) {
                Image($r(value.icon)).width(48).height(48)
                Text(value.name)
                  .fontSize(12)
                  .fontColor($r('sys.color.font_primary'))
              }
              .onClick(() => {
                switch (value.id) {
                  case 'create_poster':
                    try {
                      let pixelMap = componentSnapshot.getSync(this.params.qrCodeInfo.id)
                      UtilLog.info(TAG, `get ${this.params.qrCodeInfo.id} snapshot sync success!`);
                      this.params.onPost(true, pixelMap)
                    } catch (error) {
                      UtilLog.error(`getSync ${this.params.qrCodeInfo.id} errorCode: ` + error.code + ' message: ' +
                      error.message);
                    }
                    break
                  case 'wechat':
                    this.wxShareViewModel.newsWebShare(this.params.qrCodeInfo)
                    break;
                  case 'wechat_feed':
                    this.wxShareViewModel.newsWebShare(this.params.qrCodeInfo)
                    break;
                  case 'qq':
                    // this.qqShareViewModel.share(this.params.qrCodeInfo)
                    break
                  case 'system_share':
                    this.posterShare.share(this.params.qrCodeInfo)
                    break
                  case 'copy_link':
                    this.posterShare.copy()
                    break
                }
                PopViewUtils.closeSheet()
              })
            })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .margin({ top: 30 })
        }
      })
      ListItem() {
        Button('取消')
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .width('100%')
          .fontColor($r('sys.color.font_primary'))
          .padding({ top: 8, bottom: 8 })
          .margin({ bottom: 16, top: 16 })
          .onClick(() => {
            PopViewUtils.closeSheet()
          })
      }
    }
    .padding({ left: 16, right: 16 })
  }
}