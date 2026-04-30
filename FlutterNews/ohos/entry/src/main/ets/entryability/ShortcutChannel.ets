import { AppStorageV2 } from '@kit.ArkUI';
import { MethodChannel, MethodCall, MethodResult, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { ShortcutRouter } from '../common/Types';


const TAG = '[ShortcutChannel]';

export class ShortcutChannel implements FlutterPlugin {
  private shortcutChannel?: MethodChannel;

  getUniqueClassName(): string {
    return 'ShortcutChannel';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.shortcutChannel = new MethodChannel(binding.getBinaryMessenger(), 'com.news.flutter/shortcutChannel');
    this.shortcutChannel.setMethodCallHandler({
      onMethodCall: (call: MethodCall, result: MethodResult): void => {
        this.handleShortcutMethodCall(call, result);
      }
    });
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.shortcutChannel) {
      this.shortcutChannel.setMethodCallHandler(null);
    }
  }

  /**
   * 处理Flutter调用
   */
  private handleShortcutMethodCall(call: MethodCall, result: MethodResult): void {
    console.info(TAG, `收到Flutter调用: ${call.method}`);

    switch (call.method) {
      case 'callShortcutData':
        this.getShortcutData(result);
        break;
      default:
        console.warn(TAG, `未实现的方法: ${call.method}`);
        result.notImplemented();
        break;
    }
  }

  /**
   * 获取快捷方式数据
   */
  private getShortcutData(result: MethodResult): void {
    let shortcutModel: ShortcutRouter = AppStorageV2.connect(ShortcutRouter, () => new ShortcutRouter())!;
    console.log('getShortcutData',JSON.stringify(shortcutModel))
    result.success(shortcutModel);
  }
}

