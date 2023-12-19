class Song {
  Song({
    required this.artist,
    required this.title,
    required this.genre,
    required this.releaseDate,
    required this.audioUrl,
    required this.imageUrl,
  });

  final String artist, title, genre, releaseDate;
  String? audioUrl, imageUrl;

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      artist: map['artist'],
      title: map['title'],
      genre: map['genre'],
      releaseDate: map['release_date'].toString(),
      audioUrl: map['audio_url'],
      imageUrl: map['image_url'],
    );
  }
}
