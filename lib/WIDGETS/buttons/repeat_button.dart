import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/CONSTANTS/asset_helper.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:music_player/DATABASE/storage.dart';
import 'package:music_player/WIDGETS/svg_helper.dart';
import 'package:music_player/screens/main_music_playing_screen.dart.dart';

Widget repeatButton(BuildContext context, LoopMode loopMode, double wt) {
  final icons = [
    Icon(
      FontAwesomeIcons.repeat,
      size: wt * 0.05,
      color: const Color(0xff9CADC0),
    ),
    Icon(
      FontAwesomeIcons.repeat,
      size: wt * 0.05,
      color: Colors.deepPurple[400],
    ),
    SetSvg(
      name: GetAsset.repeat,
      color: Colors.deepPurple[400]!,
      width: wt * .07,
      // height: ht * .03,
    )
  ];
  const cycleModes = [
    LoopMode.off,
    LoopMode.all,
    LoopMode.one,
  ];
  final index = cycleModes.indexOf(loopMode);
  return IconButton(
    splashRadius: 30,
    icon: icons[index],
    onPressed: () async {
      final newLoopMode =
          cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length];
      await MozController.player.setLoopMode(newLoopMode);
      await MozStorageManager.saveData(
          'repeatMode', newLoopMode.index.toString());
    },
  );
}
