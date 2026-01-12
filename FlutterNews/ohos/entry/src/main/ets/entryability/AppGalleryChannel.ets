/**
 * 应用市场更新通道
 * 完全对齐鸿蒙原生 AppGalleryUtils.ets
 */
import { MethodChannel, MethodCall, MethodResult, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { updateManager } from '@kit.StoreKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = '[AppGalleryChannel]';

export class AppGalleryChannel implements FlutterPlugin {
  private channel?: MethodChannel;
  private context: common.UIAbilityContext;

  constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  getUniqueClassName(): string {
    return 'AppGalleryChannel';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), 'com.news.flutter/app_gallery');
    this.channel.setMethodCallHandler({
      onMethodCall: (call: MethodCall, result: MethodResult): void => {
        this.handleMethodCall(call, result);
      }
    });
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel) {
      this.channel.setMethodCallHandler(null);
    }
  }

  /**
   * 处理Flutter调用
   */
  private handleMethodCall(call: MethodCall, result: MethodResult): void {
    console.info(TAG, `收到Flutter调用: ${call.method}`);

    switch (call.method) {
      case 'checkAppUpdate':
        this.checkAppUpdate(result);
        break;
      case 'showUpdateDialog':
        this.showUpdateDialog(result);
        break;
      default:
        console.warn(TAG, `未实现的方法: ${call.method}`);
        result.notImplemented();
        break;
    }
  }

  /**
   * 检查应用是否有更新版本
   * 完全对齐鸿蒙原生 AppGalleryUtils.checkAppUpdate
   */
  private checkAppUpdate(result: MethodResult): void {
    updateManager.checkAppUpdate(this.context)
      .then((checkResult: updateManager.CheckUpdateResult) => {
        console.info(TAG, 'Succeeded in checking Result updateAvailable:' + checkResult.updateAvailable);
        const hasUpdate = checkResult.updateAvailable === updateManager.UpdateAvailableCode.LATER_VERSION_EXIST;
        console.info(TAG, `检测结果: ${hasUpdate ? '有新版本' : '已是最新版本'}`);
        result.success(hasUpdate);
      })
      .catch((error: BusinessError) => {
        console.error(TAG, `checkAppUpdate onError.code is ${error.code}, message is ${error.message}`);
        result.success(false);
      });
  }

  /**
   * 显示应用更新对话框
   * 完全对齐鸿蒙原生 AppGalleryUtils.showUpdateDialog
   */
  private showUpdateDialog(result: MethodResult): void {
    updateManager.showUpdateDialog(this.context)
      .then((resultCode: updateManager.ShowUpdateResultCode) => {
        console.info(TAG, 'Succeeded in showing UpdateDialog resultCode:' + resultCode);
        result.success(true);
      })
      .catch((error: BusinessError) => {
        console.error(TAG, `showUpdateDialog onError.code is ${error.code}, message is ${error.message}`);
        result.success(false);
      });
  }
}

