// 常量定义
import 'package:flutter/material.dart';
class Constants {
  static const int MAX_BODY_WORD_LIMIT = 800;
  static const int MAX_IMG_COUNT = 9;
  static const int MAX_VIDEO_COUNT = 1;
  static const int MAX_VIDEO_SIZE = 500;

  static const double SPACE_8 = 8;
  static const double SPACE_12 = 12.0;
  static const double SPACE_16 = 16.0;
  static const double SPACE_20 = 20.0;
  static const double SPACE_24 = 24.0;
  static const double SPACE_44 = 44.0;
  static const double SPACE_48 = 48.0;
  static const double SPACE_200 = 200.0;

  static const double FONT_12 = 12.0;
  static const double FONT_14 = 14.0;
  static const double FONT_16 = 16.0;

  static const Color TEXT_DARK_COLOR = Color(0xFFFFFFFF);
  static const Color TEXT_COLOR = Color(0xFF000000);
  static const Color HINT_DARK_COLOR = Color(0x66FFFFFF);
  static const Color HINT_COLOR = Color(0x66000000);
  static const Color UPLOAD_COLOR = Color(0xFFF1F3F5);
  static const Color FILL_COLOR = Color(0xFF8C8C8E);

  static const String icPublicCameraImage = 'packages/module_post/assets/ic_public_camera.svg';
  static const String icPublicRecorderImage = 'packages/module_post/assets/ic_public_recorder.svg';
  static const String icPlus2Image = 'packages/module_post/assets/ic_plus2.svg';
  static const String icPublicCloseCircleImage = 'packages/module_post/assets/ic_public_close_circle.svg';
}

class PostImgVideoItem {
  String picVideoUrl = '';
  String surfaceUrl = '';
  String Thumbnail= '';
}

class MediaParams {
  final String type;
  final int maxLimit;
  final int? maxSize;

  // 将构造函数改为const构造函数
  const MediaParams({
    required this.type,
    required this.maxLimit,
    this.maxSize,
  });
}

class VideoSizeData {
  Map<String, int> photoSize = {
    'width': 0,
    'height': 0,
  };
  int totalTime = 0;
}

/// 上传类型
enum UploadType {
  Image(1),
  Video(2);

  final int value;
  const UploadType(this.value);
}

// 发布动态-图片参数
const MediaParams DEFAULT_IMAGE_PARAM = MediaParams(
  type: 'IMAGE_TYPE',
  maxLimit: Constants.MAX_IMG_COUNT,
);

// 发布动态-视频参数
const MediaParams DEFAULT_VIDEO_PARAM = MediaParams(
  type: 'VIDEO_TYPE',
  maxLimit: Constants.MAX_VIDEO_COUNT,
  maxSize: Constants.MAX_VIDEO_SIZE,
);