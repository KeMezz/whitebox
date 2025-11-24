import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenPreview extends StatelessWidget {
  final File imageFile;

  const FullScreenPreview({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Image.file(imageFile, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
