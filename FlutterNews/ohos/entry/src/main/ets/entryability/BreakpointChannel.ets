import {
  Any,
  EventChannel,
  FlutterPlugin,
  Log,
  MethodChannel,
} from '@ohos/flutter_ohos';
import { FlutterPluginBinding } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import { EventSink } from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';

const TAG = "BatteryPluginTag";

export default class BatteryPlugin implements FlutterPlugin {
  private channel?: MethodChannel;
  private eventChannel?: EventChannel;

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    AppStorage.setOrCreate('binding', binding.getBinaryMessenger())
    this.eventChannel = new EventChannel(binding.getBinaryMessenger(), "samples.flutter.dev/event_channel");
    this.eventChannel.setStreamHandler({
      onListen(args: Any, events: EventSink): void {
        this.eventSink = events;
        Log.i(TAG, "onListen: " + args);
      },
      onCancel(args: Any): void {
        this.eventSink = undefined;
        Log.i(TAG, "onCancel: " + args);
      }
    });
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    Log.i(TAG, "onDetachedFromEngine");
    this.channel?.setMethodCallHandler(null);
    this.eventChannel?.setStreamHandler(null);
  }

  getUniqueClassName(): string {
    return "BatteryPlugin";
  }
}
