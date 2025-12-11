import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/constants.dart';

class MediaUtils {
  static const int DOMAIN = 0x0000;
  static const String TAG = '[MediaUtils]';
  static final ImagePicker _picker = ImagePicker();

  // 请求媒体权限
  static Future<bool> requestMediaPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
        Permission.videos,
      ].request();

      bool allGranted = statuses.values
          .every((status) => status.isGranted || status.isLimited);
      if (!allGranted) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // 选择图片或视频
  static Future<List<String>> selectMedia(MediaParams params) async {
    List<String> uris = [];

    bool hasPermission = await requestMediaPermissions();
    if (!hasPermission) {
      
      return uris;
    }
    if (params.type == 'IMAGE_TYPE') {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 100,
      );

      uris = images.map((image) => image.path).toList();
      if (params.maxLimit > 0 && uris.length > params.maxLimit) {
        uris = uris.take(params.maxLimit).toList();
        
      }
    } else if (params.type == 'VIDEO_TYPE') {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );

      if (video != null) {
        if (params.maxSize != null) {
          final File videoFile = File(video.path);
          final int fileSize = await videoFile.length();
          final double sizeInMB = fileSize / (1024 * 1024);

          if (sizeInMB <= params.maxSize!) {
            uris.add(video.path);
          } 
        } else {
          uris.add(video.path);
        }
      }
    }

    return uris;
  }

  // 生成视频缩略图
  static Future<String?> generateVideoThumbnail(String videoPath) async {
    if (videoPath.isEmpty) {
      return null;
    }

    try {
      String cleanPath = videoPath;
      if (videoPath.startsWith('file://')) {
        cleanPath = videoPath.substring(7);
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      final thumbnailsDir = Directory('${appDocDir.path}/thumbnails');

      if (!await thumbnailsDir.exists()) {
        await thumbnailsDir.create(recursive: true);
      }

      try {
        final fileName = await VideoThumbnail.thumbnailFile(
          video: cleanPath,
          thumbnailPath: thumbnailsDir.path,
          imageFormat: ImageFormat.PNG,
          maxHeight: 512,
          quality: 75,
        );

        if (fileName != null && fileName.isNotEmpty) {
          
          return fileName;
        } else {
          
          return null;
        }
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null; 
    }
  }

  // 获取视频尺寸和时长
  static Future<VideoSizeData> getVideoData(String uri) async {
    VideoSizeData videoSize = VideoSizeData();

    videoSize.photoSize = {
      'width': 1280, 
      'height': 720, 
    };
    videoSize.totalTime = 60000; 
    return videoSize;
  }
}
