import { HashMap } from '@kit.ArkTS'
import { image } from '@kit.ImageKit'

export class AddressInfo {
  countryName: string = ''           // 国家
  administrativeArea: string = ''    // 省/州
  locality: string = ''             // 城市
  thoroughfare: string = ''         // 街道
  description: string = ''          // 完整地址描述
}
export class TextReaderResult{
  state :string = ''
  params:Map<string,string> = new Map()
}


export class TextReaderModel{
  currentId:string = ''
  body:string = ''
  title:string = ''
  author:string = ''
  date:string = ''
  imageUrl:string = ''
}

export class ShareOptions {
  id: string = ''
  type: string | number = ''
  title: string = ''
  createTime: string = ''
  coverUrl:string | undefined = ''
  isVideo:boolean = false
  articleFrom?: string | undefined = ''
}

export class ShareKinds {
  id: string = ''
  icon: string = ''
  name: string = ''
}

export class ScreenInfo {
  screenWidth: number = 0
  screenHeight: number = 0
}

export class PopupBaseController {
  hide: () => void = () => {
  }
}

export interface NewsQrCode {
  articleId: string
  type: string | number
}


export class QqShareData {
  shareJson: string = ''
  timestamp: number = new Date().getTime()
  nonce: number = 0
  shareJsonSign: string = ''
}

export interface QqShareContent {
  msg_style: number
  title: string
  url: string
  picture_url: string
}

export class QqShareResult {
  resultType: ShareResultType = 0;
  code: number = 0;
  message: string | undefined | null = undefined;
  detail: string | undefined | null = undefined;
  extra: HashMap<string, string> = new HashMap();
}

export enum ShareResultType {
  Success = 1,
  Cancel = 2,
  Error = 3
}

export interface ShareSheetParams {
  onPost: (isOpen: boolean, pixmap: image.PixelMap) => void
  qrCodeInfo: ShareOptions
}
