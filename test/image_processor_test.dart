import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:whitebox/image_processor.dart';
import 'package:image/image.dart' as img;

void main() {
  group('ImageProcessor Logic', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('whitebox_test');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('processImageInIsolate creates a square image with padding', () async {
      // Create a dummy 100x50 image
      final image = img.Image(width: 100, height: 50);
      img.fill(image, color: img.ColorRgb8(255, 0, 0)); // Red
      final bytes = Uint8List.fromList(img.encodePng(image));

      final request = ProcessRequest(
        bytes,
        tempDir.path,
        true,
      ); // Apply padding

      final processedFile = await processImageInIsolate(request);

      expect(processedFile, isNotNull);
      expect(await processedFile!.exists(), isTrue);

      final processedImage = img.decodeImage(await processedFile.readAsBytes());
      expect(processedImage, isNotNull);

      // Should be square, based on max dimension (100)
      expect(processedImage!.width, 100);
      expect(processedImage.height, 100);

      // Check pixel at 0,0 (should be white background)
      final pixel = processedImage.getPixel(0, 0);
      expect(pixel.r, 255);
      expect(pixel.g, 255);
      expect(pixel.b, 255);
    });

    test(
      'processImageInIsolate creates a square image without padding',
      () async {
        // Create a dummy 100x50 image
        final image = img.Image(width: 100, height: 50);
        img.fill(image, color: img.ColorRgb8(255, 0, 0)); // Red
        final bytes = Uint8List.fromList(img.encodePng(image));

        final request = ProcessRequest(
          bytes,
          tempDir.path,
          false,
        ); // No padding

        final processedFile = await processImageInIsolate(request);

        expect(processedFile, isNotNull);

        final processedImage = img.decodeImage(
          await processedFile!.readAsBytes(),
        );
        expect(processedImage, isNotNull);

        // Should be square
        expect(processedImage!.width, 100);
        expect(processedImage.height, 100);
      },
    );
  });
}
