import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spotify_clone/models/song.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../../models/song_local.dart';
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

    final url = '$baseUrl/songs/';

    List<Song> songs = [];
    try {
      final response = await dio.get(url);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('fetched successfully');
        //print(response.data);
        final jsonData = response.data as List<dynamic>;

        //songs = jsonData.map((data) => Song.fromMap(data)).toList();
        int count = 0;
        for (var data in jsonData) {
          print(data['image_url']);
          print('round: $count');
          count++;
          if (data != null) {
            songs.add(Song.fromMap(data));
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }

    return songs;
  }

  Future<List<Song>> fetchLocalSongs() async {
    var dio = Dio();

    final url = '$baseUrl/localSongs/';

    List<Song> songs = [];
    List<SongLocal> locals = [];
    try {
      final response = await dio.get(url);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('fetched successfully');
        //print(response.data);
        final jsonData = response.data as List<dynamic>;

        //songs = jsonData.map((data) => Song.fromMap(data)).toList();
        int count = 0;
        for (var data in jsonData) {
          print(data['image_url']);
          print('round: $count');
          count++;
          if (data != null) {
            locals.add(SongLocal.fromMap(data));
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }

    if (locals.isNotEmpty) {
      songs = locals.map((e) => Song.fromLocal(e)).toList();
    }

    print('image url: ${songs[0].imageUrl}');

    return songs;
  }

  Future<String> fetchSongFile(Song song) async {
    var dio = Dio();
    print(song.title);
    final url = '$baseUrl/fetchSongFile?audio_url=${song.title}';
    try {
      //final response = await dio.get(url);

      Response<List<int>> response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        // Get the app directory to store the downloaded file
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String filePath = '${appDocDir.path}/${song.title}.mp3';

        List<int> bytes = response.data!;

        // Write the audio file to the app directory
        File audioFile = File(filePath);

        await audioFile.writeAsBytes(bytes);

        print(audioFile != null ? 'file been written' : 'file not written');

        return filePath;
      } else {
        // Handle unsuccessful response
        print('Failed to fetch audio');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
    return '';
  }

  void uploadSong(Song song) async {
    var dio = Dio();
    print(song.title);
    final url = '$baseUrl/uploadLocalSong';
    var filePath = '/path/to/your/song.mp3';

    try {
      // Create a FormData object
      FormData formData = FormData.fromMap({
        'audio_file': await MultipartFile.fromFile(
          filePath,
          filename: 'song.mp3',
        ),
        'artist': song.artist
      });

      // Send the POST request with the FormData
      Response response = await dio.post(url, data: formData);

      // Handle the response, you might want to check for success status
      if (response.statusCode == 200) {
        print('Upload successful');
      } else {
        print('Upload failed with status ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading file: $error');
    }
  }

  fetchSongFileLocal(Song song) async {
    var dio = Dio();
    print(song.title);
    final url = '$baseUrl/localSongs/getSong?audio_url=${song.title}';
    try {
      //final response = await dio.get(url);

      Response<List<int>> response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        // Get the app directory to store the downloaded file
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String filePath = '${appDocDir.path}/${song.title}.mp3';

        List<int> bytes = response.data!;

        // Write the audio file to the app directory
        File audioFile = File(filePath);

        await audioFile.writeAsBytes(bytes);

        print(audioFile != null ? 'file been written' : 'file not written');

        return filePath;
      } else {
        // Handle unsuccessful response
        print('Failed to fetch audio');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
    return '';
  }
}
