import '../../constants/constants.dart';
import '../base/base_model.dart';

/// 发布动态请求类
class PostRequest {
  /// 动态正文内容
  final String postBody;

  /// 图片、视频链接列表（可选）
  final List<PostImgList>? postImgList;

  /// PostRequest构造函数
  const PostRequest({
    required this.postBody,
    this.postImgList,
  });

  Map<String, dynamic> toJson() {
    return {
      'postBody': postBody,
      if (postImgList != null)
        'postImgList': postImgList!.map((img) {
          return {
            'picVideoUrl': img.picVideoUrl,
            'surfaceUrl': img.surfaceUrl,
            if (img.id != null) 'id': img.id,
            if (img.type != null) 'type': img.type,
            if (img.essayId != null) 'essayId': img.essayId,
          };
        }).toList(),
    };
  }
}

/// 修改个人信息请求类
class ModifyPersonalInfoRequest {
  /// 作者头像URL（可选）
  final String? authorIcon;

  /// 作者昵称（可选）
  final String? authorNickName;

  /// 作者手机号码（可选）
  final String? authorPhone;

  /// 作者个人描述（可选）
  final String? authorDesc;

  /// ModifyPersonalInfoRequest构造函数
  const ModifyPersonalInfoRequest({
    this.authorIcon,
    this.authorNickName,
    this.authorPhone,
    this.authorDesc,
  });

  Map<String, dynamic> toJson() {
    return {
      if (authorIcon != null) 'authorIcon': authorIcon,
      if (authorNickName != null) 'authorNickName': authorNickName,
      if (authorPhone != null) 'authorPhone': authorPhone,
      if (authorDesc != null) 'authorDesc': authorDesc,
    };
  }
}

/// 发送消息请求类
class SendMessageRequest {
  /// 消息类型（使用ChatEnum枚举）
  final ChatEnum type;

  /// 消息内容
  final String content;

  /// 消息创建时间戳
  final int createTime;

  /// SendMessageRequest构造函数
  const SendMessageRequest({
    required this.type,
    required this.content,
    required this.createTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'content': content,
      'createTime': createTime,
    };
  }
}

/// 发表评论请求类
class PublishCommentRequest {
  /// 新闻ID
  final String newsId;

  /// 评论内容
  final String content;

  /// 父评论ID（可选，用于回复评论）
  final String? parentCommentId;

  /// PublishCommentRequest构造函数
  const PublishCommentRequest({
    required this.newsId,
    required this.content,
    this.parentCommentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'newsId': newsId,
      'content': content,
      if (parentCommentId != null) 'parentCommentId': parentCommentId,
    };
  }
}
