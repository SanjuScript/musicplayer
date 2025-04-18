import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/HELPER/sort_enum.dart';
import 'package:music_player/HELPER/strings.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:music_player/WIDGETS/audio_for_others.dart';
import 'package:music_player/WIDGETS/buttons/home_button.dart';
import 'package:music_player/WIDGETS/mostly_shot_display.dart';
import 'package:music_player/WIDGETS/recently_shot_display.dart';
import 'package:music_player/WIDGETS/suggestion_shot_list.dart';
import 'package:music_player/screens/artists/artists_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../ANIMATION/fade_animation.dart';
import '../../CONTROLLER/song_controllers.dart';
import '../../DATABASE/most_played.dart';
import '../../DATABASE/recently_played.dart';
import '../../PROVIDER/album_provider.dart';
import '../../PROVIDER/artist_provider.dart';
import '../../PROVIDER/homepage_provider.dart';
import '../album/album_list.dart';
import '../main_music_playing_screen.dart.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.favorite,
      required this.playlist,
      required this.recently,
      required this.mostly,
      required this.songs});
  final void Function() favorite;
  final void Function() songs;
  final void Function() recently;
  final void Function() mostly;
  final void Function() playlist;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  void _navigate({required BuildContext context, required Widget child}) {
    Navigator.push(context, ThisIsFadeRoute(route: child));
  }

  Widget _audioDataLabelWIthListenable(
      {required ValueListenable<List<SongModel>> valueListenable}) {
    return ValueListenableBuilder<List<SongModel>>(
        valueListenable: valueListenable,
        builder: (context, value, child) {
          return Text(
            value.length.toString(),
            style: const TextStyle(
                shadows: [
                  BoxShadow(
                    color: Color.fromARGB(90, 63, 63, 63),
                    blurRadius: 15,
                    offset: Offset(-2, 2),
                  ),
                ],
                fontSize: 40,
                fontFamily: 'coolvetica',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        });
  }

  Widget _audioDataWithoutListenable({required String audioData}) {
    return Text(
      audioData,
      style: const TextStyle(
          shadows: [
            BoxShadow(
              color: Color.fromARGB(90, 63, 63, 63),
              blurRadius: 15,
              offset: Offset(-2, 2),
            ),
          ],
          fontSize: 40,
          fontFamily: 'coolvetica',
          fontWeight: FontWeight.bold,
          color: Colors.white),
    );
  }

  Widget getItemByIndex(int index, List<String> audioData) {
    if (index == 0) {
      return _audioDataWithoutListenable(audioData: audioData[index]);
    } else if (index == 1) {
      return _audioDataWithoutListenable(audioData: audioData[index]);
    } else if (index == 2) {
      return _audioDataWithoutListenable(audioData: audioData[index]);
    } else if (index == 3) {
      return _audioDataLabelWIthListenable(
          valueListenable: FavoriteDb.favoriteSongs);
    } else {
      return _audioDataWithoutListenable(audioData: audioData[index]);
    }
  }

  void _playlist() {
    widget.playlist();
  }

  void _favorite() {
    widget.favorite();
  }

  void _songs() {
    widget.songs();
  }

  void _recenlty() {
    widget.recently();
  }

  void _mostly() {
    widget.mostly();
  }

  @override
  void initState() {
    super.initState();
    // RecentDb.initialize(GetSong);
  }

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    log("Home page rebuilds");
    super.build(context);
    final allSongsData = Provider.of<HomePageSongProvider>(context);
    final albumData = Provider.of<AlbumProvider>(context);
    final artistData = Provider.of<ArtistProvider>(context);
    final favoriteData = FavoriteDb.favoriteSongsLength;
    final playlistData = PlayListDB.playListDb.length;
    List<String> audioData = [
      allSongsData.currentSongCount.toString(),
      albumData.totalAlbums.toString(),
      artistData.totalArtists.toString(),
      favoriteData.toString(),
      playlistData.toString()
    ];
    List<void Function()> navigationController = [
      _songs,
      () {
        _navigate(context: context, child: const AlbumList());
      },
      () {
        _navigate(context: context, child: const ArtistList());
      },
      _favorite,
      _playlist,
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Home",
          style: TextStyle(
              shadows: const [
                BoxShadow(
                  color: Color.fromARGB(90, 63, 63, 63),
                  blurRadius: 15,
                  offset: Offset(-2, 2),
                ),
              ],
              fontSize: 25,
              fontFamily: 'coolvetica',
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).cardColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal),
        controller: _controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.11,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: audioData.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: navigationController[index],
                    child: HomePageButtons(
                      child: FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getItemByIndex(index, audioData),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                audioSectionNames[index].toUpperCase(),
                                style: const TextStyle(
                                    shadows: [
                                      BoxShadow(
                                        color: Color.fromARGB(90, 63, 63, 63),
                                        blurRadius: 15,
                                        offset: Offset(-2, 2),
                                      ),
                                    ],
                                    fontSize: 15,
                                    fontFamily: 'coolvetica',
                                    letterSpacing: 1,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ValueListenableBuilder(
                valueListenable: RecentDb.recentSongs,
                builder: (BuildContext context, List<SongModel> value,
                    Widget? child) {
                  if (value.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: InkWell(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: _recenlty,
                        child: Text(
                          "Recently played",
                          style: TextStyle(
                              shadows: const [
                                BoxShadow(
                                  color: Color.fromARGB(90, 63, 63, 63),
                                  blurRadius: 15,
                                  offset: Offset(-2, 2),
                                ),
                              ],
                              fontSize: 25,
                               fontFamily: 'coolvetica',
              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).cardColor),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
            RecentlyShotDisplay(),
            !PlayCountService.isMostPlayedSongIdsEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.transparent),
                      onTap: _mostly,
                      child: Text(
                        "Mostly Played",
                        style: TextStyle(
                            shadows: const [
                              BoxShadow(
                                color: Color.fromARGB(90, 63, 63, 63),
                                blurRadius: 15,
                                offset: Offset(-2, 2),
                              ),
                            ],
                            fontSize: 25,
                            fontFamily: 'coolvetica',
              letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).cardColor),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const MostlyShotDisplay(),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                "Last Added",
                style: TextStyle(
                    shadows: const [
                      BoxShadow(
                        color: Color.fromARGB(90, 63, 63, 63),
                        blurRadius: 15,
                        offset: Offset(-2, 2),
                      ),
                    ],
                    fontSize: 25,
                     fontFamily: 'coolvetica',
              letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).cardColor),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.22,
              child: Consumer<HomePageSongProvider>(
                  builder: (context, lastAddedSong, child) {
                final currentSongDate = lastAddedSong.getLastAddedSongs(10);

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: lastAddedSong.currentSongCount < 10
                      ? lastAddedSong.currentSongCount
                      : 10,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, lastSongindex) {
                    return InkWell(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      onTap: () async {
                        // MozController.playingSongs = currentSongDate;
                        if (MozController.player.playing != true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NowPlaying(
                                      songModelList:
                                          MozController.playingSongs)));
                        }

                        MozController.player.setAudioSource(
                            await MozController.createSongList(
                              lastAddedSong.getLastAddedSongs(
                                  lastAddedSong.homePageSongs.length),
                            ),
                            initialIndex: lastSongindex);
                        MozController.player.play();
                        MozController.player.playerStateStream
                            .listen((playerState) {
                          if (playerState.processingState ==
                              ProcessingState.completed) {
                            // Check if the current song is the last song in the playlist
                            if (MozController.player.currentIndex ==
                                currentSongDate.length - 1) {
                              // Rewind the playlist to the starting index
                              MozController.player
                                  .seek(Duration.zero, index: 0);
                            }
                          }
                        });
                        // MozController.songscopy = currentSongDate;
                      },
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.sizeOf(context).width * 0.26,
                              height: MediaQuery.sizeOf(context).height * 0.12,
                              margin: const EdgeInsets.only(
                                  left: 8, right: 8, top: 14, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const []),
                              child: AudioArtworkDefinerForOthers(
                                id: currentSongDate[lastSongindex].id,
                                imgRadius: 15,
                              )),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.05,
                            width: MediaQuery.sizeOf(context).width * 0.25,
                            child: Text(
                              currentSongDate[lastSongindex].title,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  shadows: const [
                                    BoxShadow(
                                      color: Color.fromARGB(90, 89, 89, 89),
                                      blurRadius: 15,
                                      offset: Offset(-2, 2),
                                    ),
                                  ],
                                  fontSize: 13,
                                  fontFamily: 'rounder',
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).cardColor),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.18,
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
