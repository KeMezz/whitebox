import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'image_processor.dart';
import 'settings_screen.dart';
import 'full_screen_preview.dart';

import 'services.dart';

import 'package:whitebox/l10n/generated/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final GallerySaverService? gallerySaverService;
  final ShareService? shareService;

  const HomeScreen({super.key, this.gallerySaverService, this.shareService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final ImageProcessor _processor = ImageProcessor();
  late final GallerySaverService _gallerySaver;
  late final ShareService _shareService;

  @override
  void initState() {
    super.initState();
    _gallerySaver = widget.gallerySaverService ?? GallerySaverService();
    _shareService = widget.shareService ?? ShareService();
  }

  // Store original XFiles to re-process if padding changes
  List<XFile> _originalImages = [];
  List<File> _processedImages = [];
  bool _isProcessing = false;
  bool _applyPadding = true; // Default to true

  Future<void> _pickImages() async {
    if (_originalImages.isNotEmpty) {
      final bool? shouldClear = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Add Images',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Do you want to clear the existing images before adding new ones?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Keep Existing',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (shouldClear == true) {
        _clearImages();
      }
    }

    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _originalImages.addAll(images);
      });
      await _processImages();
    }
  }

  Future<void> _processImages({bool reprocessAll = false}) async {
    if (_originalImages.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    int startIndex = _processedImages.length;

    if (reprocessAll) {
      setState(() {
        _processedImages.clear();
      });
      startIndex = 0;
    }

    for (int i = startIndex; i < _originalImages.length; i++) {
      final image = _originalImages[i];
      final processedFile = await _processor.processImage(
        image,
        applyPadding: _applyPadding,
      );

      if (processedFile != null) {
        if (mounted) {
          setState(() {
            _processedImages.add(processedFile);
          });
          // Yield to the UI thread to allow the list to update
          await Future.delayed(Duration.zero);
        }
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _saveImages() async {
    if (_processedImages.isEmpty) return;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            AppLocalizations.of(context)!.downloadTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            AppLocalizations.of(
              context,
            )!.downloadContent(_processedImages.length),
            style: const TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: const TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.download,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      for (var image in _processedImages) {
        await _gallerySaver.saveImage(image.path, albumName: 'Whitebox');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.saveSuccess)),
        );
      }
    } catch (e) {
      print('Error saving images: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.saveError)),
        );
      }
    }
  }

  Future<void> _showClearConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900], // Dark dialog
          title: Text(
            AppLocalizations.of(context)!.clearListTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.clearListContent,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.no,
                style: const TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.yes,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _clearImages();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _shareImages() async {
    if (_processedImages.isEmpty) return;

    final files = _processedImages.map((file) => XFile(file.path)).toList();
    await _shareService.shareXFiles(files);
  }

  void _clearImages() {
    setState(() {
      _originalImages.clear();
      _processedImages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    applyPadding: _applyPadding,
                    onPaddingChanged: (value) {
                      setState(() {
                        _applyPadding = value;
                      });
                      _processImages(reprocessAll: true);
                    },
                  ),
                ),
              );
            },
          ),
          if (_originalImages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showClearConfirmation,
            ),
        ],
      ),
      body: Column(
        children: [
          if (_isProcessing)
            const LinearProgressIndicator(
              backgroundColor: Colors.black,
              color: Colors.white,
              minHeight: 2,
            ),
          Expanded(
            child: _processedImages.isEmpty && !_isProcessing
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_photo_alternate,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.selectImages,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: _processedImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenPreview(
                                imageFile: _processedImages[index],
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[800]!,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.file(
                              _processedImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Add Button (Always Center)
                FloatingActionButton(
                  heroTag: 'add_btn',
                  onPressed: _pickImages,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.add_photo_alternate,
                    color: Colors.black,
                  ),
                ),
                // Save Button (Left)
                if (_processedImages.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FloatingActionButton(
                      heroTag: 'save_btn',
                      onPressed: _saveImages,
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white,
                      shape: CircleBorder(
                        side: BorderSide(color: Colors.white),
                      ),
                      child: const Icon(Icons.save_alt),
                    ),
                  ),
                // Share Button (Right)
                if (_processedImages.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      heroTag: 'share_btn',
                      onPressed: _shareImages,
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white,
                      shape: CircleBorder(
                        side: BorderSide(color: Colors.white),
                      ),
                      child: const Icon(Icons.share),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
