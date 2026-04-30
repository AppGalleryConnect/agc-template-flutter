import { BusinessError } from '@kit.BasicServicesKit';
import { cloudResPrefetch } from '@kit.CloudFoundationKit';
import { UtilLog, LogConfig } from '@hw-agconnect/util-log';
import { CloudRecommendListResult } from '../models/PreloadModel';
import { RequestListData } from '../models/ResponseModel';


const TAG = '[CloudPrefetchUtils]'

/**
 * 预加载工具类
 */
export class CloudPrefetchUtils {
  /**
   * 获取安装预加载数据
   * 预加载指南：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/cloudfoundation-prefetch-overview
   */
  public static functionPreload() {
    try {
      cloudResPrefetch.getPrefetchResult(cloudResPrefetch.PrefetchMode.INSTALL_PREFETCH)
        .then((data: cloudResPrefetch.PrefetchResult) => {
          let result: RequestListData[] =
            (data.result as CloudRecommendListResult<RequestListData[]>).recommendList as RequestListData[];
          AppStorage.setOrCreate('recommendList', result);
          UtilLog.info(TAG,
            `Succeeded in getting install prefetch data, result: ${JSON.stringify(data.result)}`);
        }).catch(async (err: BusinessError) => {
        UtilLog.error(TAG, `Failed to get install prefetch data, code: ${err.code}, message: ${err.message}`);
        AppStorage.setOrCreate('recommendList', []);
      });
    } catch (err) {
      UtilLog.error(TAG, `Failed to get install prefetch data, code: ${err.code}, message: ${err.message}`);
    }
  }
}