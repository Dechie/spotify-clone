import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song.dart';

class SongProvider extends ChangeNotifier {
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isCurrentlyPlaying = false;
  Song _song = Song(
    artist: '',
    title: '',
    genre: '',
    releaseDate: '',
    audioUrl: '',
    imageUrl: '',
  );

  File? playingFile;

  int secondsDuration = 0;
  int minutesDuration = 0;

  IconData _playingIcon = Icons.play_arrow;

  AudioPlayer _audioPlayer = AudioPlayer();

  Duration _duration = Duration();
  Duration _position = Duration();

  List<Song> likedSongs = [];
  List<Song> likedLocals = [];

  SongProvider() {
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      _duration = duration;
      notifyListeners();
    });
    _audioPlayer.onPositionChanged.listen((Duration position) {
      _position = position;
      secondsDuration = _position.inSeconds.toInt() % 60;
      minutesDuration = _position.inMinutes.toInt();

      if (_position == _duration) {
        stopSong();
        playingFile!.delete();
        _song = Song(
          artist: '',
          title: '',
          genre: '',
          releaseDate: '',
          audioUrl: '',
          imageUrl: '',
        );
      }
      notifyListeners();
    });
  }

  Future<void> playSong(File file, Song song) async {
    playingFile = file;
    _song = song;
    await _audioPlayer.play(DeviceFileSource(file.path));
    _isCurrentlyPlaying = true;
    _isPlaying = true;
    _playingIcon = Icons.pause;
    notifyListeners();
  }

  void resumeSong() {
    _audioPlayer.resume();
    _isPaused = false;
    _isPlaying = true;
    _playingIcon = Icons.pause;
    notifyListeners();
  }

  void pauseSong() {
    _audioPlayer.pause();
    _isPaused = true;
    _isPlaying = false;
    _playingIcon = Icons.play_arrow;
    notifyListeners();
  }

  void stopSong() {
    _position = Duration.zero;
    _audioPlayer.stop();
    playingFile!.delete();
    _isCurrentlyPlaying = false;
    _isPlaying = false;
    _isPaused = false;
    notifyListeners();
  }

  void onPositionChanged(int secondsValue) {
    Duration newDur = Duration(seconds: secondsValue);
    _audioPlayer.seek(newDur);
    notifyListeners();
  }

  IconData get playingIcon => _playingIcon;

  bool get isCurrentlyPlaying => _isCurrentlyPlaying;
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  Song get playingSong => _song;
  Duration get position => _position;
  Duration get duration => _duration;

  void likeSong(Song song) {
    likedSongs.add(song);

    if (likedSongs.contains(song)) {
      return;
    }
    saveToLikedSongs(likedSongs);
    notifyListeners();
  }

  void dislikeSong(Song song) {
    Song? findSong = likedSongs.firstWhere(
      (sg) => sg.artist == song.artist && sg.title == song.title,
    );
    removeFromLikedSongs(findSong);
    likedSongs.remove(findSong);
    notifyListeners();
  }

  void likeLocal(Song song) {
    likedLocals.add(song);
    saveToLikedLocals(likedLocals);
    notifyListeners();
  }

  void dislikeLocal(Song song) {
    Song? findSong = likedLocals.firstWhere(
      (sg) => sg.artist == song.artist && sg.title == song.title,
    );
    removeFromLikedLocals(findSong);
    likedLocals.remove(findSong);
    notifyListeners();
  }

  void saveToLikedSongs(List<Song> theSongs) async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.setStringList('liked-songs', []);
    List<String> likedString = theSongs
        .map(
          (liked) => liked.toString(),
        )
        .toList();
  }

  void saveToLikedLocals(List<Song> theSongs) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> likedString = likedLocals
        .map(
          (liked) => liked.toString(),
        )
        .toList();
    prefs.setStringList('liked-locals', likedString);
  }

  void removeFromLikedSongs(Song song) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> likedString = prefs.getStringList('liked-songs')!;

    List<Song> songs = [];

    for (var str in likedString) {
      Song sng = Song.fromString(str);

      if (sng.artist == song.artist && sng.title == song.title) {
        continue;
      }
      songs.add(Song.fromString(str));
    }
    saveToLikedSongs(songs);
  }

  void removeFromLikedLocals(Song song) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> likedString = prefs.getStringList('liked-locals')!;

    List<Song> songs = [];

    for (var str in likedString) {
      Song sng = Song.fromString(str);

      if (sng.artist == song.artist && sng.title == song.title) {
        continue;
      }
      songs.add(Song.fromString(str));
    }
    saveToLikedLocals(songs);
  }

  void fetchLocalsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.setStringList('liked-locals', []);
    List<String>? likedString = prefs.getStringList('liked-locals');

    List<Song> songs = [];

    for (var str in likedString!) {
      songs.add(Song.fromString(str));
    }
    likedLocals = songs;
    notifyListeners();
  }

  void fetchSongsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.setStringList('liked-songs', []);
    List<String>? likedString = prefs.getStringList('liked-songs');

    List<Song> songs = [];

    for (var str in likedString!) {
      songs.add(Song.fromString(str));
    }
    likedSongs = songs;
    notifyListeners();
  }
}
