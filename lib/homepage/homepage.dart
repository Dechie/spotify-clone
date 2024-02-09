import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/homepage/services/api.dart';
import 'package:spotify_clone/homepage/widgets/recents.dart';
import 'package:spotify_clone/homepage/widgets/horizontal_list.dart';
import 'package:spotify_clone/player/player_screen.dart';
import 'package:spotify_clone/providers/song_provider.dart';

import '../models/song.dart';
import 'widgets/header_row.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Song> allSongs = [],
      localSongs = [],
      ethipianSongs = [],
      englishSongs = [],
      edmSongs = [];
  var songProvider;

  @override
  void initState() {
    super.initState();
    fetchAllSongs();

    songProvider = Provider.of<SongProvider>(context, listen: false);
  }

  void fetchAllSongs() async {
    final api = Api();
    List<Song> fetched = await api.fetchAllSongs();
    List<Song> fetched2 = await api.fetchLocalSongs();

    localSongs = fetched2;

    allSongs = fetched;
    ethipianSongs = fetched
        .where(
          (song) => song.genre == 'ethiopian',
        )
        .toList();
    englishSongs = fetched.where((song) => song.genre == 'english').toList();
    edmSongs = fetched.where((song) => song.genre == 'EDM').toList();

    if (mounted) {
      songProvider = Provider.of<SongProvider>(context, listen: false);
    }
    setState(() {});
  }

  bool isPlaying = false;
  bool isPaused = false;

  int secondsDuration = 0;
  int minutesDuration = 0;

  @override
  Widget build(BuildContext context) {
    const _bottomPlayerKey = Key('bottomPlayer');
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Consumer<SongProvider>(
          builder: (context, songProvider, child) {
            int secs = songProvider.secondsDuration;
            int mins = songProvider.minutesDuration;

            return SizedBox(
              width: size.width,
              height: size.height,
              child: DecoratedBox(
                //decoration: backgroundColor(),
                decoration: const BoxDecoration(shape: BoxShape.rectangle),
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderRow(),
                              const Recent(),
                              const SizedBox(height: 20),
                              Text(
                                'Local Artists',
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              HorizontalListLocal(
                                localSongs: localSongs,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Pop Ethiopian',
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                              const SizedBox(height: 10),
                              HorizontalList(
                                categorySongs: ethipianSongs,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'EDM',
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              HorizontalList(
                                categorySongs: edmSongs,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'English Songs',
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              HorizontalList(
                                categorySongs: englishSongs,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (songProvider.isCurrentlyPlaying)
                      Positioned(
                        bottom: 10,
                        left: 15,
                        child: SizedBox(
                          height: 70,
                          width: size.width * .9,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: const Color.fromARGB(255, 79, 55, 46)
                                    .withOpacity(.95)),
                            child: Dismissible(
                              key: _bottomPlayerKey,
                              onDismissed: (direction) {
                                songProvider.stopSong();
                              },
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                dense: true,
                                isThreeLine: true,
                                onTap: () {
                                  //PlayerScreen(song: ,);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PlayerScreen(
                                          song: songProvider.playingSong),
                                    ),
                                  );
                                },
                                leading: SizedBox(
                                  width: 55,
                                  height: 40,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          songProvider.playingIcon,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          if (songProvider.isPaused) {
                                            songProvider.resumeSong();
                                          } else if (songProvider.isPlaying) {
                                            songProvider.pauseSong();
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(songProvider.playingSong.title),
                                    const SizedBox(width: 5),
                                    Container(
                                      width: 5,
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(songProvider.playingSong.artist),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Slider(
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.grey,
                                      value: songProvider.position.inSeconds
                                          .toDouble(),
                                      onChanged: (double value) {
                                        songProvider
                                            .onPositionChanged(value.toInt());
                                      },
                                      min: 0,
                                      max: songProvider.duration.inSeconds
                                          .toDouble(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
