/**
 * 通知权限管理通道
 * 完全对齐鸿蒙原生 notificationManager
 */
import { MethodChannel, MethodCall, MethodResult, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { notificationManager } from '@kit.NotificationKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = '[NotificationChannel]';

export class NotificationChannel implements FlutterPlugin {
  private channel?: MethodChannel;
  private context: common.UIAbilityContext;

  constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  getUniqueClassName(): string {
    return 'NotificationChannel';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), 'com.news.flutter/notification');
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
      case 'requestEnableNotification':
        this.requestEnableNotification(result);
        break;
      default:
        console.warn(TAG, `未实现的方法: ${call.method}`);
        result.notImplemented();
        break;
    }
  }

  /**
   * 请求通知权限
   * 对齐鸿蒙 notificationManager.requestEnableNotification
   */
  private requestEnableNotification(result: MethodResult): void {
    notificationManager.requestEnableNotification(this.context, (err: BusinessError) => {
      if (err) {
        console.error(TAG, `请求通知权限失败: code ${err.code}, message ${err.message}`);
        result.success(false);
      } else {
        console.info(TAG, '请求通知权限成功');
        result.success(true);
      }
    });
  }
}

