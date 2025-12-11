import 'package:flutter/material.dart';
import 'package:lib_common/constants/pop_view_utils.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_common/dialogs/common_confirm_dialog.dart';
import 'package:lib_news_api/lib_news_api.dart';
import 'package:module_post/module_post.dart';

/// 发布帖子视图模型
class PublishPostViewModel extends ChangeNotifier {
  /// 帖子内容文本
  String _body = '';

  /// 帖子内容文本的getter
  String get body => _body;

  /// 帖子内容文本的setter
  set body(String value) {
    _body = value;
    notifyListeners(); 
  }

  /// 媒体列表
  List<PostImgVideoItem> _mediaList = [];

  /// 媒体列表的getter
  List<PostImgVideoItem> get mediaList => _mediaList;

  /// 媒体列表的setter
  set mediaList(List<PostImgVideoItem> value) {
    _mediaList = value;
    notifyListeners(); 
  }

  /// 底部内边距（键盘高度）
  double paddingBottom = 0;

  /// 字体大小比例（默认值）
  double fontSizeRatio = 1.0;

  /// 检查是否可以发布帖子
  bool enablePublish() {
    if (body.isNotEmpty) {
      return true;
    }
    if (mediaList.isNotEmpty) {
      return true;
    }
    return false;
  }

  /// 发布帖子
  Future<void> publishPost() async {
    if (!enablePublish()) {
      return;
    }

    final params = PostRequest(
      postBody: body,
      postImgList: mediaList
          .map((item) => PostImgList(
                picVideoUrl: item.picVideoUrl,
                surfaceUrl: item.surfaceUrl, 
              ))
          .toList(),
    );

    PostServiceApi.publishPost(params);
    EventHubUtils.getInstance().emit(EventEnum.postPublished, []);

    RouterUtils.of.pop();
    toast('发布成功');
  }

  /// 处理返回按钮按下事件
  bool onBackPressed(BuildContext context) {
    if (enablePublish()) {
      CommonConfirmDialog.show(
        context,
        IConfirmDialogParams(
          primaryTitle: '温馨提示',
          content: '当前内容未发表，返回将丢失。是否确认返回？',
          priBtnV: '取消',
          secBtnV: '确认',
          cancel: () {
          },
          confirm: () {
            RouterUtils.of.pop();
          },
        ),
      );
      return true;
    }
    return false;
  }

  /// 开启键盘高度监听
  void onKeyBoard() {
  }

  /// 关闭键盘高度监听
  void offKeyBoard() {
  }
}
