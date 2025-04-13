import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player/DATABASE/remove_songs_db.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../HELPER/sort_enum.dart';

class HomePageSongProvider extends ChangeNotifier {
  List<SongModel> homePageSongs = [];
  List<SongModel> foundSongs = [];
  late List<SongModel> allSongs;
  List<SongModel> recentSongs = [];
  bool _permissionGranted = false;
  Future<List<SongModel>>? _songsFuture;
  SortOption _defaultSort = SortOption.adate;

  int _currentSongCount = 0;

  int get currentSongCount => _currentSongCount;


  bool get permissionGranted => _permissionGranted;
  Future<List<SongModel>>? get songsFuture => _songsFuture;
  SortOption get defaultSort => _defaultSort;
  List<SongModel> get songs => homePageSongs;
  List<SongModel> get recentsong => recentSongs;

  final OnAudioQuery _audioQuery = OnAudioQuery();

  void removeSongs(List<SongModel> songsToRemove) {
    for (var song in songsToRemove) {
      homePageSongs.remove(song);
      RemovedSongsDB.add(song);
    }
    notifyListeners();
  }

  void restoreAllSongs() {
    for (var song in RemovedSongsDB.removedSongs.value) {
      homePageSongs.add(song);
    }
    RemovedSongsDB.clear();
    notifyListeners();
  }

  void restoreSong(SongModel song) {
    homePageSongs.add(song);
    RemovedSongsDB.remove(song);

    notifyListeners();
  }

  void filterSongs(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = allSongs;
    } else {
      results = allSongs.where((element) {
        return element.displayNameWOExt
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase().trimRight());
      }).toList();
    }

    foundSongs = results;
    notifyListeners();
  }

  set currentSongCount(int count) {
    _currentSongCount = count;
    notifyListeners();
  }

  set defaultSort(SortOption sortOption) {
    _defaultSort = sortOption;
    notifyListeners(); // Notify listeners of the state change
  }

  void toggleValue(SortOption? value) {
    if (value != null) {
      _defaultSort = value;
      saveSortOption(value);
      notifyListeners(); // Notify listeners of the state change
    }
  }

  void fetchAllSongs() async {
    allSongs = await OnAudioQuery().querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: null,
    );
    // Filter out unwanted songs
    foundSongs = allSongs.where((song) {
      final displayName = song.displayName.toLowerCase();
                final removedIds = RemovedSongsDB.musicDb.values.toSet();


      return !removedIds.contains(song.id) && // Exclude removed songs
          !displayName.contains(".opus") &&
          !displayName.contains("aud") &&
          !displayName.contains("recordings") &&
          !displayName.contains("recording") &&
          !displayName.contains("MIDI") &&
          !displayName.contains("pxl") &&
          !displayName.contains("Record") &&
          !displayName.contains("VID") &&
          !displayName.contains("whatsapp");
    }).toList();
    notifyListeners();
  }

 
  List<SongModel> getLastAddedSongs(int count) {
    final effectiveCount = count.clamp(0, homePageSongs.length);
    final sonrted = sortSongs(homePageSongs, SortOption.adate);
    return sonrted.take(effectiveCount).toList();
  }

  Future<List<SongModel>> querySongs() async {
    final sortType = getSortType(defaultSort);

    final songs = await _audioQuery.querySongs(
      sortType: sortType,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    // Filter out unwanted songs
    final filteredSongs = songs.where((song) {
      final displayName = song.displayName.toLowerCase();
      final songDur = (song.duration! / 1000) >= 10;
      // final removedIds = RemovedSongsDB.removedSongsList
      //     .map((removedSong) => removedSong.id)
      //     .toSet();
          final removedIds = RemovedSongsDB.musicDb.values.toSet();
          

      return !removedIds.contains(song.id) && // Exclude removed songs
          !displayName.contains(".opus") &&
          !displayName.contains("aud") &&
          !displayName.contains("ptt".toUpperCase()) &&
          !displayName.contains("recordings") &&
          !displayName.contains("recording") &&
          !displayName.contains("MIDI") &&
          !displayName.contains("pxl") &&
          !displayName.contains("Record") &&
          !displayName.contains("VID") &&
          !displayName.contains("whatsapp") &&
          songDur;
    }).toList();
    homePageSongs = filteredSongs;
    currentSongCount = filteredSongs.length;

    notifyListeners();
    return homePageSongs;
  }

  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _songsFuture = querySongs();
    notifyListeners();
  }

  Future<void> checkPermissionsAndQuerySongs(
      SortOption defaultSort, BuildContext context,
      {bool isallowed = false}) async {
    _permissionGranted = await _audioQuery.checkAndRequest(
      retryRequest: isallowed,
    );
    if (_permissionGranted) {
      _songsFuture = querySongs();
      notifyListeners();
    }
  }

  HomePageSongProvider() {
    // Call loadRemovedSongs asynchronously using a microtask
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_permissionGranted) {
        _songsFuture = querySongs();
        notifyListeners();
      } else {
        // log("message LLLLLL");
      }
    });
  }
}
