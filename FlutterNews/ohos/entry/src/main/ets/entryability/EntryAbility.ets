import { FlutterAbility, FlutterEngine } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import { NotificationChannel } from './NotificationChannel';
import { PushChannel } from './PushChannel';
import { AppGalleryChannel } from './AppGalleryChannel';
import { common } from '@kit.AbilityKit';
import { NavigationChannel } from './NavigationChannel';
import window from '@ohos.window';
import { AppUtil } from '@pura/harmony-utils';

export default class EntryAbility extends FlutterAbility {
  configureFlutterEngine(flutterEngine: FlutterEngine): void {
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)



    // 注册通道（完全对齐鸿蒙原生功能）
    const context = this.context as common.UIAbilityContext;

    AppUtil.init(context)
    
    // 创建插件实例并注册到引擎
    const notificationPlugin = new NotificationChannel(context);
    flutterEngine.getPlugins()?.add(notificationPlugin);
    
    const pushPlugin = new PushChannel(context);
    flutterEngine.getPlugins()?.add(pushPlugin);
    
    const appGalleryPlugin = new AppGalleryChannel(context);
    flutterEngine.getPlugins()?.add(appGalleryPlugin);

    // 注册导航通道
    const navigationPlugin = new NavigationChannel(context);
    flutterEngine.getPlugins()?.add(navigationPlugin);

    console.info('[EntryAbility]', '✅ 所有通道注册完成');

  }
}
