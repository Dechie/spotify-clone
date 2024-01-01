import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spotify_clone/homepage/services/api.dart';
import 'package:spotify_clone/homepage/widgets/recents.dart';
import 'package:spotify_clone/homepage/widgets/horizontal_list.dart';

import '../models/song.dart';
import 'widgets/header_row.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Song> allSongs = [], ethipianSongs = [], englishSongs = [];
  void fetchAllSongs() async {
    final api = Api();
    List<Song> fetched = await api.fetchAllSongs();

    allSongs = fetched;
    ethipianSongs = fetched.where((song) => song.genre == 'ethiopian').toList();
    englishSongs = fetched.where((song) => song.genre == 'english').toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: DecoratedBox(
            decoration: backgroundColor(),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderRow(),
                      const Recent(),
                      const SizedBox(height: 20),
                      const Text(
                        'Ethiopian',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      HorizontalList(
                        categorySongs: ethipianSongs,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'English Songs',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      HorizontalList(
                        categorySongs: englishSongs,
                      ),
                      /*
                      const SizedBox(height: 15),
                      const Text(
                        'Also Listen to',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const HorizontalList(
                        url:
                            'https://i.scdn.co/image/ab67616d0000b273477dcbc6195534f52cc8048e',
                      ),
                      */
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration backgroundColor() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.purple,
          Colors.black,
        ],
        begin: Alignment.topCenter,
      ),
    );
  }
}
