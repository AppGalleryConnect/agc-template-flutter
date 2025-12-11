import 'NavInfoModel.dart';

class NavInfo {
  String? setting = '';
  LayoutRoot? parsedSetting;

  /// 创建导航信息模型
  NavInfo({this.setting}) : parsedSetting = _parseSetting(setting ?? '');
  static LayoutRoot? _parseSetting(String setting) {
    if (setting.isEmpty) return null;
    try {
      return LayoutRoot.fromJsonString(setting);
    } catch (e) {
      return null;
    }
  }

  factory NavInfo.fromJson(Map<String, dynamic> json) {
    return NavInfo(
      setting: json['setting'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setting': setting,
    };
  }
}

/// 动态图片/视频模型
class PostImgList {
  /// 图片/视频的完整URL
  String picVideoUrl;

  /// 图片/视频的唯一标识符
  String? id;

  /// 封面图片URL
  String surfaceUrl;

  /// 类型标识（图片/视频区分）
  int? type;

  /// 所属文章ID
  String? essayId;

  /// 创建动态图片/视频模型
  PostImgList({
    required this.picVideoUrl,
    required this.surfaceUrl,
    this.id,
    this.type,
    this.essayId,
  });

  factory PostImgList.fromJson(Map<String, dynamic> json) {
    return PostImgList(
      picVideoUrl: json['picVideoUrl'],
      surfaceUrl: json['surfaceUrl'],
      id: json['id'],
      type: json['type'],
      essayId: json['essayId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'picVideoUrl': picVideoUrl,
      'surfaceUrl': surfaceUrl,
      'id': id,
      'type': type,
      'essayId': essayId,
    };
  }
}

/// 按钮信息模型
class IButtonItem {
  /// 按钮唯一标识符
  String id;

  /// 按钮显示文本
  String label;

  /// 创建按钮信息模型
  IButtonItem({
    required this.id,
    required this.label,
  });

  factory IButtonItem.fromJson(Map<String, dynamic> json) {
    return IButtonItem(
      id: json['id'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}
