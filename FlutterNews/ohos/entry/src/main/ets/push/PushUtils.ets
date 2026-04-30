import { pushService } from '@kit.PushKit';
import { BusinessError } from '@kit.BasicServicesKit';
import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import { PushModel } from './Model';
import { UtilLog } from '@hw-agconnect/util-log';

export class PushUtils {
  /**
   * 获取push推送token
   **/
  public static async getTokenSyn(): Promise<string> {
    try {
      const pushToken = await pushService.getToken();
      return pushToken;
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      UtilLog.error('get token', 'Get push token catch error: %{public}d %{public}s');
      return '';
    }
  }

  /**
   * 本地使用push rest api mock云端推送
   **/
  public static async pushMessage(articleList: ESObject) {
    /*
     * 这里的Authorization需要开发者自行获取，详情见readme
     * */
    axios.post('https://push-api.cloud.huawei.com/v3/461323198430147922/messages:send',
      PushUtils.pushMessageParams(articleList), {
        headers: {
          'Content-Type': 'application/json',
          'push-type': 0,
          'Authorization': 'Bearer ',
        },
      })
      .then((resp: AxiosResponse) => {
        UtilLog.info('push success', JSON.stringify(resp))
      })
      .catch((err: AxiosError) => {
        UtilLog.info('push err' + err)
      })
  }

  /**
   * 本地使用mock 随机云端推送
   **/
  public static async randomPushMessage(articleList: ESObject) {
    PushUtils.pushMessage(articleList)
  }

  /**
   * push kit 推送请求体
   * @param pushToken
   * @returns
   */
  public static pushMessageParams(articleList: ESObject): PushModel {
    return {
      'payload': {
        'notification': {
          'category': 'MARKETING',
          'title': '新闻模板',
          'image': articleList.postImgList?.[0]?.picVideoUrl,
          'body': articleList?.title,
          'clickAction': {
            'actionType': 0,
            'data': {
              'articleInfo': {
                'newsId': articleList?.id,
                'authorId': articleList?.authorId,
                'type': articleList?.type,
              },
            },
          },
          'notifyId': 0,
          'badge': { 'addNum': 1 },
        },
      },
      target: {
        'token': [AppStorage.get('pushToken') ?? ''],
      },
      pushOptions: {
        'testMessage': true,
      },
    }
  }
}