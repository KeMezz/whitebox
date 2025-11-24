// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Whitebox';

  @override
  String get selectImages => '이미지를 선택하여 시작하세요';

  @override
  String get settingsTitle => '설정';

  @override
  String get applyPadding => '모든 면에 여백 적용';

  @override
  String get applyPaddingSubtitle => '이미지 전체 주위에 흰색 여백을 추가합니다';

  @override
  String get clearListTitle => '목록 지우기';

  @override
  String get clearListContent => '이미지 목록을 지우시겠습니까?';

  @override
  String get addImagesTitle => '이미지 추가';

  @override
  String get addImagesContent => '새 이미지를 추가하기 전에 기존 이미지를 지우시겠습니까?';

  @override
  String get keepExisting => '기존 유지';

  @override
  String get clear => '지우기';

  @override
  String get downloadTitle => '이미지 다운로드';

  @override
  String downloadContent(int count) {
    return '$count장의 이미지를 다운로드하시겠습니까?';
  }

  @override
  String get cancel => '취소';

  @override
  String get download => '다운로드';

  @override
  String get saveSuccess => '갤러리에 이미지가 저장되었습니다';

  @override
  String get saveError => '이미지 저장 중 오류 발생';

  @override
  String get yes => '예';

  @override
  String get no => '아니요';
}
