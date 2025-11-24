import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whitebox/settings_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:whitebox/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('SettingsScreen은 스위치를 표시하고 상태를 토글해야 한다', (
    WidgetTester tester,
  ) async {
    bool paddingValue = true;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ko'), Locale('ja')],
        home: SettingsScreen(
          applyPadding: paddingValue,
          onPaddingChanged: (value) {
            paddingValue = value;
          },
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Apply Letterbox to All Sides'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);

    final switchTile = tester.widget<SwitchListTile>(
      find.byType(SwitchListTile),
    );
    expect(switchTile.value, true);

    // Toggle switch
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();

    // Verify callback was called
    expect(paddingValue, false);

    // Verify UI updated
    final switchTileUpdated = tester.widget<SwitchListTile>(
      find.byType(SwitchListTile),
    );
    expect(switchTileUpdated.value, false);
  });
}
