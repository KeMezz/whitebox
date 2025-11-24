// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Whitebox';

  @override
  String get selectImages => '画像を選択して開始';

  @override
  String get settingsTitle => '設定';

  @override
  String get applyPadding => '全側面に余白を適用';

  @override
  String get applyPaddingSubtitle => '画像の周囲全体に白い余白を追加します';

  @override
  String get clearListTitle => 'リストをクリア';

  @override
  String get clearListContent => '画像リストをクリアしますか？';

  @override
  String get addImagesTitle => '画像を追加';

  @override
  String get addImagesContent => '新しい画像を追加する前に、既存の画像をクリアしますか？';

  @override
  String get keepExisting => '既存を維持';

  @override
  String get clear => 'クリア';

  @override
  String get downloadTitle => '画像をダウンロード';

  @override
  String downloadContent(int count) {
    return '$count枚の画像をダウンロードしますか？';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get download => 'ダウンロード';

  @override
  String get saveSuccess => 'ギャラリーに画像を保存しました';

  @override
  String get saveError => '画像の保存中にエラーが発生しました';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';
}
