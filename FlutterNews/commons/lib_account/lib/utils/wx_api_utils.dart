import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:lib_common/lib_common.dart';

const String kTag = 'WXApiEventHandlerImpl';

/// 注意：需要在实际项目中配置微信AppID
/// 这里使用临时值，需要替换为真实的AppID
const String WX_APPID = 'your_wechat_appid_here';

/// WXApi 是第三方app和微信通信的openApi接口
class WXApi {
  static final WXApi _instance = WXApi._internal();
  factory WXApi() => _instance;

  WXApi._internal() {
    // 初始化微信SDK
    fluwx.registerWxApi(
      appId: WX_APPID,
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: '',
    );
  }
}

/// WXApiEventHandler为微信数据的回调
class WXApiEventHandlerImpl {
  final Set<OnWXReq> _onReqCallbacks = {};
  final Set<OnWXResp> _onRespCallbacks = {};

  /// 注册微信请求回调
  void registerOnWXReqCallback(OnWXReq callback) {
    _onReqCallbacks.add(callback);
  }

  /// 取消注册微信请求回调
  void unregisterOnWXReqCallback(OnWXReq callback) {
    _onReqCallbacks.remove(callback);
  }

  /// 注册微信响应回调
  void registerOnWXRespCallback(OnWXResp callback) {
    _onRespCallbacks.add(callback);
  }

  /// 取消注册微信响应回调
  void unregisterOnWXRespCallback(OnWXResp callback) {
    _onRespCallbacks.remove(callback);
  }

  /// 处理微信请求
  void onReq(dynamic req) {
    Logger.info(kTag, 'onReq: $req');
    for (final callback in _onReqCallbacks) {
      callback(req);
    }
  }

  /// 处理微信响应
  void onResp(dynamic resp) {
    Logger.info(kTag, 'onResp: $resp');
    for (final callback in _onRespCallbacks) {
      callback(resp);
    }
  }
}

/// 微信API实例
final wxApi = WXApi();

/// 微信事件处理器实例
final wxEventHandler = WXApiEventHandlerImpl();

/// 微信请求回调类型
typedef OnWXReq = void Function(dynamic req);

/// 微信响应回调类型
typedef OnWXResp = void Function(dynamic resp);
