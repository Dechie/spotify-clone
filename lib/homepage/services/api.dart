import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spotify_clone/models/song.dart';
//import 'package:http/http.dart' as http;

//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Api {
  Future<String?> getImageUrl(String? gsUrl) async {
    // Assuming you have the FirebaseStorage instance already initialized
    try {
      final ref = FirebaseStorage.instance.refFromURL(gsUrl!);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error getting download URL: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _loadImages(List<Song> songs) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }

  Future<String> getTheDownloadUrl(String gsUrl) async {
    String downloadUrl = '';
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      Reference ref = storage.refFromURL(gsUrl);
      downloadUrl = await ref.getDownloadURL();
    } catch (e) {
      print(e);
    }

    return downloadUrl;
  }

  Future<List<Song>> fetchAllSongs() async {
    var dio = Dio();

    /*const url =
    //   'https://spotify-clone-53dbd-default-rtdb.firebaseio.com/songs.json';

    final uri = Uri.https(
      'spotify-clone-53dbd-default-rtdb.firebaseio.com',
      'songs.json',
    );
    */

    final urlhttps = Uri.https(
      'my-spotify-clone-548f4-default-rtdb.firebaseio.com',
      'songs.json',
    );

    final url = 'http://localhost:8000/api/songs/';

    List<Song> songs = [];
    try {
      //final response = await dio.getUri(urlhttps);
      //final response = await http.get(url);
      final response = await dio.get(url);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('fetched successfully');
        print(response.data);
        final jsonData = response.data as List<dynamic>;

        //songs = jsonData.map((data) => Song.fromMap(data)).toList();
        int count = 0;
        for (var data in jsonData) {
          print('round: $count');
          count++;
          if (data != null) {
            var downloadUrl =
                await getTheDownloadUrl(data['image_url'] as String);
            var data2 = {
              'artist': data['artist'],
              'title': data['title'],
              'genre': data['genre'],
              'releaseDate': data['release_date'].toString(),
              'audioUrl': data['audio_url'],
              //'imageUrl': downloadUrl,
              'imageUrl': data['image_url'],
            };
            //Song song = Song.fromMap(data2);
            //var gsUrl = song.imageUrl;
            //song.imageUrl = await getTheDownloadUrl(gsUrl!);
            //print('unGSfied: ${song.imageUrl}');
            //songs.add(song);
            //print(song.imageUrl);
            songs.add(Song.fromMap(data));
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }

    return songs;
  }
}
