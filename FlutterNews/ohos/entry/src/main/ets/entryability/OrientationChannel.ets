import { MethodChannel, MethodCall, MethodResult, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { common } from '@kit.AbilityKit';
import { display, window } from '@kit.ArkUI';
import { UtilLog } from '@hw-agconnect/util-log';
import { sensor } from '@kit.SensorServiceKit';

const TAG = '[OrientationChannel]';

export class OrientationChannel implements FlutterPlugin {
  private orientationChannel?: MethodChannel;
  private uiContext: common.UIAbilityContext

  constructor(uiContext: common.UIAbilityContext) {
    this.uiContext = uiContext;
  }

  getUniqueClassName(): string {
    return 'OrientationChannel';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.orientationChannel = new MethodChannel(binding.getBinaryMessenger(), 'com.news.flutter/orientationChannel');
    this.orientationChannel.setMethodCallHandler({
      onMethodCall: (call: MethodCall, result: MethodResult): void => {
        this.handleOrientationMethodCall(call, result);
      },
    });
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.orientationChannel) {
      this.orientationChannel.setMethodCallHandler(null);
    }
  }

  /**
   * 处理Flutter调用
   */
  private handleOrientationMethodCall(call: MethodCall, result: MethodResult): void {
    console.info(TAG, `收到Flutter调用: ${call.method}`);

    switch (call.method) {
      case 'handleOrientation':
        this.handleOrientation(call);
        break;
      case 'quitFullScreen':
        this.quitFullScreen(call);
        break;
      default:
        console.warn(TAG, `未实现的方法: ${call.method}`);
        result.notImplemented();
        break;
    }
  }

  /**
   * 进入全屏
   */
  async handleOrientation(call: MethodCall) {
    try {
      await this.setOrientation(window.Orientation.LANDSCAPE)
    } catch (e) {
      UtilLog.error(TAG, 'handleOrientation fail, error: ' + JSON.stringify(e));
    }
  }

  /**
   * 检测设备是否水平放置
   * @param callback
   */
  private isDevicePlaceFlat(callback: (isFlat: boolean) => void): void {
    // 阈值常量
    const GRAVITY = 9.8; // 标准重力加速度
    const Z_THRESHOLD = 1.5; // Z轴允许误差范围
    const XY_THRESHOLD = 1.0; // X/Y轴倾斜阈值
    try {
      sensor.once(sensor.SensorId.GRAVITY, (data: sensor.GravityResponse) => {
        // 判断Z轴是否接近重力加速度绝对值
        const isZValid = Math.abs(Math.abs(data.z) - GRAVITY) < Z_THRESHOLD;
        // 判断设备是否水平（X/Y轴接近0）
        const isHorizontal = Math.abs(data.x) < XY_THRESHOLD && Math.abs(data.y) < XY_THRESHOLD;
        UtilLog.debug(TAG, `Success query sensor gravity, isFlat: ${isZValid && isHorizontal}`);
        callback(isZValid && isHorizontal)
      })
    } catch (e) {
      UtilLog.error(TAG, `Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
      callback(false);
    }
  }

  /**
   * 退出全屏
   */
  private quitFullScreen(call: MethodCall) {
    this.isDevicePlaceFlat((isFlat) => {
      // 默认是跟随桌面
      let orientation = window.Orientation.FOLLOW_DESKTOP;
      if (isFlat) {
        // 如果设备平放在桌面，设置为临时竖屏
        orientation = window.Orientation.USER_ROTATION_PORTRAIT;
      }
      this.setOrientation(orientation)
    })
  }

  private async setOrientation(orientation: number): Promise<void> {
    try {
      UtilLog.debug(TAG, 'setPreferredOrientation: ' + orientation);
      let context: common.UIAbilityContext = this.uiContext as common.UIAbilityContext
      await context.windowStage.getMainWindowSync().setPreferredOrientation(orientation)
    } catch (e) {
      UtilLog.error(TAG, 'setOrientation fail, error: ' + JSON.stringify(e));
    }
  }
}

