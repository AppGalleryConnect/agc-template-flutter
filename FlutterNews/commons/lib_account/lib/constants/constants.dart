import 'package:flutter/material.dart';

class Constants {
  // 尺寸常量
  static const double BTN_HEIGHT = 40;
  static const double PADDING_40 = 40;
  static const double START_ICON_WIDTH = 72;
  static const double WAY_ICON_WIDTH = 48;
  static const double WAY_WIDTH = 100;
  static const double INPUT_HEIGHT = 56;
  static const double DEFAULT_LOGIN_SHEET_HEIGHT = 620;
  static const double ICON_MARGIN_TOP = 100;
  static const double OTHER_WAY_MARGIN_TOP = 80;
  static const double CHECKBOX_SIZE = 24;

  // 半模态弹窗相关常量
  static const double SHEET_MIN_EXTENT = 0.30;
  static const double SHEET_INITIAL_EXTENT = 0.89;
  static const double SHEET_MAX_EXTENT = 0.9;
  static const double SHEET_SNAP_EXTENT_MEDIUM = 0.87;
  static const int SHEET_SNAP_ANIMATION_DURATION = 300; // 毫秒
  static const double SHEET_BORDER_RADIUS = 20;

  // 拖动条常量
  static const double DRAG_HANDLE_WIDTH = 40;
  static const double DRAG_HANDLE_HEIGHT = 4;
  static const double DRAG_HANDLE_BORDER_RADIUS = 2;
  static const double DRAG_HANDLE_TOP_PADDING = 15;
  static const double DRAG_HANDLE_BOTTOM_PADDING = 10;

  // 关闭按钮常量
  static const double CLOSE_BUTTON_SIZE = 40;
  static const double CLOSE_BUTTON_BORDER_RADIUS = 30;
  static const double CLOSE_BUTTON_RIGHT_PADDING = 15;
  static const double CLOSE_BUTTON_ICON_SIZE = 20;
  static const double CLOSE_BUTTON_INNER_PADDING = 10;
  static const double CLOSE_BUTTON_MIN_SIZE = 32;

  // 布局间距常量
  static const double ICON_MARGIN = 20;
  static const double LOGIN_BUTTON_MARGIN_TOP = 30;

  // 字体大小常量
  static const double TITLE_FONT_SIZE = 20;
  static const double SUBTITLE_FONT_SIZE = 14;
  static const double BUTTON_FONT_SIZE = 16;
  static const double PHONE_NUMBER_FONT_SIZE = 28;
  static const double BODY_SMALL_FONT_SIZE = 12;

  // 图标缩放常量
  static const double ICON_SCALE_FACTOR = 0.8;

  // 字符串常量
  static const String LOGIN_SHEET_STACK_NAME = 'loginSheetStackName';
  static const String TAG_LOGIN_VM = '[LoginVM]';
  static const String ANONYMOUS_PHONE = '177******96';
  static const String HUAWEI_LOGIN_BUTTON_TEXT = '华为账号一键登录';

  // 微信登录相关
  static const String WECHAT_SCOPE = 'snsapi_userinfo';
  static const String WECHAT_STATE = 'wechat_sdk_demo_test';

  // 默认协议内容
  static const String DEFAULT_USER_PROTOCOL =
      '<html><body><h1>用户协议</h1><p>服务条款内容</p></body></html>';
  static const String DEFAULT_PRIVACY_PROTOCOL =
      '<html><body><h1>隐私政策</h1><p>隐私政策内容</p></body></html>';
  static const String DEFAULT_HUAWEI_PROTOCOL =
      '<html><body><h1>华为账号协议</h1><p>华为账号用户协议内容</p></body></html>';

  // 提示文本
  static const String TOAST_AGREE_PROTOCOL = '请先勾选同意协议';
  static const String TOAST_LOGIN_SUCCESS = '登录成功';
  static const String TOAST_LOGIN_ERROR = '登录异常，请稍后重试';
  static const String TOAST_JUMP_ERROR = '跳转失败，请稍后重试';
  static const String TOAST_INPUT_ACCOUNT = '请输入账号';
  static const String TOAST_INPUT_PASSWORD = '请输入密码';
  static const String TOAST_WECHAT_NOT_INSTALLED = '未安装微信';
  static const String TOAST_INSTALL_WECHAT = '请安装微信后重试';
  static const String TOAST_HUAWEI_NOT_LOGIN = '用户未登录华为账号';
  static const String TOAST_INVALID_CLIENT_ID = '应用未正确配置client_id';
  static const String TOAST_NOT_SCOPE = '应用未申请scopes或permissions权限';
  static const String TOAST_OTHER_ERROR = '其他错误';

  // 协议WebView相关常量
  static const String PROTOCOL_WEBVIEW_DEFAULT_HTML = '''
    <!DOCTYPE html>
    <html lang="zh-CN">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>用户协议</title>
      <style>
        body { font-family: sans-serif; padding: 20px; text-align: center; }
        h1 { color: #333; }
        p { color: #666; font-size: 16px; }
      </style>
    </head>
    <body>
      <h1>用户协议</h1>
      <p>欢迎使用我们的服务，请遵守相关法律法规。</p>
    </body>
    </html>
  ''';

  static const String PROTOCOL_WEBVIEW_ERROR_HTML = '''
    <!DOCTYPE html>
    <html lang="zh-CN">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>加载失败</title>
      <style>
        body { font-family: sans-serif; padding: 20px; text-align: center; }
        h1 { color: #e74c3c; }
        p { color: #666; font-size: 16px; }
      </style>
    </head>
    <body>
      <h1>内容加载失败</h1>
      <p>无法显示协议内容，请稍后再试或联系客服。</p>
    </body>
    </html>
  ''';

  static const String PROTOCOL_WEBVIEW_BASE_URL = 'https://www.example.com';

  // 页面文本常量
  static const String LOGIN_BUTTON_TEXT = '登录';
  static const String OTHER_LOGIN_METHODS_TEXT = '其他方式登录';
  static const String WECHAT_LOGIN_TEXT = '微信';

  // 颜色常量
  static const Color LOGIN_BUTTON_COLOR = Color.fromARGB(255, 92, 121, 217);
  static const Color TEXT_HINT_COLOR = Color(0xFF999999);
  static const Color TEXT_NORMAL_COLOR = Colors.black;
  static const Color TEXT_GRAY_COLOR = Color(0xFF666666);
  static const Color TEXT_LINK_COLOR = Color.fromARGB(255, 105, 132, 219);
  static const Color BORDER_GRAY_COLOR = Color(0xFFCCCCCC);
  static const Color BACKGROUND_COLOR_F5 = Color(0xFFF5F5F5);
  static const Color WEBVIEW_BACKGROUND_COLOR = Color.fromARGB(255, 229, 231, 232);
  static const Color WEBVIEW_PRESSED_COLOR = Color.fromARGB(255, 206, 208, 210);

  // 图标路径常量
  static const String startIconPath = 'assets/startIcon.png';
  static const String huaweiIconPath =
      'packages/lib_account/assets/ic_huawei.png';
  static const String wechatIconPath =
      'packages/lib_account/assets/ic_wechat.png';

  /// 包名 - 用于资源引用
  static const String packageName = 'lib_account';
}
