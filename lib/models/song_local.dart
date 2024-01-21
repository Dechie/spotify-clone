import 'dart:convert';

class SongLocal {
  SongLocal({
    this.id,
    required this.artist,
    required this.title,
    required this.genre,
    required this.approved,
    required this.releaseDate,
    this.filePath,
  });

  int? id;
  final String artist, title, genre, releaseDate;
  String? filePath;
  final bool approved;

  factory SongLocal.fromMap(Map<String, dynamic> map) {
    print(map['approved']);
    bool? isApproved;

    if (map['approved'] == 0) {
      isApproved = false;
    } else {
      isApproved = true;
    }
    return SongLocal(
      id: map['id'] as int,
      artist: map['artist'],
      title: map['title'],
      genre: map['genre'],
      approved: isApproved,
      releaseDate: map['release_date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'artist': artist,
      'title': title,
      'genre': genre,
      'release_date': releaseDate,
      'approved': approved
    };
  }

  @override
  String toString() {
    return '{"artist": $artist, "title": $title, "genre": $genre, "approved": $approved, "file_path": $filePath}';
  }

  factory SongLocal.fromString(String song) {
    Map<String, dynamic> data = json.decode(song);
    print(data.toString());
    return SongLocal.fromMap(data);
  }
}
