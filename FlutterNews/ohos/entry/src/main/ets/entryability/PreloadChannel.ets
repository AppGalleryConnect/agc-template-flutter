import { MethodChannel, MethodCall, MethodResult, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { common } from '@kit.AbilityKit';

const TAG = '[PreloadChannel]';

export class PreloadChannel implements FlutterPlugin {
  private preloadChannel?: MethodChannel;
  private context: common.UIAbilityContext;

  constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  getUniqueClassName(): string {
    return 'PreloadChannel';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.preloadChannel = new MethodChannel(binding.getBinaryMessenger(), 'com.news.flutter/preload');
    this.preloadChannel.setMethodCallHandler({
      onMethodCall: (call: MethodCall, result: MethodResult): void => {
        this.handlePreloadMethodCall(call, result);
      }
    });
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.preloadChannel) {
      this.preloadChannel.setMethodCallHandler(null);
    }
  }

  /**
   * 处理Flutter调用
   */
  private handlePreloadMethodCall(call: MethodCall, result: MethodResult): void {
    console.info(TAG, `收到Flutter调用: ${call.method}`);

    switch (call.method) {
      case 'getPreloadData':
        this.getPreloadData(result);
        break;
      default:
        console.warn(TAG, `未实现的方法: ${call.method}`);
        result.notImplemented();
        break;
    }
  }

  /**
   * 获取预加载数据
   */
  private getPreloadData(result: MethodResult): void {
    result.success(AppStorage.get('recommendList'));
  }
}

