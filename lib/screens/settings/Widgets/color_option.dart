import 'package:flutter/material.dart';
import 'package:music_player/screens/settings/Helper/get_color.dart';

Widget buildColorOption(BuildContext context, Color color) {
  return ListTile(
    leading: CircleAvatar(backgroundColor: color),
    title: Text(
      colorToString(color),
      style: TextStyle(color: Theme.of(context).cardColor),
    ),
    onTap: () {
      // Provider.of<ThemeProvider>(context, listen: false).setDarkModeWithAccent(color);
      Navigator.pop(context);
    },
  );
}

