// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Whitebox';

  @override
  String get selectImages => 'Select images to start';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get applyPadding => 'Apply Letterbox to All Sides';

  @override
  String get applyPaddingSubtitle =>
      'Adds white padding around the entire image';

  @override
  String get clearListTitle => 'Clear List?';

  @override
  String get clearListContent => 'Do you want to clear the image list?';

  @override
  String get addImagesTitle => 'Add Images';

  @override
  String get addImagesContent =>
      'Do you want to clear the existing images before adding new ones?';

  @override
  String get keepExisting => 'Keep Existing';

  @override
  String get clear => 'Clear';

  @override
  String get downloadTitle => 'Download Images';

  @override
  String downloadContent(int count) {
    return 'Do you want to download $count images?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get download => 'Download';

  @override
  String get saveSuccess => 'Images saved to gallery';

  @override
  String get saveError => 'Error saving images';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';
}
