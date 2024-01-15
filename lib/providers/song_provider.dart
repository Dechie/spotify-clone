import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
    //_audioPlayer.seek(Duration.zero);
    _position = Duration.zero;
    _audioPlayer.stop();
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
}
