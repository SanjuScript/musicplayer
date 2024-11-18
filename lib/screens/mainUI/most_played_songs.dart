import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:music_player/WIDGETS/dialogues/UTILS/dialogue_utils.dart';
import 'package:music_player/WIDGETS/song_sections.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/DATABASE/most_played.dart';
import 'package:music_player/HELPER/get_audio_size_in_mb.dart';
import 'package:music_player/WIDGETS/appbar.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:music_player/WIDGETS/song_list_maker.dart';
import '../../CONTROLLER/song_controllers.dart';

class MostlyPlayed extends StatefulWidget {
  const MostlyPlayed({Key? key}) : super(key: key);

  @override
  State<MostlyPlayed> createState() => _MostlyPlayedState();
}

class _MostlyPlayedState extends State<MostlyPlayed> {
  ValueNotifier<List<SongModel>> _mostlyPlayedSongsNotifier =
      ValueNotifier<List<SongModel>>([]);

  @override
  void initState() {
    super.initState();
    _fetchMostlyPlayedSongs();
  }

  Future<void> _fetchMostlyPlayedSongs() async {
    List<String> mostPlayedSongIds = PlayCountService.getMostPlayedSongIds();
    List<SongModel> songs = await OnAudioQuery().querySongs();

    // Filter songs based on the most played song IDs
    List<SongModel> mostlyPlayedSongs = songs.where((song) {
      return mostPlayedSongIds.contains(song.id.toString());
    }).toList();

    // Sort songs by their play count (highest play count first)
    mostlyPlayedSongs.sort((a, b) {
      final playCountA = PlayCountService.getPlayCount(a.id.toString());
      final playCountB = PlayCountService.getPlayCount(b.id.toString());
      return playCountB.compareTo(playCountA); // Sort in descending order of play count
    });

    // Update the ValueNotifier with the sorted list
    _mostlyPlayedSongsNotifier.value = mostlyPlayedSongs;
  }

  @override
  void dispose() {
    // Dispose the notifier to avoid memory leaks
    _mostlyPlayedSongsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            TopAppBar(
              icon: Icons.music_note_rounded,
              isPop: _mostlyPlayedSongsNotifier.value.isEmpty ? false : true,
              iconTap: () {},
              onSelected: (p0) {
                if (p0 == "ClearAll") {
                  DialogueUtils.getDialogue(
                    context,
                    'pdelete',
                    arguments: [
                      "Delete All From Mostly Played",
                      () {
                        PlayCountService.clearPlayCountData();
                        Navigator.pop(context);
                        _fetchMostlyPlayedSongs(); // Refresh the list
                      },
                      null,
                      null
                    ],
                  );
                }
              },
              topString: "Mostly",
              firstString: "Play All",
              secondString: "${_mostlyPlayedSongsNotifier.value.length} Songs",
              widget: ValueListenableBuilder<List<SongModel>>(
                valueListenable: _mostlyPlayedSongsNotifier,
                builder: (context, mostlyPlayedSongs, child) {
                  return mostlyPlayedSongs.isEmpty
                      ? Center(
                          child: Text(
                            'No Mostly played Yet',
                            style: TextStyle(
                              letterSpacing: 2,
                              fontFamily: "appollo",
                              color: Theme.of(context).cardColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: mostlyPlayedSongs.length,
                          itemBuilder: (context, index) {
                            final song = mostlyPlayedSongs[index];
                            final playCount =
                                PlayCountService.getPlayCount(song.id.toString());
                            return SongDisplay(
                              song: song,
                              songs: mostlyPlayedSongs,
                              isTrailingChange: true,
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    playCount.toString(),
                                    style: TextStyle(
                                      shadows: const [
                                        BoxShadow(
                                          color: Color.fromARGB(86, 139, 139, 139),
                                          blurRadius: 15,
                                          offset: Offset(-2, 2),
                                        ),
                                      ],
                                      fontSize: 17,
                                      fontFamily: 'rounder',
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  ),
                                  Text(
                                    "played",
                                    style: TextStyle(
                                      shadows: const [
                                        BoxShadow(
                                          color: Color.fromARGB(34, 107, 107, 107),
                                          blurRadius: 15,
                                          offset: Offset(-2, 2),
                                        ),
                                      ],
                                      fontSize: 13,
                                      fontFamily: 'rounder',
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .cardColor
                                          .withOpacity(.4),
                                    ),
                                  ),
                                ],
                              ),
                              index: index,
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
