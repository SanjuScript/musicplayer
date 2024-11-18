import 'package:flutter/material.dart';
import 'package:music_player/WIDGETS/svg_helper.dart';

Widget nextPrevoiusIcons(
    BuildContext context, void Function() inkWallOntapFunction, String icon) {
  return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: inkWallOntapFunction,
      radius: 30,
      child: SetSvg(
        name: icon,
        color: const Color(0xff333c67),
      ));
}
