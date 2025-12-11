import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lib_news_api/params/response/layout_response.dart'
    show AuthorInfo;
import 'package:lib_widget/components/nav_header_bar.dart';
import 'package:business_mine/viewmodels/message_im_chat_vm.dart' as chat_vm;
import 'package:lib_news_api/constants/constants.dart' show ChatEnum;
import 'package:lib_news_api/database/message_type.dart' show ChatInfoDetail;
import 'package:lib_common/models/window_model.dart';
import '../constants/constants.dart';
import '../utils/font_scale_utils.dart';

class MsgIMChatPage extends StatefulWidget {
  final Map<String, dynamic>? params;

  const MsgIMChatPage({super.key, this.params});

  @override
  State<MsgIMChatPage> createState() => _MsgIMChatPageState();
}

class _MsgIMChatPageState extends State<MsgIMChatPage> {
  late final chat_vm.MsgIMChatViewModel _vm;
  final TextEditingController textController = TextEditingController();
  final WindowModel windowModel = WindowModel();

  @override
  void initState() {
    super.initState();
    _vm = chat_vm.MsgIMChatViewModel(params: widget.params);
    _vm.initData();
    _vm.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    textController.dispose();
    _vm.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundLightGrayColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: NavHeaderBar(
          title: _getNavBarTitle(),
          onBack: () {
            _vm.onBackPressed();
          },
          windowModel: windowModel,
          customTitleSize:
              Constants.textHeaderSize * FontScaleUtils.fontSizeRatio,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Constants.newsCardWhiteColor,
              child: ListView.builder(
                padding: const EdgeInsets.all(Constants.dialogPadding),
                itemCount: _vm.chatList.length,
                itemBuilder: (context, index) {
                  final message = _vm.chatList[index];
                  return _buildMessageItem(message);
                },
              ),
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(dynamic message) {
    if (message is ChatInfoDetail) {
      final type = message.type;
      final content = message.content;
      final isSentByMe = message.isMyself ?? false;
      if (type == ChatEnum.time) {
        return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(
                vertical: Constants.messageItemVerticalPadding),
            child: Text(
              content,
              style: TextStyle(
                  fontSize: Constants.textSecondarySize *
                      FontScaleUtils.fontSizeRatio,
                  color: Constants.textSecondaryColor),
            ));
      }
      return Container(
        margin: const EdgeInsets.symmetric(
            vertical: Constants.messageItemTextSpacing * 2),
        child: Row(
          mainAxisAlignment:
              isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSentByMe)
              GestureDetector(
                onTap: () => _vm.jumpTAProfile(),
                child: CircleAvatar(
                  backgroundImage: (_vm.chatAuthor?.authorIcon ?? '').isNotEmpty
                      ? NetworkImage(_vm.chatAuthor!.authorIcon)
                      : const AssetImage(Constants.defaultIconPath)
                          as ImageProvider,
                  radius: Constants.avatarRadius,
                ),
              ),
            const SizedBox(width: Constants.messageItemHorizontalSpacing / 2),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Container(
                padding: const EdgeInsets.all(
                    Constants.messageItemHorizontalSpacing),
                decoration: BoxDecoration(
                  color: isSentByMe
                      ? Constants.primaryButtonColor
                      : Constants.messageItemIconBgColor,
                  borderRadius:
                      BorderRadius.circular(Constants.newsCardBorderRadius),
                ),
                child: type == ChatEnum.text
                    ? Text(
                        content,
                        style: TextStyle(
                          color: isSentByMe
                              ? Colors.white
                              : Constants.textPrimaryColor,
                          fontSize: Constants.textPrimarySize *
                              FontScaleUtils.fontSizeRatio,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: null,
                      )
                    : type == ChatEnum.image
                        ? content.startsWith('http')
                            ? Image.network(
                                content,
                                width: Constants.newsImageWidth * 2,
                                height: Constants.newsImageHeight * 2.8,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(content),
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                        : Text(
                            content,
                            style: TextStyle(
                              color: Constants.textSecondaryColor,
                              fontSize: Constants.textSecondarySize *
                                  FontScaleUtils.fontSizeRatio,
                            ),
                            // 确保文本可以换行
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: null,
                          ),
              ),
            ),
            const SizedBox(width: Constants.messageItemHorizontalSpacing / 2),
            if (isSentByMe)
              GestureDetector(
                onTap: () => _vm.jumpMyProfile(),
                child: CircleAvatar(
                  backgroundImage:
                      _vm.userInfoModel.authorIcon.trim().isNotEmpty
                          ? NetworkImage(_vm.userInfoModel.authorIcon)
                          : const AssetImage(Constants.defaultIconPath)
                              as ImageProvider,
                  radius: Constants.avatarRadius,
                ),
              ),
          ],
        ),
      );
    }
    return Container();
  }

