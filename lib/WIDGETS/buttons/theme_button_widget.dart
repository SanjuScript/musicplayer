import 'package:flutter/material.dart';
import 'package:music_player/CONSTANTS/asset_helper.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:music_player/WIDGETS/svg_helper.dart';
import 'package:provider/provider.dart';
import '../../COLORS/colors.dart';

class ChangeThemeButtonWidget extends StatefulWidget {
  final bool visibility; // Corrected spelling
  final bool changeICon;
  const ChangeThemeButtonWidget({
    Key? key,
    this.visibility = false,
    this.changeICon = false,
  }) : super(key: key);

  @override
  State<ChangeThemeButtonWidget> createState() =>
      _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final theme = (themeProvider.getTheme());
  }

  void _toggleTheme(ThemeProvider themeProvider) {
    if (themeProvider.getTheme() == CustomThemes.darkThemeMode) {
      themeProvider.setLightMode();
    } else {
      themeProvider.setDarkMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final darkTheme = (themeProvider.getTheme() == CustomThemes.lightThemeMode);
    final Size size = MediaQuery.sizeOf(context);
    if (widget.changeICon) {
      return Switch(
        value: darkTheme,
        onChanged: (value) {
          _toggleTheme(themeProvider);
        },
        // activeColor: Colors.black,
        // activeTrackColor: Colors.grey[300],
        // inactiveThumbColor: Colors.white,
        // inactiveTrackColor: Colors.grey[700],
      );
    } else {
      return InkWell(
        onTap: () => _toggleTheme(themeProvider),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: SetSvg(
            name: !darkTheme ? GetAsset.light : GetAsset.dark,
            color: darkTheme ? Colors.black : Colors.white,
            width: size.width * .07,
            height: size.height * .03,
          ),
        ),
      );
    }
  }
}
