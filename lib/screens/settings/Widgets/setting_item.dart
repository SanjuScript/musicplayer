import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final Widget trailing;
  final void Function()? onTap;

  const SettingsItem(
      {super.key, required this.title, required this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).cardColor.withOpacity(.8),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
