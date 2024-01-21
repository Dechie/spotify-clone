import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:spotify_clone/models/song.dart';
import 'package:spotify_clone/models/song_local.dart';

import '../constants.dart';
import '../models/user.dart';

class UploadProvider extends ChangeNotifier {
  bool _hasUploaded = false;
  List<SongLocal> _mySongs = [];

  bool get hasUploaded => _hasUploaded;
  List<SongLocal> get uploadedSongs => _mySongs;

  UploadProvider() {
    checkUploaded();
  }

  void checkUploaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('uploadedSongs', []);
    List<String> songsString = prefs.getStringList('uploadedSongs') ?? [];
    print(songsString);

    List<SongLocal> songs =
        songsString.map((song) => SongLocal.fromString(song)).toList();

    bool hasHeUploaded = prefs.getBool('hasUploaded') ?? false;
    await prefs.setBool('hasUploaded', true);

    if (songs.isEmpty) {
      return;
    }
    _mySongs = songs;
    _hasUploaded = hasHeUploaded;
    _hasUploaded = true;
    notifyListeners();
  }

  Future<(bool, String)> uploadNewSong(
      Map<String, dynamic> data, User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final formData = FormData.fromMap(data);
    var dio = Dio();
    bool success = false;
    String errorMessage = 'No error.';
    const url = '$baseUrl/uploadSong';
    print('this user\'s token: ${user.token}');

    print('data: ');
    print(data);
    var response;
    try {
      response = await dio.post(
        url,
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status == null ||
                (status >= 200 && status < 300) ||
                status == 302;
          },
          headers: {
            'Authorization': 'Bearer ${user.token}',
            'Content-Type': 'application/json',
          },
        ),
      );

      print(response.statusCode);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 302) {
        print(response.data);

        SongLocal local = SongLocal(
          artist: data['artist'],
          title: data['title'],
          genre: data['genre'],
          approved: data['approved'],
          releaseDate: data['release_date'],
        );

        List<String> songsString = prefs.getStringList('uploadedSongs') ?? [];

        List<SongLocal> songs =
            songsString.map((song) => SongLocal.fromString(song)).toList();
        songs.add(local);
        songsString = songs.map((e) => e.toString()).toList();
        await prefs.setStringList('uploadedSongs', songsString);

        _mySongs = songs;
        _hasUploaded = true;
        notifyListeners();
        success = true;
      }
    } catch (e) {
      print(e);
      return (success, e.toString());
    }
    return (success, errorMessage);
  }

  // Future<List<SongLocal>> getUploaded() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   List<String> songsString =
  //       prefs.getStringList('uploadedSongs') as List<SongLocal> ?? [];
  //   songs.add(local);
  //   List<String> songsString = songs.map((song) => song.toString()).toList();
  //   await prefs.setStringList('uploadedSongs', songsString);

  //   _mySongs = songs;
  // }
}
