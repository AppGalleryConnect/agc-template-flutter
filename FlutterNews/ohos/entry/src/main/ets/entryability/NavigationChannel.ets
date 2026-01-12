/**
 * Flutter 和鸿蒙原生页面互相跳转的通道
 */
import { MethodChannel, MethodCall, MethodResult, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { promptAction, router } from '@kit.ArkUI';
import { scanBarcode, scanCore } from '@kit.ScanKit';
import { emitter, BusinessError } from '@kit.BasicServicesKit';
import geoLocationManager from '@ohos.geoLocationManager';
import { LogUtil } from '@pura/harmony-utils';
import { abilityAccessCtrl, bundleManager, common, Permissions} from "@kit.AbilityKit"

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
    console.info(TAG, `处理参数: ${call.args}`);

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
      case 'location':
        this.location(result);
        break;
      case 'share':
        const argsMap = call.args as Map<string, Object>;
        const paramsRaw = argsMap.get('params');
        let params: Record<string, Object> = {};
        if (paramsRaw) {
          if (paramsRaw instanceof Map) {
            console.info(TAG, `params 是 Map，转换中...`);
            const paramsMap = paramsRaw as Map<string, Object>;
            paramsMap.forEach((value: Object, key: string) => {
              params[key] = value;
            });
          } else {
            params = paramsRaw as Record<string, Object>;
          }
        }
        let event: emitter.InnerEvent = {
          eventId: 10000,
          priority: emitter.EventPriority.IMMEDIATE,
        };

        let eventData: emitter.EventData = {
          data: params,
        };
        emitter.emit(event, eventData);
        break;
      case 'wxShare':
        let wxEvent: emitter.InnerEvent = {
          eventId: 10001,
          priority: emitter.EventPriority.IMMEDIATE,
        };

        let wxEventData: emitter.EventData = {
          data: {
            state: '10001',
          },
        };
        emitter.emit(wxEvent, wxEventData);
        break;
      case 'AInews':
        let AIEvent: emitter.InnerEvent = {
          eventId: 10003,
          priority: emitter.EventPriority.IMMEDIATE,
        };

        let AIEventData: emitter.EventData = {
          data: {
            state: '10003',
            params: call.args,
          },
        };
        emitter.emit(AIEvent, AIEventData);
        break;
      case 'FoldVideo':
        let FoldEvent: emitter.InnerEvent = {
          eventId: 10009,
          priority: emitter.EventPriority.IMMEDIATE,
        };

        let FoldEventData: emitter.EventData = {
          data: {
            state: '10009',
            params: call.args,
          },
        };
        emitter.emit(FoldEvent, FoldEventData);
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

      this.context.eventHub.emit('EVENT_POP_PAGE', {});

      console.info(TAG, '✅ 返回事件已发送');
      result.success(true);
    } catch (err) {
      const error = err as Error;
      console.error(TAG, `返回失败: ${error.message}`);
      result.error('POP_ERROR', error.message, null);
    }
  }

  async location(scanResult: MethodResult) {
    this.checkPermissions(['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION']).then(() => {
      geoLocationManager.getCurrentLocation().then(async location => {
        let reverseGeocodeRequest: geoLocationManager.ReverseGeoCodeRequest = {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'maxItems': 1
        };
          const result = await geoLocationManager.getAddressesFromLocation(reverseGeocodeRequest);
          if (result.length > 0) {
            const firstAddress: geoLocationManager.GeoAddress = result[0];
            const city: string = firstAddress.locality || ''; // 城市
            console.log(TAG, '获取地址成功：' + JSON.stringify(firstAddress));
            scanResult.success({
              city: city,
            });
          }
      }).catch((err: BusinessError) => {
        LogUtil.error(TAG, 'getCurrentLocation catch err: ' + JSON.stringify(err))
      })
    }).catch((err: BusinessError) => {
      // LogUtil.error
      LogUtil.error(TAG, 'getCurrentLocation catch err: ' + JSON.stringify(err))
    })

  }

  /**
   * 校验应用是否被授予定位权限
   * @returns
   */
  async checkPermissions(permissions: Permissions[]): Promise<void> {
    try {
      const result = permissions.every((permission) => {
        let grantStatus: abilityAccessCtrl.GrantStatus = this.checkAccessToken(permission)
        return grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
      })
      if (!result) {
        await this.requestPermissions(permissions)
      }
    } catch (error) {
      LogUtil.error(TAG, `checkPermissions error` + JSON.stringify(error))
    }
  }

  /**
   * 如果没有被授予定位权限，动态向用户申请授权
   */
  async requestPermissions(permissions: Permissions[]): Promise<void> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
    try {
      await atManager.requestPermissionsFromUser(this.context, permissions)
      LogUtil.info(TAG, 'requestPermissions LOCATION & APPROXIMATELY_LOCATION success')
    } catch (error) {
      LogUtil.error(TAG, 'requestPermissions error = %{public}s', JSON.stringify(error))
    }
  }

  /**
   * @param 检查访问令牌
   * @returns
   */
  checkAccessToken(permission: Permissions): abilityAccessCtrl.GrantStatus {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
    // 获取应用程序的accessTokenID
    let tokenId: number = 0
    let bundleInfo: bundleManager.BundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo
    tokenId = appInfo.accessTokenId
    // 校验应用是否被授予权限
    grantStatus = atManager.checkAccessTokenSync(tokenId, permission)
    return grantStatus
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

