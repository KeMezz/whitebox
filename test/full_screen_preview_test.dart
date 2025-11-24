import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whitebox/full_screen_preview.dart';

void main() {
  testWidgets('FullScreenPreview displays image in InteractiveViewer', (
    WidgetTester tester,
  ) async {
    // Create a dummy file
    final file = File('dummy_path');

    await tester.pumpWidget(
      MaterialApp(home: FullScreenPreview(imageFile: file)),
    );

    // Verify InteractiveViewer is present
    expect(find.byType(InteractiveViewer), findsOneWidget);

    // Verify Image is present (Image.file will try to load, but we just check widget existence)
    // Note: Image.file might throw error if file doesn't exist in test environment,
    // but typically widget tests just build the widget tree.
    // However, Image.file might try to decode.
    // To be safe, we check for the type Image.
    expect(find.byType(Image), findsOneWidget);
  });
}
