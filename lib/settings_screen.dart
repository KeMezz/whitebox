import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Apply Letterbox to All Sides'),
            subtitle: const Text('Adds white padding around the entire image'),
            value: _applyPadding,
            onChanged: (value) {
              setState(() {
                _applyPadding = value;
              });
              widget.onPaddingChanged(value);
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
