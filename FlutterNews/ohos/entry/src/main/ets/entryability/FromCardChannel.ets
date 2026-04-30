import { AppStorageV2 } from '@kit.ArkUI';
import { MethodChannel, MethodCall, MethodResult, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { AppLinkingRouter, FormCardRouter } from '../common/Types';


const TAG = '[FormCardChannel]';

export class FormCardChannel implements FlutterPlugin {
  private formCardChannel?: MethodChannel;

  getUniqueClassName(): string {
    return 'FormCardChannel';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.formCardChannel = new MethodChannel(binding.getBinaryMessenger(), 'com.news.flutter/formCardChannel');
    this.formCardChannel.setMethodCallHandler({
      onMethodCall: (call: MethodCall, result: MethodResult): void => {
        this.handleFormCardMethodCall(call, result);
      }
    });
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.formCardChannel) {
      this.formCardChannel.setMethodCallHandler(null);
    }
  }

  /**
   * 处理Flutter调用
   */
  private handleFormCardMethodCall(call: MethodCall, result: MethodResult): void {
    console.info(TAG, `收到Flutter调用: ${call.method}`);

    switch (call.method) {
      case 'callFormCardData':
        this.getFormCardData(result);
        break;
      case 'callFormAppLinkingData':
        this.getFormAppLinkingData(result);
        break;
      default:
        console.warn(TAG, `未实现的方法: ${call.method}`);
        result.notImplemented();
        break;
    }
  }

  /**
   * 获取服务卡片数据
   */
  private getFormCardData(result: MethodResult): void {
    let formCardModel: FormCardRouter = AppStorageV2.connect(FormCardRouter, () => new FormCardRouter())!;
    console.log('getFormCardData',JSON.stringify(formCardModel))
    result.success(formCardModel);
  }

  /**
   * 获取AppLinking数据
   */
  private getFormAppLinkingData(result: MethodResult): void {
    const appLinkRouter: AppLinkingRouter =
      AppStorageV2.connect(AppLinkingRouter, () => new AppLinkingRouter())!;
    console.log('appLinkRouter',JSON.stringify(appLinkRouter))
    result.success(appLinkRouter);
  }
}

