import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class ImageProcessor {
  Future<File?> processImage(XFile xFile, {bool applyPadding = true}) async {
    try {
      final bytes = await xFile.readAsBytes();
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;

      // Run heavy image processing in a separate isolate
      return await compute(
        _processImageInIsolate,
        _ProcessRequest(bytes, tempPath, applyPadding),
      );
    } catch (e) {
      print('Error processing image: $e');
      return null;
    }
  }
}

class _ProcessRequest {
  final Uint8List bytes;
  final String tempPath;
  final bool applyPadding;

  _ProcessRequest(this.bytes, this.tempPath, this.applyPadding);
}

Future<File?> _processImageInIsolate(_ProcessRequest request) async {
  try {
    final image = img.decodeImage(request.bytes);

    if (image == null) return null;

    int size = image.width > image.height ? image.width : image.height;

    // Create a white square image
    final background = img.Image(width: size, height: size);
    img.fill(background, color: img.ColorRgb8(255, 255, 255));

    // Calculate padded size
    // If applyPadding is true, we use a fixed 10% padding (0.1)
    // So scaleFactor is 0.9

    double scaleFactor = request.applyPadding ? 0.9 : 1.0;

    int maxContentSize = (size * scaleFactor).toInt();

    img.Image resizedImage;
    if (image.width > image.height) {
      resizedImage = img.copyResize(image, width: maxContentSize);
    } else {
      resizedImage = img.copyResize(image, height: maxContentSize);
    }

    // Draw the resized image onto the background, centered
    int dstX = (size - resizedImage.width) ~/ 2;
    int dstY = (size - resizedImage.height) ~/ 2;

    img.compositeImage(background, resizedImage, dstX: dstX, dstY: dstY);

    // Save to temp file
    final fileName = 'whitebox_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File('${request.tempPath}/$fileName');

    await file.writeAsBytes(img.encodeJpg(background));

    return file;
  } catch (e) {
    print('Isolate error: $e');
    return null;
  }
}
