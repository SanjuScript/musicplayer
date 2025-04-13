import 'dart:async';
import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/PROVIDER/color_extraction.dart';
import 'package:music_player/PROVIDER/miniplayer_provider.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:music_player/SCREENS/main_music_playing_screen.dart.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:music_player/WIDGETS/audio_for_others.dart';
import 'package:music_player/WIDGETS/nuemorphic_button.dart';
import 'package:provider/provider.dart';
import '../DATABASE/most_played.dart';
import '../DATABASE/recently_played.dart';
import '../ANIMATION/up_animation.dart';
import '../CONTROLLER/song_controllers.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';
import '../HELPER/duration.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          MozController.player.positionStream,
          MozController.player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MiniplayerProvider>(context, listen: false).checkMounted();
    });
    final miniProvider =
        Provider.of<MiniplayerProvider>(context, listen: false);
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;
    final artworkColor =
        Provider.of<ArtworkColorProvider>(context).dominantColor;
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.getTheme() == CustomThemes.darkThemeMode;
    return Consumer<MiniplayerProvider>(
      builder: (context, value, child) {
        return MozController.currentIndex == null
            ? const SizedBox()
            : ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Consumer<ArtworkColorProvider>(
                      builder: (context, colorP, child) {
                    final dominantColor = colorP.dominantColor;
                    return AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: const [
                            .2,
                            .8,
                          ],
                    
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            isDark
                                ? artworkColor!
                                : Theme.of(context).focusColor,
                            isDark
                                ? Colors.black87
                                : Theme.of(context).focusColor
                          ],
                        ),
                        // color: Theme.of(context).focusColor.withOpacity(.90),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          ListTile(
                            tileColor: Colors.transparent,
                            onTap: () {
                              Navigator.push(
                                context,
                                Uptransition(NowPlaying(
                                  songModelList: MozController.playingSongs,
                                )),
                              );
                            },
                            textColor: Theme.of(context).cardColor,
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CircleAvatar(
                                child: Transform.scale(
                                  scale: MediaQuery.of(context).size.width *
                                      0.0040,
                                  child: Nuemorphic(
                                    borderRadius: BorderRadius.circular(100),
                                    shadowVisibility: false,
                                    child: Hero(
                                      tag: MozController
                                          .playingSongs[MozController
                                              .player.currentIndex!]
                                          .id,
                                      child: AudioArtworkDefinerForOthers(
                                        key: audioArtworkKey,
                                        iconSize: 25,
                                        id: MozController
                                            .playingSongs[MozController
                                                .player.currentIndex!]
                                            .id,
                                        imgRadius: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            title: Text(
                              MozController
                                  .playingSongs[
                                      MozController.player.currentIndex!]
                                  .title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                shadows: const [
                                  BoxShadow(
                                    color: Color.fromARGB(86, 139, 139, 139),
                                    blurRadius: 15,
                                    offset: Offset(-2, 2),
                                  ),
                                ],
                                fontSize: 14,
                                fontFamily: 'rounder',
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                            subtitle: Text(
                              MozController
                                          .playingSongs[MozController
                                              .player.currentIndex!]
                                          .artist
                                          .toString() ==
                                      '<unknown>'
                                  ? 'No Artist'
                                  : MozController
                                      .playingSongs[
                                          MozController.player.currentIndex!]
                                      .artist
                                      .toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                shadows: const [
                                  BoxShadow(
                                    color: Color.fromARGB(34, 107, 107, 107),
                                    blurRadius: 15,
                                    offset: Offset(-2, 2),
                                  ),
                                ],
                                fontSize: 11,
                                fontFamily: 'rounder',
                                fontWeight: FontWeight.w400,
                                color:
                                    Theme.of(context).cardColor.withOpacity(.4),
                              ),
                            ),
                            trailing: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.33,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      miniProvider.previousButton(context);
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.backward,
                                      color: Theme.of(context)
                                          .cardColor
                                          .withOpacity(.9),
                                      size: wt * 0.06,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      miniProvider.playPauseButton(context);
                                    },
                                    child: StreamBuilder<bool>(
                                      stream:
                                          MozController.player.playingStream,
                                      builder: (context, snapshot) {
                                        bool? playingStage = snapshot.data;

                                        return SizedBox(
                                          width: wt *
                                              0.08,
                                          height: wt *
                                              0.08,
                                          child: Icon(
                                            playingStage == true
                                                ? FontAwesomeIcons.pause
                                                : FontAwesomeIcons.play,
                                            color: Theme.of(context)
                                                .cardColor
                                                .withAlpha((255.0 * .9).round()),
                                            size: wt *
                                                0.07, 
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      miniProvider.nextButton(context);
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.forward,
                                      color: Theme.of(context)
                                          .cardColor
                                          .withOpacity(.9),
                                      size: wt * 0.06,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          StreamBuilder<DurationState>(
                            stream: _durationStateStream,
                            builder: (context, snapshot) {
                              final durationState = snapshot.data;
                              final progress =
                                  durationState?.position ?? Duration.zero;
                              final total =
                                  durationState?.total ?? Duration.zero;

                              return ProgressBar(
                                barHeight: ht * 0.003,
                                barCapShape: BarCapShape.round,
                                progressBarColor:
                                    const Color.fromARGB(255, 120, 78, 156),
                                bufferedBarColor:
                                    const Color.fromARGB(255, 120, 78, 156),
                                thumbGlowColor: Colors.transparent,
                                thumbColor:
                                    const Color.fromARGB(255, 120, 78, 156),
                                thumbRadius: ht * 0.001,
                                thumbGlowRadius: wt * 0.03,
                                baseBarColor: Colors.transparent,
                                progress: progress,
                                total: total,
                                timeLabelLocation: TimeLabelLocation.none,
                                onSeek: (duration) {
                                  MozController.player.seek(duration);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              );
      },
    );
  }
}
