import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

class GallerySaverService {
  Future<void> saveImage(String path, {String? albumName}) async {
    await Gal.putImage(path, album: albumName);
  }
}

class ShareService {
  Future<void> shareXFiles(List<XFile> files) {
    return Share.shareXFiles(files);
  }
}
