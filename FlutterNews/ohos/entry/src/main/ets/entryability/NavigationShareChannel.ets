/**
 * Flutter 和鸿蒙原生页面互相跳转的通道
 */
import { MethodChannel, MethodCall, MethodResult, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { common } from '@kit.AbilityKit';
import { promptAction, router } from '@kit.ArkUI';

import { scanBarcode, scanCore } from '@kit.ScanKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = '[NavigationChannel]';


export class NavigationChannel implements FlutterPlugin {
  private channel?: MethodChannel;
  private context: common.UIAbilityContext;

  constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  getUniqueClassName(): string {
    return 'NavigationChannel';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    console.info(TAG, '🚀 开始注册 NavigationChannel');

    this.channel = new MethodChannel(
      binding.getBinaryMessenger(),
      'com.news.flutter/navigation'
    );

    this.channel.setMethodCallHandler({
      onMethodCall: (call: MethodCall, result: MethodResult): void => {
        console.info(TAG, `⚡ 收到方法调用: ${call.method}`);
        this.handleMethodCall(call, result);
      }
    });

    console.info(TAG, '✅ NavigationChannel 注册成功');
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel) {
      this.channel.setMethodCallHandler(null);
    }
  }

  /**
   * 处理 Flutter 的方法调用
   */
  private handleMethodCall(call: MethodCall, result: MethodResult): void {
    console.info(TAG, `处理方法: ${call.method}`);

    switch (call.method) {
      case 'pushNativePage':
        this.pushNativePage(call.args, result);
        break;
      case 'popNativePage':
        this.popNativePage(result);
        break;
      case 'scan':
        this.scan(result);
        break;
      default:
        console.warn(TAG, `未实现的方法: ${call.method}`);
        result.notImplemented();
        break;
    }
  }

  /**
   * 跳转到鸿蒙原生页面
   */
  private pushNativePage(args: Object, result: MethodResult): void {
    try {

      // args 是一个 Map 对象，使用 Map 的 API 访问
      const argsMap = args as Map<string, Object>;

      // 使用 Map.get() 方法获取值
      const pageName = argsMap.get('pageName') as string;
      const paramsRaw = argsMap.get('params');


      // 将 params 转换为普通对象
      let params: Record<string, Object> = {};

      if (paramsRaw) {
        // 如果 params 也是 Map，需要转换
        if (paramsRaw instanceof Map) {
          console.info(TAG, `params 是 Map，转换中...`);
          const paramsMap = paramsRaw as Map<string, Object>;
          paramsMap.forEach((value: Object, key: string) => {
            params[key] = value;
          });
        } else {
          // 如果是普通对象，直接使用
          params = paramsRaw as Record<string, Object>;
        }
      }

      // 直接使用 router.pushUrl 跳转
      const pageUrl = `pages/${pageName}`;

      router.pushUrl({
        url: pageUrl,
        params: params
      }).then(() => {
        console.info(TAG, `✅ 跳转成功: ${pageName}`);
        result.success(true);
      }).catch((err: Error) => {
        console.error(TAG, `❌ router.pushUrl 失败: ${err.message}`);
        result.success(true);
      });

    } catch (err) {
      const error = err as Error;
      console.error(TAG, `处理异常: ${error.message}`);
      result.error('ERROR', error.message, null);
    }
  }

  /**
   * 返回上一页
   */
  private popNativePage(result: MethodResult): void {
    try {
      console.info(TAG, '🔙 请求返回上一页');

      // 通过 eventHub 通知 Index.ets 执行 pop
      this.context.eventHub.emit('EVENT_POP_PAGE', {});

      console.info(TAG, '✅ 返回事件已发送');
      result.success(true);
    } catch (err) {
      const error = err as Error;
      console.error(TAG, `返回失败: ${error.message}`);
      result.error('POP_ERROR', error.message, null);
    }
  }

  private scan(scanResult: MethodResult): void {
    // 定义扫码参数options
    let options: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.ALL],
      enableMultiMode: true,
      enableAlbum: true,
    };
    try {
      // 可调用getContext接口获取当前页面关联的UIAbilityContext
      scanBarcode.startScanForResult(getContext(this), options).then((result: scanBarcode.ScanResult) => {
        // 解析码值结果跳转应用服务页
        let resultParams: Record<string, string> = JSON.parse(result.originalValue)
        if (!resultParams?.articleId) {
          promptAction.showToast({ message: '扫码错误，仅支持模板内文章海报生成的二维码' })
          return
        }
        let routerParams = {
          'id': resultParams?.articleId,
        } as Record<string, string>
        // RouterToNews.routerToNewsById(routerParams.id)
        scanResult.success(routerParams.id);
      }).catch((error: BusinessError) => {
        let message: string = ''
        if (error.code === 1000500002) {
          // 用户取消扫码
          message = '取消扫码'
        } else {
          message = '扫码错误'
        }
        promptAction.showToast({ message: message })
      });
    } catch (error) {
      promptAction.showToast({ message: '扫码错误' })
    }
  }
}

