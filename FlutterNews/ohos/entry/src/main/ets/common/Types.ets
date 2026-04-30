/**
 * 服务卡片-数据模型
 */
export class FormCardData {
  data: string = '';
}

/**
 * 服务卡片-跳转模型
 */
export class FormCardRouter {
  id: number = 0;
  pageUrl: string = '';
  newsId: string = '';
  newsType: number = 0;
}

/**
 * AppLinking-跳转模型
 */
@ObservedV2
export class AppLinkingRouter {
  id: number = 0;
  newsId: string = '';
  newsType: number = 0;
}

/**
 * 快捷方式-跳转模型
 */

export class ShortcutRouter {
  pageName: string = '';
}