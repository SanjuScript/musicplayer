import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SetSvg extends StatelessWidget {
  final String name;
  final double? height;
  final double? width;
  final Color color;

  const SetSvg(
      {super.key,
      required this.name,
      this.height,
      this.width,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SvgPicture.asset(
      name,
      width: width ?? size.width * 0.07,
      height: height ?? size.height * .03,
      color: color,
    );
  }
}
