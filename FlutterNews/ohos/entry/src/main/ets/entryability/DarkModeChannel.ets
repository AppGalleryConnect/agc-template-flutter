import { MethodChannel, MethodCall, MethodResult, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { uiAppearance } from '@kit.ArkUI';

const TAG = '[DarkModeChannel]';

export class DarkModeChannel implements FlutterPlugin {
  private darkModeChannel?: MethodChannel;
  private context: common.UIAbilityContext;

  constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  getUniqueClassName(): string {
    return 'DarkModeChannel';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.darkModeChannel = new MethodChannel(binding.getBinaryMessenger(), 'com.news.flutter/darkModeChange');
    this.darkModeChannel.setMethodCallHandler({
      onMethodCall: (call: MethodCall, result: MethodResult): void => {
        this.handleDarkModeMethodCall(call, result);
      },
    });
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.darkModeChannel) {
      this.darkModeChannel.setMethodCallHandler(null);
    }
  }

  /**
   * 处理Flutter调用
   */
  private handleDarkModeMethodCall(call: MethodCall, result: MethodResult): void {
    console.info(TAG, `收到Flutter调用: ${call.method}`);

    switch (call.method) {
      case 'darkModeChange':
        this.darkModeChange(call);
        break;
      case 'querySystemMode':
        this.querySystemMode(call, result);
        break;
      default:
        console.warn(TAG, `未实现的方法: ${call.method}`);
        result.notImplemented();
        break;
    }
  }

  /**
   * 设置应用主题
   */
  private darkModeChange(call: MethodCall): void {
    console.log('darkModeChange接收到调用', call.args)
    this.context?.getApplicationContext().setColorMode(call.args ? 0 : 1);
  }

  /**
   * 查询系统主题
   */
  private querySystemMode(call: MethodCall, result: MethodResult): void {
    let darkMode = uiAppearance.getDarkMode();
    let mode = darkMode === 0
    console.log('querySystemMode接收到调用', mode, darkMode);
    result.success(mode);
  }
}

