import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class FileUtils {
  static const int DOMAIN = 0x0000;
  static const String TAG = '[FileUtils]';
  static const Uuid _uuid = Uuid();

  static String handleUri(String uri, {String suffix = 'png'}) {
    if (uri.isEmpty) {
      return '';
    }
    File? tempFile;
    try {
      final filePath = uri.startsWith('file://') ? uri.substring(7) : uri;
      tempFile = File(filePath);

      final cacheDir = Directory.systemTemp.path;
      final newPath = path.join(cacheDir, '${_uuid.v4()}.$suffix');

      tempFile.copySync(newPath);
      
      return 'file://$newPath';
    } catch (e) {
      
      return '';
    }
  }

  /// pixelMap写入沙箱
  /// @param pixelMap
  /// @returns
  static Future<String> writePixelMap(dynamic pixelMap) async {
    if (pixelMap == null) {
      return '';
    }

    try {
      final cacheDir = Directory.systemTemp.path;
      final newPath = path.join(cacheDir, '${_uuid.v4()}.png');
      final file = File(newPath);

      await file.writeAsBytes([]); 

      
      return 'file://$newPath';
    } catch (e) {
      
      return '';
    }
  }
}
