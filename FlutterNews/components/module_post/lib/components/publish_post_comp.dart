import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lib_common/constants/pop_view_utils.dart';
import 'package:module_post/constants/constants.dart';
import 'package:module_post/utils/media_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PublishPostComp extends StatefulWidget {
  // 字体大小比例
  final double fontRatio;
  // 图片参数
  final MediaParams imageParams;
  // 视频参数
  final MediaParams videoParams;
  // grid列数
  final int columnsNum;
  // 图文变化的回调
  final Function(String body, List<PostImgVideoItem> mediaList) onChange;
  // 是否是暗色模式
  final bool isDark;

  const PublishPostComp({
    super.key,
    this.fontRatio = 1,
    required this.imageParams,
    required this.videoParams,
    this.columnsNum = 3,
    required this.onChange,
    this.isDark = false,
  });

  @override
  PublishPostCompState createState() => PublishPostCompState();
}

class PublishPostCompState extends State<PublishPostComp> {
  // 内容文本
  String body = '';
  // 图片列表
  List<PostImgVideoItem> imgList = [];
  // 视频列表
  List<PostImgVideoItem> videoList = [];
  // 键盘高度
  double keyboardHeight = 0;
  // 文本编辑控制器
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: body);
    _textEditingController.addListener(() {
      setState(() {
        body = _textEditingController.text;
        onContentChange();
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget buildVideoWidget(String url, int index) {
    if (url.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.video_library,
              size: Constants.SPACE_48, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      child: Image.file(
        File(url),
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.video_library,
                  size: Constants.SPACE_48, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  // 内容变化时通知父组件
  void onContentChange() {
    widget.onChange(body, [...imgList, ...videoList]);
  }

  // 文本区域组件
  Widget textArea() {
    final textColor =
        widget.isDark ? Constants.TEXT_DARK_COLOR : Constants.TEXT_COLOR;
    final hintColor =
        widget.isDark ? Constants.HINT_DARK_COLOR : Constants.HINT_COLOR;

    return Container(
      height: Constants.SPACE_200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
      ),
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: '畅所欲言，发表你的想法',
          hintStyle: TextStyle(
            fontSize: Constants.FONT_16 * widget.fontRatio,
            color: hintColor,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          counterText: '',
        ),
        style: TextStyle(
          fontSize: Constants.FONT_16 * widget.fontRatio,
          color: textColor,
        ),
        maxLength: Constants.MAX_BODY_WORD_LIMIT,
        maxLines: null,
        expands: false,
        keyboardType: TextInputType.multiline,
        scrollPhysics: const AlwaysScrollableScrollPhysics(),
      ),
    );
  }

  // 媒体区域组件
  Widget mediaArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.columnsNum,
            crossAxisSpacing: Constants.SPACE_12,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemCount:
              imgList.length + videoList.length + (showUploadBox ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < imgList.length) {
              return imageBox(imgList[index].picVideoUrl, index);
            } else if (index < imgList.length + videoList.length) {
              final videoIndex = index - imgList.length;
              return videoBox(videoList[videoIndex].surfaceUrl, videoIndex);
            } else {
              return uploadBox();
            }
          },
        ),
        if ((imgList.length + videoList.length) > 0)
          Padding(
            padding: const EdgeInsets.only(
                top: Constants.SPACE_8, bottom: Constants.SPACE_16),
            child: Text(
              isImageType
                  ? '图片格式jpg/png，最多支持上传${widget.imageParams.maxLimit}张图片'
                  : '视频大小不超过${widget.videoParams.maxSize ?? DEFAULT_VIDEO_PARAM.maxSize}MB，且一次只可上传一个视频',
              style: TextStyle(
                fontSize: Constants.FONT_12,
                color: widget.isDark
                    ? Constants.HINT_DARK_COLOR
                    : Constants.HINT_COLOR,
              ),
            ),
          ),
      ],
    );
  }

  // 操作栏组件
  Widget actionBar() {
    final iconColor =
        widget.isDark ? Constants.TEXT_DARK_COLOR : Constants.TEXT_COLOR;
    final textColor =
        widget.isDark ? Constants.HINT_DARK_COLOR : Constants.HINT_COLOR;

    return Padding(
      padding: EdgeInsets.only(
          bottom: keyboardHeight + Constants.SPACE_16,
          left: Constants.SPACE_8,
          right: Constants.SPACE_16),
      child: SizedBox(
        height: Constants.SPACE_44,
        child: Row(
          children: [
            IconButton(
              icon: SvgPicture.asset(
                Constants.icPublicCameraImage,
                width: Constants.SPACE_24,
                height: Constants.SPACE_24,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                fit: BoxFit.contain,
              ),
              onPressed: () => uploadImage(),
            ),
            const SizedBox(width: Constants.SPACE_8),
            IconButton(
              icon: SvgPicture.asset(
                Constants.icPublicRecorderImage,
                width: Constants.SPACE_24,
                height: Constants.SPACE_24,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                fit: BoxFit.contain,
              ),
              onPressed: () => uploadVideo(),
            ),
            const Spacer(),
            Text(
              '${body.length}/${Constants.MAX_BODY_WORD_LIMIT}',
              style: TextStyle(
                fontSize: Constants.FONT_14,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 上传按钮组件
  Widget uploadBox() {
    return GestureDetector(
      onTap: () => plusBtnClick(),
      child: Container(
        decoration: BoxDecoration(
          color: Constants.UPLOAD_COLOR,
          borderRadius: BorderRadius.circular(Constants.SPACE_16),
        ),
        child: Center(
          child: SvgPicture.asset(
            Constants.icPlus2Image,
            width: Constants.SPACE_24,
            height: Constants.SPACE_24,
            colorFilter: const ColorFilter.mode(
              Constants.FILL_COLOR,
              BlendMode.srcIn,
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // 图片框组件
  Widget imageBox(String url, int index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Constants.SPACE_16),
            child: _buildImageWidget(url),
          ),
        ),
        Positioned(
          top: Constants.SPACE_8,
          right: Constants.SPACE_8,
          child: GestureDetector(
            onTap: () {
              setState(() {
                imgList.removeAt(index);
                onContentChange();
              });
            },
            child: SvgPicture.asset(
              Constants.icPublicCloseCircleImage,
              width: Constants.SPACE_24,
              height: Constants.SPACE_24,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  // 构建图片组件，根据URL类型选择合适的加载方式
  Widget _buildImageWidget(String url) {
    if (url.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_not_supported),
      );
    }

    try {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return Image.network(
          url,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.image_not_supported),
            );
          },
        );
      } else if (url.startsWith('file://')) {
        final filePath = url.substring(7);
        return Image.file(
          File(filePath),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.image_not_supported),
            );
          },
        );
      } else {
        return Image.file(
          File(url),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.image_not_supported),
            );
          },
        );
      }
    } catch (e) {
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_not_supported),
      );
    }
  }

  // 视频框组件
  Widget videoBox(String url, int index) {
    return Stack(
      children: [
        // 视频缩略图
        ClipRRect(
          borderRadius: BorderRadius.circular(Constants.SPACE_16),
          child: buildVideoWidget(url, index),
        ),
        // 半透明遮罩层
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.SPACE_16),
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        // 删除按钮
        Positioned(
          top: Constants.SPACE_8,
          right: Constants.SPACE_8,
          child: GestureDetector(
            onTap: () {
              setState(() {
                videoList.removeAt(index);
                onContentChange();
              });
            },
            child: SvgPicture.asset(
              Constants.icPublicCloseCircleImage,
              width: Constants.SPACE_24,
              height: Constants.SPACE_24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        // 播放图标 - 中央
        Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: Constants.SPACE_24,
              height: Constants.SPACE_24,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                size: Constants.SPACE_20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 加号按钮点击处理
  Future<void> plusBtnClick([UploadType? type]) async {
    bool isUploadImage = true;
    if (type != null) {
      isUploadImage = type == UploadType.Image;
    } else {
      isUploadImage = isImageType;
    }

    final params = isUploadImage ? widget.imageParams : widget.videoParams;
    final list = isUploadImage ? imgList : videoList;

    try {
      final uriList = await MediaUtils.selectMedia(
        MediaParams(
          type: params.type,
          maxLimit: params.maxLimit - list.length,
          maxSize: params.maxSize,
        ),
      );

      if (uriList.isEmpty) {
        return;
      }

      for (final uri in uriList) {
        if (list.length >= params.maxLimit) {
          if (mounted) {
            toast(isUploadImage ? '已添加的图片数量已达上限' : '已添加的视频数量已达上限');
          }
          break;
        }

        final item = PostImgVideoItem();

        item.picVideoUrl = uri.startsWith('file://') ? uri : 'file://$uri';

        if (!isUploadImage) {
          item.surfaceUrl = await MediaUtils.generateVideoThumbnail(uri) ?? "";

          if (mounted) {
            setState(() {
              list.add(item);
              onContentChange();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              list.add(item);
              onContentChange();
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        toast('选择媒体失败');
      }
    }
  }

  // 上传图片
  void uploadImage() {
    if (videoList.isNotEmpty) {
      if (mounted) {
        toast('图片与视频一次只可上传一种');
      }
      return;
    }
    if (imgList.length >= widget.imageParams.maxLimit) {
      if (mounted) {
        toast('已添加的图片数量已达上限');
      }
      return;
    }
    plusBtnClick(UploadType.Image);
  }

  // 上传视频
  void uploadVideo() {
    if (imgList.isNotEmpty) {
      if (mounted) {
        toast('图片与视频一次只可上传一种');
      }
      return;
    }
    if (videoList.length >= widget.videoParams.maxLimit) {
      if (mounted) {
        toast('已添加的视频数量已达上限');
      }
      return;
    }
    plusBtnClick(UploadType.Video);
  }

  // 计算属性
  bool get isImageType => imgList.isNotEmpty;

  bool get showUploadBox {
    if (imgList.isNotEmpty && imgList.length < widget.imageParams.maxLimit) {
      return true;
    }
    if (videoList.isNotEmpty &&
        videoList.length < widget.videoParams.maxLimit) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.SPACE_16,
                      vertical: Constants.SPACE_12),
                  child: textArea(),
                ),
                const SizedBox(height: Constants.SPACE_16),
                mediaArea(),
              ],
            ),
          ),
        ),
        actionBar(),
      ],
    );
  }
}
