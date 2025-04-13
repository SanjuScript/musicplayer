import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/HELPER/artist_helper.dart';
import 'package:music_player/SCREENS/main_music_playing_screen.dart.dart';
import 'package:music_player/WIDGETS/audio_for_others.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../CONTROLLER/song_controllers.dart';
import '../screens/favoritepage/favorite_button.dart';
import 'bottomsheet/song_info_sheet.dart';

class PlaylistHighlighter extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry borderradius;
  final Gradient? gradient;
  final bool shadowVisibility;
  final Color color;
  final EdgeInsetsGeometry margin;
  const PlaylistHighlighter({
    super.key,
    required this.child,
    this.gradient,
    this.shadowVisibility = true,
    required this.borderradius,
    required this.color,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: margin,
      height: MediaQuery.of(context).size.height * 0.13,
      width: MediaQuery.of(context).size.height * 0.10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderradius,
        boxShadow: shadowVisibility
            ? [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 3,
                  offset: const Offset(2, 2),
                ),
                BoxShadow(
                  color: Theme.of(context).dividerColor,
                  blurRadius: 3,
                  offset: const Offset(-2, -2),
                ),
              ]
            : [],
        gradient: gradient,
      ),
      child: child,
    );
  }
}

class SongDisplay extends StatelessWidget {
  final SongModel song;
  final List<SongModel> songs;
  final bool isTrailingChange;
  final bool disableOnTap;
  final Widget? trailing;
  final void Function()? remove;
  final bool isSelecting;
  final int index;

  const SongDisplay({
    Key? key,
    required this.song,
    this.isSelecting = false,
    required this.songs,
    this.isTrailingChange = false,
    this.disableOnTap = false,
    this.trailing,
    this.remove,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).scaffoldBackgroundColor,
      leading: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.25,
        width: MediaQuery.sizeOf(context).width * 0.16,
        child: AudioArtworkDefinerForOthers(
          id: song.id,
          imgRadius: 8,
          iconSize: 30,
        ),
      ),
      title: Text(
        song.title,
        maxLines: 1,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Theme.of(context).disabledColor,
          // letterSpacing: .6,
          fontFamily: 'rounder',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      
      onLongPress: () async {
        bottomDetailsSheet(
          context: context,
          enableRemoveButton: true,
          remove: remove,
          song: songs,
          index: index,
          showNext: true,
          isPlaylistShown: false,
          onTap: () {
            MozController.addToNext(song);
            Navigator.pop(context);
          },
        );
        // await DataController.deleteImageFile(File(song.data));
      },
      selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
      selectedColor: Theme.of(context).scaffoldBackgroundColor,
      focusColor: Theme.of(context).scaffoldBackgroundColor,
      hoverColor: Theme.of(context).scaffoldBackgroundColor,
      subtitle: Text(
        artistHelper(song.artist.toString(), song.fileExtension),
        maxLines: 1,
        style: TextStyle(
          fontSize: 13,
          fontFamily: 'rounder',
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.normal,
          color: Theme.of(context).cardColor.withOpacity(.4),
        ),
      ),
      onTap: disableOnTap
          ? null
          : () async {
              if (!isSelecting) {
                if (MozController.player.playing != true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NowPlaying(
                        songModelList: songs,
                      ),
                    ),
                  );
                }

                // MostlyPlayedDB.incrementPlayCount(song);
                if (!isSelecting) {
                  MozController.player.setAudioSource(
                      await MozController.createSongList(songs),
                      initialIndex: index);
                  MozController.player.play();
                  // MozController.playingSongs = songs;
                }
              }
            },
      trailing:
          isTrailingChange ? trailing : FavoriteButton(songFavorite: song),
    );
  }
}

class NextQueueScreen extends StatefulWidget {
  const NextQueueScreen({Key? key}) : super(key: key);

  @override
  State<NextQueueScreen> createState() => _NextQueueScreenState();
}

class _NextQueueScreenState extends State<NextQueueScreen> {
  late List<SongModel> upcomingSongs;

  @override
  void initState() {
    super.initState();
    _updateUpcoming();
  }

  void _updateUpcoming() {
    if (MozController.currentIndex < MozController.playingSongs.length - 1) {
      upcomingSongs = MozController.playingSongs.sublist(MozController.currentIndex + 1);
    } else {
      upcomingSongs = [];
    }
  }

  void _removeFromQueue(int index) {
    int actualIndex = MozController.currentIndex + 1 + index;

    MozController.playingSongs.removeAt(actualIndex);
    MozController.currentPlaylist.removeAt(actualIndex);

    setState(() {
      _updateUpcoming();
    });
  }

  void _reorderQueue(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;

    int actualOld = MozController.currentIndex + 1 + oldIndex;
    int actualNew = MozController.currentIndex + 1 + newIndex;

    final song = MozController.playingSongs.removeAt(actualOld);
    final source = MozController.currentPlaylist.children.removeAt(actualOld);

    MozController.playingSongs.insert(actualNew, song);
    MozController.currentPlaylist.insert(actualNew, source);

    setState(() {
      _updateUpcoming();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Next Up")),
      body: upcomingSongs.isEmpty
          ? const Center(child: Text("No songs in queue"))
          : ReorderableListView.builder(
              itemCount: upcomingSongs.length,
              onReorder: _reorderQueue,
              itemBuilder: (context, index) {
                final song = upcomingSongs[index];
                return ListTile(
                  key: ValueKey(song.id),
                  leading: QueryArtworkWidget(
                    id: song.id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(Icons.music_note),
                  ),
                  title: Text(song.title),
                  subtitle: Text(song.artist ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeFromQueue(index),
                  ),
                );
              },
            ),
    );
  }
}
