import { UtilLog } from '@hw-agconnect/util-log';
import { preferences } from '@kit.ArkData';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { FormItemModel } from '../widget/common/Types';

const TAG = '[FormUtils]';

/**
 * 服务卡片工具类
 */
export class FormUtils {
  private static readonly fileName: string = 'form_id_file';
  private static readonly formIdKey: string = 'form_id_key';
  private static readonly formIdEventName: string = 'form_id_event_name';
  public static isSubscribed: boolean = false;

  /**
   * 创建卡片
   * @param formId
   * @param cxt
   */
  public static async addFormId(formId: string, cxt: Context) {
    try {
      const list = FormUtils.getFormIds(cxt);
      if (!list.some((id) => id === formId)) {
        list.push(formId);
        const store = FormUtils.getStore(cxt);
        if (store) {
          store.putSync(FormUtils.formIdKey, list);
          await store.flush();
        }
      }
    } catch (e) {
      UtilLog.error(TAG, 'addFormId fail, error: ' + JSON.stringify(e));
    }
  }

  /**
   * 删除卡片
   * @param formId
   * @param cxt
   */
  public static async delFormId(formId: string, cxt: Context) {
    try {
      const list = FormUtils.getFormIds(cxt);
      const index = list.findIndex((id) => id === formId);
      if (index !== -1) {
        list.splice(index, 1);
        const store = FormUtils.getStore(cxt);
        if (store) {
          store.putSync(FormUtils.formIdKey, list);
          await store.flush();
        }
      }
    } catch (e) {
      UtilLog.error(TAG, 'delFormId fail, error: ' + JSON.stringify(e));
    }
  }

  /**
   * 发布卡片创建/删除事件
   * @param formId
   * @param isDelete
   */
  public static publishFormId(formId: string, isDelete: boolean) {
    try {
      commonEventManager.publish(
        FormUtils.formIdEventName,
        { data: formId, parameters: { isDelete } },
        (err: BusinessError) => {
          if (err) {
            UtilLog.error(TAG, 'Failed to publish form_id_event_name, error: ' + JSON.stringify(err));
          } else {
            UtilLog.info(TAG, 'Succeeded in publish form_id_event_name.');
          }
        },
      );
    } catch (e) {
      UtilLog.error(TAG, `commonEventManager.publish fail. Code: ${e.code}, message: ${e.message}`);
    }
  }

  /**
   * 订阅卡片创建/删除事件
   * @param ctx
   */
  public static async subscribeFormId(ctx: Context, source?: string) {
    UtilLog.info(TAG, 'subscribeFormId source:' + source)
    FormUtils.isSubscribed = true;
    let subscriber: commonEventManager.CommonEventSubscriber | undefined = undefined;
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [FormUtils.formIdEventName],
      publisherPermission: '',
    };
    try {
      commonEventManager.createSubscriber(subscribeInfo, (_err1, data1) => {
        if (data1) {
          subscriber = data1;
          commonEventManager.subscribe(subscriber, async (_err2, data2) => {
            if (data2) {
              if (data2.parameters?.isDelete) {
                FormUtils.delFormId(data2.data as string, ctx);
              } else {
                FormUtils.addFormId(data2.data as string, ctx);
              }
              UtilLog.info(TAG, 'Succeeded in creating subscribeFormId.');
            }
          });
        }
      });
    } catch (e) {
      UtilLog.error(TAG, `subscribe fail. Code: ${e.code}, message: ${e.message}`);
    }
  }

  /**
   * 获取卡片id列表
   * @param ctx
   * @returns
   */
  public static getFormIds(ctx: Context) {
    try {
      const store = FormUtils.getStore(ctx);
      if (store) {
        return store.getSync(FormUtils.formIdKey, []) as string[];
      }
      return [];
    } catch (e) {
      UtilLog.error(TAG, 'getSync fail, error: ' + JSON.stringify(e));
      return [];
    }
  }

  /**
   * 获取持久化
   * @param ctx
   * @returns
   */
  private static getStore(ctx: Context) {
    try {
      return preferences.getPreferencesSync(ctx, { name: FormUtils.fileName });
    } catch (e) {
      UtilLog.error(TAG, 'getPreferencesSync fail, error: ' + JSON.stringify(e));
      return undefined;
    }
  }

  /**
   * 卡片默认列表数据
   * @returns
   */
  public static getDefaultFormData() {
    const data: FormItemModel[] = [
      new FormItemModel('article_1', '中方决定同意与美方进行接触'),
      new FormItemModel('article_2', '一揽子金融政策打出“组合拳”'),
      new FormItemModel('article_3', '中俄两国走出一条合作共赢的崭新道路'),
    ];
    return JSON.stringify(data);
  }
}