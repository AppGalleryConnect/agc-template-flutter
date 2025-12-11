import 'package:flutter/material.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_news_api/services/message_service.dart'
    show messageServiceApi, MessageObserver, MessageUpdateType;
import 'package:lib_news_api/services/author_service.dart';
import '../common/observed_model.dart';
import 'package:lib_news_api/params/response/author_response.dart';
import 'package:lib_news_api/params/response/message_response.dart';
import 'dart:developer' as developer;
import '../constants/constants.dart';

class MsgIMViewModel extends ChangeNotifier implements MessageObserver {
  List<BriefIMModel> chatList = [];

  MsgIMViewModel() {
    messageServiceApi.addObserver(this);
  }

  @override
  void dispose() {
    messageServiceApi.removeObserver(this);
    super.dispose();
  }

  @override
  void onMessageUpdated(MessageUpdateType type) {
    if (type == MessageUpdateType.IM || type == MessageUpdateType.All) {
      queryList();
    }
  }

  Future<void> queryList() async {
    try {
      final resp = await messageServiceApi.queryAllIMList();
      chatList = resp
          .where((v) => v.chatAuthorId.isNotEmpty)
          .map((v) {
            // 获取作者信息
            final authorInfo = authorServiceApi.queryAuthorInfo(v.chatAuthorId);
            // 创建AuthorResponse
            final authorResponse = AuthorResponse(
              authorId: v.chatAuthorId,
              authorNickName: authorInfo?.authorNickName ?? '未知用户',
              authorIcon: authorInfo?.authorIcon ??
                  'https://example.com/default_avatar.jpg',
              authorDesc: authorInfo?.authorDesc ?? '',
              authorIp: '',
              watchersCount: authorInfo?.watchersCount ?? 0,
              followersCount: authorInfo?.followersCount ?? 0,
              likeNum: authorInfo?.likeNum ?? 0,
            );
            // 创建BriefIMResponse
            final imResponse = BriefIMResponse(
              chatAuthor: authorResponse,
              allUnreadCount: v.allUnreadCount,
              receiveTime: v.receiveTime,
              latestNews: v.latestNews,
              chatList: [],
            );
            // 创建BriefIMModel
            return BriefIMModel(imResponse);
          })
          .where((model) =>
              model.chatAuthor.authorNickName.isNotEmpty &&
              model.chatAuthor.authorNickName != '未知用户')
          .toList();
      notifyListeners();
    } catch (e) {
      // 错误处理
      developer.log('Query IM list error: $e',
          name: 'business_mine.message_im_list_vm');
    }
  }

  Future<void> setAllRead() async {
    try {
      // 只调用setIMAllRead，让观察者机制自动处理UI刷新
      await messageServiceApi.setIMAllRead();
    } catch (e) {
      // 错误处理
      developer.log('Set all read error: $e',
          name: 'business_mine.message_im_list_vm');
    }
  }

  // WebView控制器映射
  final Map<String, dynamic> _controllerMap = {};

  // Web属性配置类
  Map<String, dynamic> _createWebProperties() {
    return {
      'webId': WebIdMap.chatWebId.id,
      'title': '聊天',
      'url': '/chat',
      'resourceConfigs': [
        {
          'type': 'json',
          'name': 'chat_config',
          'resource': '{"enableEmoji":true,"enableImage":true}'
        },
        {'type': 'string', 'name': 'version', 'resource': '1.0.0'}
      ],
    };
  }

  // 创建Web视图
  void createWeb(BuildContext context) {
    try {
      // 检查控制器映射中是否已存在ChatWebId
      if (!_controllerMap.containsKey(WebIdMap.chatWebId.id)) {
        _controllerMap[WebIdMap.chatWebId.id] = true;
        developer.log('已标记Chat WebView控制器',
            name: 'business_mine.message_im_list_vm');
      }

      // 创建Web属性
      final webProperties = _createWebProperties();

      // 调用createNWeb方法
      _createNWeb(context, webProperties);
    } catch (e) {
      developer.log('创建Web视图失败: $e',
          name: 'business_mine.message_im_list_vm', error: e);
    }
  }

