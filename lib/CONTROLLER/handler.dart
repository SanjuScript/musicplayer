import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class MozAudioHandler extends BaseAudioHandler {
  final AudioPlayer player = AudioPlayer();
  final ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);
  
  // Define BehaviorSubject for playback state
  final BehaviorSubject<PlaybackState> _playbackStateSubject = BehaviorSubject<PlaybackState>();

  MozAudioHandler() {
    _initializeEmptyPlaylist();
    _listenToPlayerStateChanges();
  }

  // Initialize an empty playlist
  void _initializeEmptyPlaylist() async {
    try {
      await player.setAudioSource(playlist);
      log("Playlist initialized successfully");
    } catch (e) {
      log("Error initializing playlist: $e");
    }
  }

  // Listen to player state changes and update the playback state
  void _listenToPlayerStateChanges() {
    player.playbackEventStream.listen((event) {
      final isPlaying = player.playing;
      _playbackStateSubject.add(PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if (isPlaying) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {MediaAction.seek},
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[player.loopMode]!,
        shuffleMode: player.shuffleModeEnabled
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: isPlaying,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        speed: player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    try {
      // Map media items to audio sources
      final audioSources = mediaItems.map(_createAudioSource).toList();
      playlist.addAll(audioSources);
      final newQueue = List<MediaItem>.from(queue.value)..addAll(mediaItems);
      queue.add(newQueue);
      log("Queue updated with ${mediaItems.length} items.");
    } catch (e) {
      log("Error adding items to queue: $e");
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) {
      log("Invalid index: $index");
      return;
    }
    try {
      await player.seek(Duration.zero, index: index);
      log("Skipped to index $index");
    } catch (e) {
      log("Error skipping to index $index: $e");
    }
  }

  @override
  Future<void> play() async {
    try {
      await player.play();
      log("Playback started.");
    } catch (e) {
      log("Error starting playback: $e");
    }
  }

  @override
  Future<void> pause() async {
    try {
      await player.pause();
      log("Playback paused.");
    } catch (e) {
      log("Error pausing playback: $e");
    }
  }

  @override
  Future<void> stop() async {
    try {
      await player.stop();
      log("Playback stopped.");
    } catch (e) {
      log("Error stopping playback: $e");
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await player.seek(position);
      log("Seeked to position: $position");
    } catch (e) {
      log("Error seeking: $e");
    }
  }

  @override
  Future<void> skipToNext() async {
    try {
      await player.seekToNext();
      log("Skipped to next track.");
    } catch (e) {
      log("Error skipping to next: $e");
    }
  }

  @override
  Future<void> skipToPrevious() async {
    try {
      await player.seekToPrevious();
      log("Skipped to previous track.");
    } catch (e) {
      log("Error skipping to previous: $e");
    }
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    final uriString = mediaItem.extras?['uri'] as String?;
    if (uriString == null) {
      log("Error: MediaItem does not have a valid 'uri' field.");
      throw Exception("Invalid URI in media item");
    }
    return AudioSource.uri(
      Uri.parse(uriString),
      tag: mediaItem,
    );
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    try {
      switch (repeatMode) {
        case AudioServiceRepeatMode.none:
          player.setLoopMode(LoopMode.off);
          break;
        case AudioServiceRepeatMode.one:
          player.setLoopMode(LoopMode.one);
          break;
        case AudioServiceRepeatMode.all:
        case AudioServiceRepeatMode.group:
          player.setLoopMode(LoopMode.all);
          break;
      }
      log("Repeat mode set to $repeatMode");
    } catch (e) {
      log("Error setting repeat mode: $e");
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    try {
      player.setShuffleModeEnabled(shuffleMode != AudioServiceShuffleMode.none);
      if (shuffleMode == AudioServiceShuffleMode.all) {
        await player.shuffle();
      }
      log("Shuffle mode set to $shuffleMode");
    } catch (e) {
      log("Error setting shuffle mode: $e");
    }
  }

  // @override
  // Stream<PlaybackState> get playbackState => _playbackStateSubject.stream;
}

Future<void> initAudioService() async {
  await AudioService.init(
    builder: () => MozAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.music.audio',
      androidNotificationChannelName: 'Music Playback',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
      preloadArtwork: true,
      artDownscaleHeight: 100,
      artDownscaleWidth: 100,
      androidStopForegroundOnPause: true,
    ),
  );
}
