import 'package:gallery_saver/gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

class GallerySaverService {
  Future<bool?> saveImage(String path, {String? albumName}) {
    return GallerySaver.saveImage(path, albumName: albumName);
  }
}

class ShareService {
  Future<void> shareXFiles(List<XFile> files) {
    return Share.shareXFiles(files);
  }
}
