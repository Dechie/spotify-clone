import 'dart:convert';

import 'package:spotify_clone/models/song_local.dart';

class Song {
  Song({
    this.id,
    required this.artist,
    required this.title,
    required this.genre,
    required this.releaseDate,
    required this.audioUrl,
    required this.imageUrl,
    this.filePath,
  });

  int? id;
  final String artist, title, genre, releaseDate;
  String? audioUrl, imageUrl, filePath;

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      artist: map['artist'],
      title: map['title'],
      genre: map['genre'],
      releaseDate: map['release_date'].toString(),
      audioUrl: map['audio_url'],
      imageUrl: map['image_url'],
    );
  }

  factory Song.fromLocal(SongLocal songLocal) {
    return Song(
      artist: songLocal.artist,
      title: songLocal.title,
      genre: songLocal.genre,
      releaseDate: songLocal.releaseDate,
      audioUrl: '',
      imageUrl:
          'https://is4-ssl.mzstatic.com/image/thumb/Purple122/v4/c2/42/86/c2428696-763e-8c33-3026-ae8d4326f38e/source/1280x1280bb.jpg',
    );
  }

  factory Song.fromString(String song) {
    Map<String, dynamic> data = json.decode(song);
    print(data.toString());
    return Song.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'artist': artist,
      'title': title,
      'genre': genre,
      'release_date': releaseDate,
      'audio_url': audioUrl,
      'image_url': imageUrl,
    };
  }

  @override
  String toString() {
    return '{"artist": "$artist", "title": "$title", "genre": "$genre", "file_path": "$filePath"}';
  }
}
