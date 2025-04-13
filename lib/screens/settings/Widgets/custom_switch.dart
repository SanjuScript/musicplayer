import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:provider/provider.dart';

class CustomSwitch extends StatelessWidget {
  final bool? value;
  final void Function(bool)? onChanged;
  const CustomSwitch({super.key, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    if (theme.getTheme() == CustomThemes.darkThemeMode) {
      return Switch(
        value: value!,
        onChanged: onChanged,
        trackOutlineWidth: const WidgetStatePropertyAll(0),
        activeColor: Colors.deepPurple.shade500,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey.withOpacity(0.5),
        activeTrackColor: Colors.white,
      );
    } else {
      return Switch(
        value: value!,
        onChanged: onChanged,
        trackOutlineWidth: const WidgetStatePropertyAll(0),
        activeColor: Colors.deepPurple.shade300,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey.withOpacity(0.8),
        activeTrackColor: Colors.deepPurple.shade100,
      );
    }
  }
}
