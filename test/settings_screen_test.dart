import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whitebox/settings_screen.dart';

void main() {
  testWidgets('SettingsScreen displays switch and toggles state', (
    WidgetTester tester,
  ) async {
    bool paddingValue = true;

    await tester.pumpWidget(
      MaterialApp(
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