  // 创建Native Web视图
  void _createNWeb(BuildContext context, Map<String, dynamic> webProperties) {
    try {
      // 检查控制器映射中是否已存在ChatWebId
      if (_controllerMap.containsKey(WebIdMap.chatWebId.id) &&
          _controllerMap[WebIdMap.chatWebId.id] == true) {
        developer.log('Chat WebView控制器已存在，无需重复创建',
            name: 'business_mine.message_im_list_vm');
        return;
      }

      // 免拦截注入的离线资源如图片、样式表和脚本资源
      final resourceConfigs = [
        {
          'localPath': 'news_tra_2.jpg',
          'urlList': [
            'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_2.jpg',
          ],
          'type': 'IMAGE',
        },
        {
          'localPath': 'news_tra_3.jpg',
          'urlList': [
            'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_3.jpg',
          ],
          'type': 'IMAGE',
        }
      ];

      // 合并资源配置
      final mergedWebProperties = Map<String, dynamic>.from(webProperties);
      mergedWebProperties['resourceConfigs'] = resourceConfigs;

      RouterUtils.of.pushPathByName(
        '/protocol/webView',
        param: {
          'content': mergedWebProperties['url'],
          'title': mergedWebProperties['title'],
          'webId': mergedWebProperties['webId'],
          'resourceConfigs': mergedWebProperties['resourceConfigs'],
        },
      );
      developer.log('已跳转至WebView页面，标题: ${mergedWebProperties['title']}',
          name: 'business_mine.message_im_list_vm');
    } catch (e) {
      developer.log('创建Native Web视图失败: $e',
          name: 'business_mine.message_im_list_vm', error: e);
    }
  }

  void jumpChatPage(BriefIMModel v) {
    RouterUtils.of.pushPathByName(
      '/mine/msg/im_chat',
      param: v.chatAuthor.authorId,
      onPop: (_) {
        queryList();
      },
    );
  }

  bool get allowClean {
    return chatList.any((v) => v.allUnreadCount != 0);
  }

  ValueNotifier<List<BriefIMModel>> get imList {
    return ValueNotifier(chatList);
  }

  bool get hasUnread {
    return allowClean;
  }

  /// 删除指定作者的私信
  Future<void> deleteIM(String authorId) async {
    try {
      await messageServiceApi.deleteIM(authorId);
      chatList.removeWhere((v) => v.chatAuthor.authorId == authorId);
      notifyListeners();
    } catch (e) {
      developer.log('Delete IM error: $e',
          name: 'business_mine.message_im_list_vm');
    }
  }

  Future<void> deleteAll() async {
    try {
      List<BriefIMModel> copy = List.from(chatList);
      for (BriefIMModel model in copy) {
        if (model.isSelect) {
          await messageServiceApi.deleteIM(model.chatAuthor.authorId);
          chatList.removeWhere(
              (v) => v.chatAuthor.authorId == model.chatAuthor.authorId);
        }
      }
      notifyListeners();
    } catch (e) {
      developer.log('Delete IM error: $e',
          name: 'business_mine.message_im_list_vm');
    }
  }

  bool isShowSelect = false;

  void onClickShow(bool isShow) {
    isShowSelect = isShow;

    for (BriefIMModel model in chatList) {
      model.isDelete = false;
      model.isSelect = false;
    }
    notifyListeners();
  }

  int get deleteCount {
    int i = 0;
    for (BriefIMModel model in chatList) {
      if (model.isSelect) i++;
    }
    return i;
  }

  bool get isSelectAll {
    bool isSelectAll = true;
    for (BriefIMModel model in chatList) {
      if (!model.isSelect) isSelectAll = false;
    }
    return isSelectAll;
  }

  void onSelectAll(bool isSelectAll) {
    for (BriefIMModel model in chatList) {
      model.isSelect = !isSelectAll;
    }
    notifyListeners();
  }
}
