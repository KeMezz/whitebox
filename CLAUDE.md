# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Whitebox is a Flutter app that adds white letterbox padding to images, making them square. Supports English, Korean, and Japanese.

## Essential Commands

```bash
# Development
flutter pub get              # Install dependencies
flutter run                  # Run on device/emulator
flutter analyze              # Run linter

# Testing
flutter test                 # Run all tests
flutter test test/<file>     # Run specific test file
flutter pub run build_runner build  # Regenerate mocks after @GenerateMocks changes

# Localization
flutter gen-l10n             # Regenerate after editing .arb files

# Build
flutter build apk            # Android
flutter build ios            # iOS
```

## Architecture

### Service Layer Pattern
External dependencies are wrapped in service classes (`lib/services.dart`) and injected via constructor for testability:
```dart
class HomeScreen extends StatefulWidget {
  final GallerySaverService? gallerySaverService;
  final ShareService? shareService;
  // Optional with default fallback instantiation
}
```

### Isolate-Based Image Processing
`lib/image_processor.dart` uses `compute()` to run image manipulation off the main thread. The `ProcessRequest` class carries parameters to the isolate.

### Localization
ARB files in `lib/l10n/` (app_en.arb, app_ko.arb, app_ja.arb). Access via `AppLocalizations.of(context)!.<key>`.

## Key Files

- `lib/main.dart` - Entry point, theme (dark), locale setup
- `lib/home_screen.dart` - Main UI with image grid, save/share/clear actions
- `lib/image_processor.dart` - Isolate-based image processing logic
- `lib/services.dart` - GallerySaverService (gal), ShareService (share_plus)
- `lib/settings_screen.dart` - Padding toggle, triggers re-processing via callback

## Testing

Uses mockito with code generation. Mocks are generated from `@GenerateMocks` annotations. Always check `mounted` before `setState()` in async callbacks.
