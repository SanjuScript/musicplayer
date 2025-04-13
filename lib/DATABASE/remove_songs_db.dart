import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RemovedSongsDB {
  static bool isInitialized = false;
  static final musicDb = Hive.box<int>('removedDB');
  static ValueNotifier<List<SongModel>> removedSongs = ValueNotifier([]);
  static int get removedSongsLength => removedSongs.value.length;
  static List<SongModel> get removedSongsList => removedSongs.value;
   static Future<void> initialize(List<SongModel> allSongs) async {
      for (SongModel song in allSongs) {
      if (isRemoved(song)) {
        removedSongs.value.add(song);
      }
    }
    isInitialized = true;
  }

  static isRemoved(SongModel song) {
    if (musicDb.values.contains(song.id)) {
      return true;
    }
    return false;
  }

  static add(SongModel song) async {
    musicDb.add(song.id);
    removedSongs.value.add(song);
    log("Added to removedDB: ${song.id}");
    // ignore: invalid_use_of_visible_for_testing_member
    RemovedSongsDB.removedSongs.notifyListeners();
  }

  static Future<void> remove(SongModel song) async {
    final key = musicDb.keys
        .firstWhere((k) => musicDb.get(k) == song.id, orElse: () => null);
    if (key != null) {
      await musicDb.delete(key);
      removedSongs.value.removeWhere((s) => s.id == song.id);
      log("Removed from removedDB: ${song.id}");
      removedSongs.notifyListeners();
    }
  }

  static delete(int id) async {
    int deletekey = 0;
    if (!musicDb.values.contains(id)) {
      return;
    }
    final Map<dynamic, int> favorMap = musicDb.toMap();
    favorMap.forEach((key, value) {
      if (value == id) {
        deletekey = key;
      }
    });
    musicDb.delete(deletekey);
    removedSongs.value.removeWhere((song) => song.id == id);
  }

  static deleteAll() {
    musicDb.clear();
    removedSongs.value.clear();
  }

  static clear() async {
    RemovedSongsDB.removedSongs.value.clear();
  }
}
extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
