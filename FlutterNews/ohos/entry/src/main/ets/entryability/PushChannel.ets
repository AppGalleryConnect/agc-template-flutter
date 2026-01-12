/**
 * Push Kit 推送通道
 * 完全对齐鸿蒙原生 PushUtils.ets
 */
import { MethodChannel, MethodCall, MethodResult, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { pushService } from '@kit.PushKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

const TAG = '[PushChannel]';

// 定义推送消息相关的接口（对应 ArkTS 强类型要求）
interface ArticleInfo {
  articleId: string;
  authorId: string;
  type: string;
}

interface ClickActionData {
  articleInfo: ArticleInfo;
}

interface ClickAction {
  actionType: number;
  data: ClickActionData;
}

interface Badge {
  addNum: number;
}

interface Notification {
  category: string;
  title: string;
  image: string;
  body: string;
  clickAction: ClickAction;
  notifyId: number;
  badge: Badge;
}

interface Payload {
  notification: Notification;
}

interface Target {
  token: string[];
}

interface PushOptions {
  testMessage: boolean;
}

interface PushMessageParams {
  payload: Payload;
  target: Target;
  pushOptions: PushOptions;
}

export class PushChannel implements FlutterPlugin {
  private channel?: MethodChannel;
  private context: common.UIAbilityContext;

  constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  getUniqueClassName(): string {
    return 'PushChannel';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), 'com.news.flutter/push');
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
      case 'getToken':
        this.getToken(result);
        break;
      case 'pushMessage':
        this.pushMessage(call.args, result);
        break;
      default:
        console.warn(TAG, `未实现的方法: ${call.method}`);
        result.notImplemented();
        break;
    }
  }

  /**
   * 获取Push Token
   * 对齐鸿蒙 pushService.getToken()
   */
  private getToken(result: MethodResult): void {
    pushService.getToken()
      .then((pushToken: string) => {
        console.info(TAG, `获取Push Token成功: ${pushToken}`);
        // 保存到全局存储（对齐鸿蒙 AppStorage）
        AppStorage.setOrCreate('pushToken', pushToken);
        result.success(pushToken);
      })
      .catch((err: BusinessError) => {
        console.error(TAG, `获取Push Token失败: code ${err.code}, message ${err.message}`);
        result.success('');
      });
  }

  /**
   * 发送推送消息（Mock）
   * 对齐鸿蒙 PushUtils.pushMessage
   * 
   * 注意：这是一个Mock实现，实际生产环境需要：
   * 1. 配置华为开发者账号的 Push Kit 服务
   * 2. 获取有效的 Authorization token
   * 3. 后端服务器触发推送（而不是前端直接调用）
   */
  private pushMessage(args: ESObject, result: MethodResult): void {
    const title = args['title'] as string || '新闻模板';
    const body = args['body'] as string || '';
    const image = args['image'] as string || '';
    const articleId = args['articleId'] as string || '';
    const authorId = args['authorId'] as string || '';
    const type = args['type'] as string || '';

    console.info(TAG, `准备推送消息: title=${title}, body=${body}`);

    // 获取Push Token
    const pushToken = AppStorage.get<string>('pushToken') as string;
    
    if (!pushToken) {
      console.error(TAG, 'Push Token为空，无法推送');
      result.success(false);
      return;
    }

      // 构建推送参数（对齐鸿蒙 PushModel）
      const articleInfo: ArticleInfo = {
        articleId: articleId,
        authorId: authorId,
        type: type,
      };

      const clickActionData: ClickActionData = {
        articleInfo: articleInfo,
      };

      const clickAction: ClickAction = {
        actionType: 0,
        data: clickActionData,
      };

      const badge: Badge = {
        addNum: 1,
      };

      const notification: Notification = {
        category: 'MARKETING',
        title: title,
        image: image,
        body: body,
        clickAction: clickAction,
        notifyId: 0,
        badge: badge,
      };

      const payload: Payload = {
        notification: notification,
      };

      const target: Target = {
        token: [pushToken],
      };

      const pushOptions: PushOptions = {
        testMessage: true,
      };

      const pushParams: PushMessageParams = {
        payload: payload,
        target: target,
        pushOptions: pushOptions,
      };

    console.info(TAG, '推送参数构建完成，实际生产环境需要调用华为Push Kit REST API');
    console.info(TAG, JSON.stringify(pushParams));

    // TODO: 实际生产环境需要调用华为Push Kit REST API
    // const url = 'https://push-api.cloud.huawei.com/v3/{appId}/messages:send';
    // 需要配置 Authorization: Bearer {token}
    
    // Mock: 直接返回成功
    console.info(TAG, 'Mock推送成功');
    result.success(true);
  }
}