  String _getNavBarTitle() {
    // 优先使用聊天作者的名称
    if (_vm.chatAuthor != null && _vm.chatAuthor!.authorNickName.isNotEmpty) {
      return _vm.chatAuthor!.authorNickName;
    }
    // 尝试从params中直接获取
    if (widget.params != null) {
      // 检查params是否为AuthorInfo类型
      if (widget.params is AuthorInfo) {
        final authorInfo = widget.params as AuthorInfo;
        if (authorInfo.authorNickName.isNotEmpty) {
          return authorInfo.authorNickName;
        }
      } else if (widget.params is Map<String, dynamic>) {
        final name =
            widget.params!['authorName'] ?? widget.params!['authorNickName'];
        if (name != null && name.toString().isNotEmpty) {
          return name.toString();
        }
      }
    }
    // 如果都没有，返回空字符串而不是默认值
    return '';
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.only(
          left: Constants.messageItemHorizontalSpacing / 2,
          right: Constants.messageItemHorizontalSpacing / 2,
          bottom: Constants.dialogPadding,
          top: Constants.messageItemHorizontalSpacing / 2),
      decoration: const BoxDecoration(
        color: Constants.newsCardWhiteColor,
        border: Border(top: BorderSide(color: Constants.dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: '输入',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 2, horizontal: Constants.dialogPadding),
                filled: true,
                fillColor: Constants.backgroundLightGrayColor,
              ),
              // 添加键盘发送功能
              onSubmitted: (text) {
                final trimmedText = text.trim();
                if (trimmedText.isNotEmpty) {
                  _vm.sendMessage(
                    trimmedText,
                    'text',
                    DateTime.now().millisecondsSinceEpoch,
                  );
                  textController.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          // 发送表情按钮
          IconButton(
            onPressed: () {
              _showEmojiSelector();
            },
            icon: const Icon(Icons.emoji_emotions_outlined),
            color: Constants.textSecondaryColor,
          ),
          // 发送图片按钮
          IconButton(
            onPressed: () {
              _pickAndSendImage();
            },
            icon: const Icon(Icons.image_outlined),
            color: Constants.textSecondaryColor,
          ),
        ],
      ),
    );
  }

  // 显示表情选择器
  void _showEmojiSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: Constants.messageBottomContainerHeight * 6.25,
          padding: const EdgeInsets.all(Constants.dialogPadding),
          decoration: const BoxDecoration(
            color: Constants.newsCardWhiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constants.dialogBorderRadius * 0.57),
              topRight: Radius.circular(Constants.dialogBorderRadius * 0.57),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '选择表情',
                style: TextStyle(
                  fontSize:
                      Constants.textPrimarySize * FontScaleUtils.fontSizeRatio,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: Constants.dialogPadding),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    crossAxisSpacing: Constants.messageItemTextSpacing,
                    mainAxisSpacing: Constants.messageItemTextSpacing,
                  ),
                  itemCount: chatEmojis.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // 将选择的表情添加到输入框
                        textController.text += chatEmojis[index];
                        Navigator.pop(context);
                      },
                      child: Center(
                          child: Text(chatEmojis[index],
                              style: TextStyle(
                                  fontSize: Constants.textHeaderSize *
                                      FontScaleUtils.fontSizeRatio))),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 选择并发送图片
  void _pickAndSendImage() {
    // 显示图片来源选择对话框
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(Constants.dialogPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constants.dialogCircular),
              topRight: Radius.circular(Constants.dialogCircular),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('拍照',
                    style: TextStyle(
                        fontSize: Constants.textPrimarySize *
                            FontScaleUtils.fontSizeRatio)),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('从相册选择',
                    style: TextStyle(
                        fontSize: Constants.textPrimarySize *
                            FontScaleUtils.fontSizeRatio)),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: Text('取消',
                    style: TextStyle(
                        fontSize: Constants.textPrimarySize *
                            FontScaleUtils.fontSizeRatio)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 从指定来源获取图片
  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80, // 压缩图片质量
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        // 这里应该上传图片到服务器获取URL
        // 由于是示例，我们使用本地路径作为临时URL
        // 在实际应用中，应该调用上传API并获取服务器返回的URL
        final imageUrl = pickedFile.path;

        // 发送图片消息
        _vm.sendMessage(
          imageUrl,
          'image',
          DateTime.now().millisecondsSinceEpoch,
        );
      }
    } catch (e) {
      print('选择图片失败: $e');
      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('选择图片失败，请重试',
                style: TextStyle(
                    fontSize: Constants.buttonTextSize *
                        FontScaleUtils.fontSizeRatio))),
      );
    }
  }
}
