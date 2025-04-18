// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/DATABASE/remove_songs_db.dart';
import 'package:music_player/SCREENS/main_music_playing_screen.dart.dart';
import 'package:music_player/WIDGETS/song_list_maker.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../WIDGETS/dialogues/playlist_delete_dialogue.dart';
import '../../Widgets/appbar.dart';
import '../../CONTROLLER/song_controllers.dart';

class RemovedSongsPage extends StatefulWidget {
  const RemovedSongsPage({super.key});

  @override
  State<RemovedSongsPage> createState() => _RemovedSongsPageState();
}

class _RemovedSongsPageState extends State<RemovedSongsPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  Widget detailsMaker(
      BuildContext context, String upperText, String subText, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      minVerticalPadding: 5,
      title: Text(
        upperText,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: MediaQuery.of(context).size.width * 0.050,
          color: Theme.of(context).cardColor,
        ),
      ),
      subtitle: Text(
        subText,
        style: const TextStyle(
          color: Color.fromARGB(255, 49, 141, 69),
        ),
      ),
      iconColor: const Color(0xff97B0EA),
      tileColor: Colors.transparent,
    );
  }

  void _deleteAllFavorites() {
    // Delete all songs from favorites
    RemovedSongsDB.deleteAll();
    RemovedSongsDB.removedSongs.notifyListeners();
  }

  @override
  void initState() {
    super.initState();
    RemovedSongsDB.initialize(MozController.songscopy);
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<List<SongModel>>(
      valueListenable: RemovedSongsDB.removedSongs,
      builder:
          (BuildContext context, List<SongModel> favoriteData, Widget? child) {
        return Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: TopAppBar(
                isPop: favoriteData.isEmpty ? false : true,
                onSelected: (p0) {
                  if (p0 == "ClearAll") {
                    showPlaylistDeleteDialogue(
                        context: context,
                        text1: "Clear All From Liked",
                        onPress: () {
                          _deleteAllFavorites();
                        });
                  }
                },
                firstString: "Play All",
                secondString: "${favoriteData.length} Songs",
                topString: "Removed Songs",
                widget: favoriteData.isEmpty
                    ? Center(
                        heightFactor: 30,
                        child: Text(
                          'NO FAVORITES YET',
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
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          SongModel song = favoriteData[index];
                          // String filePath = song.data;
                          // File file = File(filePath);
                          // double fileSizeInMB = getFileSizeInMB(file);
                          return SongDisplay(
                              song: song, songs: favoriteData, index: index);
                        },
                        itemCount: favoriteData.length,
                      ),
                icon: Icons.music_note,
                iconTap: () {},
              ),
            ));
      },
    );
  }
}
