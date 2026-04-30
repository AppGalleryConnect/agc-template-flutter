import { FlutterAbility, FlutterEngine } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import { NotificationChannel } from './NotificationChannel';
import { PushChannel } from './PushChannel';
import { AppGalleryChannel } from './AppGalleryChannel';
import { AbilityConstant, common, Want } from '@kit.AbilityKit';
import { NavigationChannel } from './NavigationChannel';
import { AppUtil } from '@pura/harmony-utils';
import { CloudPrefetchUtils } from '../utils/CloudPrefetchUtils';
import { PreloadChannel } from './PreloadChannel';
import BatteryPlugin from './BreakpointChannel';
import { DarkModeChannel } from './DarkModeChannel';
import { WantUtils } from '../common/WantUtils';
import { FormCardChannel } from './FromCardChannel';
import { ShortcutChannel } from './ShortcutChannel';
import { OrientationChannel } from './OrientationChannel';
import { CacheChannel } from './CacheChannel';


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

    const preloadChannel = new PreloadChannel(context);
    flutterEngine.getPlugins()?.add(preloadChannel);

    const appGalleryPlugin = new AppGalleryChannel(context);
    flutterEngine.getPlugins()?.add(appGalleryPlugin);

    const breakpointPlugin = new BatteryPlugin()
    flutterEngine.getPlugins()?.add(breakpointPlugin);

    const darkModePlugin = new DarkModeChannel(context)
    flutterEngine.getPlugins()?.add(darkModePlugin);

    const formCardChannel = new FormCardChannel()
    flutterEngine.getPlugins()?.add(formCardChannel);

    const shortcutChannel = new ShortcutChannel()
    flutterEngine.getPlugins()?.add(shortcutChannel);

    const orientationChannel = new OrientationChannel(context)
    flutterEngine.getPlugins()?.add(orientationChannel);

    const cacheChannel = new CacheChannel(context)
    flutterEngine.getPlugins()?.add(cacheChannel);

    // 注册导航通道
    const navigationPlugin = new NavigationChannel(context);
    flutterEngine.getPlugins()?.add(navigationPlugin);
    console.info('[EntryAbility]', '✅ 所有通道注册完成');
  }
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onCreate(want, launchParam)
    CloudPrefetchUtils.functionPreload();
    WantUtils.handlePushCall(want)
    WantUtils.handlePushWant(want);
    WantUtils.handleAppLinkingWant(want);
    WantUtils.handleFormCardCall(want);
    WantUtils.handleShortcutWant(want);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onNewWant(want, launchParam)
    WantUtils.handlePushWant(want);
    WantUtils.handleAppLinkingWant(want);
    WantUtils.handleFormCardCall(want);
    WantUtils.handleShortcutWant(want);
  }
}
