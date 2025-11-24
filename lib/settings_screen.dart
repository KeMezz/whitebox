import 'package:flutter/material.dart';

import 'package:whitebox/l10n/generated/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  final bool applyPadding;
  final ValueChanged<bool> onPaddingChanged;

  const SettingsScreen({
    super.key,
    required this.applyPadding,
    required this.onPaddingChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _applyPadding;

  @override
  void initState() {
    super.initState();
    _applyPadding = widget.applyPadding;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.applyPadding),
            subtitle: Text(AppLocalizations.of(context)!.applyPaddingSubtitle),
            value: _applyPadding,
            onChanged: (bool value) {
              setState(() {
                _applyPadding = value;
              });
              widget.onPaddingChanged(value);
            },
            activeColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ],
      ),
    );
  }
}
