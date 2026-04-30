import { MethodChannel, MethodCall, MethodResult, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { storageStatistics } from '@kit.CoreFileKit';
import { UtilLog } from '@hw-agconnect/util-log';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { FileUtils } from '../pages/utils/FileUtils';


const TAG = '[CacheChannel]';

export class CacheChannel implements FlutterPlugin {
  private cacheChannel?: MethodChannel;
  private context: common.UIAbilityContext;

  constructor(uiContext: common.UIAbilityContext) {
    this.context = uiContext;
  }

  getUniqueClassName(): string {
    return 'CacheChannel';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.cacheChannel = new MethodChannel(binding.getBinaryMessenger(), 'com.news.flutter/cacheChannel');
    this.cacheChannel.setMethodCallHandler({
      onMethodCall: (call: MethodCall, result: MethodResult): void => {
        this.handleCacheMethodCall(call, result);
      }
    });
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.cacheChannel) {
      this.cacheChannel.setMethodCallHandler(null);
    }
  }

  /**
   * 处理Flutter调用
   */
  private handleCacheMethodCall(call: MethodCall, result: MethodResult): void {
    console.info(TAG, `收到Flutter调用: ${call.method}`);

    switch (call.method) {
      case 'getCache':
        this.getCache(result);
        break;
      case 'clearCache':
        this.clearCache(this.context);
        break;
      default:
        console.warn(TAG, `未实现的方法: ${call.method}`);
        result.notImplemented();
        break;
    }
  }


  getCache(result: MethodResult) {
    return storageStatistics.getCurrentBundleStats().then((bundleStats: storageStatistics.BundleStats) => {
      const cacheSize = ( bundleStats.cacheSize / 1024 / 1024).toFixed(2);
      result.success( `${cacheSize}M`)
      UtilLog.info(TAG, 'getCurrentBundleStats successfully:' + JSON.stringify(bundleStats));
    }).catch((e: BusinessError) => {
      UtilLog.error(TAG, 'getCurrentBundleStats fail, error: ' + JSON.stringify(e));
    });
  }

  clearCache(context: Context) {
    FileUtils.getPaths(context).then((paths) => {
      paths.forEach((cacheDir) => {
        FileUtils.deleteFile(cacheDir);
      })
    })
  }
}

