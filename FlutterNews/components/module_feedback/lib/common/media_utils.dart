import 'package:image_picker/image_picker.dart';

class MediaUtils {
  static final ImagePicker _picker = ImagePicker();

  /// 选择媒体文件
  static Future<List<String>> selectMedia(int maxCount) async {
    final List<String> result = [];
    
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      result.add(image.path);
    }
    
    return result;
  }

  static String handleUri(String uri) {
    return uri;
  }
}
