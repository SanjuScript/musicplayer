import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/PROVIDER/now_playing_provider.dart';
import 'package:provider/provider.dart';

Widget playPauseButton(
    BuildContext context, bool isPlaying, Size size, bool isDarkTheme) {
  return InkWell(
    onTap: () async {
      context.read<NowPlayingProvider>().playPauseButtonHere();
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size.width * 0.25,
          height: size.width * 0.25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDarkTheme
                  ? [
                      const Color(0xFF3A0CA3),
                      Colors.transparent,
                    ]
                  : [
                      const Color(0xFF7E57C2),
                      Colors.transparent,
                    ],
              center: Alignment.center,
              radius: 0.6,
            ),
          ),
        ),
        Container(
          width: size.width * 0.2,
          height: size.width * 0.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isDarkTheme
                  ? [
                      const Color(0xFF240046),
                      const Color(0xFF5A189A),
                    ]
                  : [
                      const Color(0xFF512DA8),
                      const Color(0xFF9575CD),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkTheme
                    ? Colors.purple.withOpacity(0.6)
                    : Colors.deepPurpleAccent.withOpacity(0.5),
                offset: const Offset(4, 4),
                blurRadius: 15,
              ),
              BoxShadow(
                color: isDarkTheme
                    ? Colors.black.withOpacity(0.4)
                    : Colors.black.withOpacity(0.2),
                offset: const Offset(-4, -4),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: size.width * 0.18,
              height: size.width * 0.18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDarkTheme
                    ? Colors.black.withOpacity(0.4)
                    : Colors.white.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        Icon(
          isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
          size: isPlaying ? size.width * 0.11 : size.width * 0.09,
          color: !isDarkTheme
              ? const Color(0xFFEDEDED)
              : const Color.fromARGB(255, 235, 235, 235),
          shadows: [
            BoxShadow(
              color: isDarkTheme
                  ? const Color(0xFF7209B7)
                  : const Color(0xFFE1BEE7),
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
      ],
    ),
  );
}
