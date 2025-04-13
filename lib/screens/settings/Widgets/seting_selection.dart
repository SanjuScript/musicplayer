import 'package:flutter/material.dart';
import 'package:music_player/screens/settings/Widgets/setting_item.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;

  const SettingsSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Theme.of(context).cardColor,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'optica'),
        ),
        const Divider(),
        ...items,
      ],
    );
  }
}

