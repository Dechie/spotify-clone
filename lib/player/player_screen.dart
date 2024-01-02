import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_clone/homepage/services/api.dart';

import '../models/song.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
    required this.song,
  });

  final Song song;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late File songFile;

  AudioPlayer audioPlayer = AudioPlayer();
  Duration _duration = Duration();
  Duration _position = Duration();

  bool isPlaying = false;
  bool isPaused = false;

  int secondsDuration = 0;
  int minutesDuration = 0;

  @override
  void initState() {
    super.initState();
    fetchSong();
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
        secondsDuration = _position.inSeconds.toInt() % 60;
        minutesDuration = _position.inMinutes.toInt();
      });
    });
  }

  void playStreamSong() async {
    await audioPlayer.play(DeviceFileSource(songFile.path));
    setState(() {
      isPlaying = true;
    });
  }

  void fetchSong() async {
    var api = Api();
    String path = await api.fetchSongFile(widget.song);
    File audioFile = File(path);

    setState(() {
      songFile = audioFile;
    });
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.brown,
                Colors.brown.shade300,
                Colors.brown.shade300,
                Colors.black,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),

                      const Spacer(),
                      Text(
                        'Playing Song',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),

                      //PopupMenuButton(itemBuilder: (context)=>)
                      Icon(Icons.menu),
                    ],
                  ),
                  //const Spacer(),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.width * .8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.song.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    widget.song.artist,
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    widget.song.title,
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.add),
                            const SizedBox(width: 10),
                            const Icon(Icons.add),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                          value: _position.inSeconds.toDouble(),
                          onChanged: (double value) {
                            seekToSecond(value.toInt());
                            setState(() {});
                          },
                          min: 0,
                          max: _duration.inSeconds.toDouble(),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${minutesDuration}:',
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              secondsDuration.toString(),
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.skip_previous,
                                  size: 20,
                                ),
                                onPressed: () {
                                  // Implement skip to previous song logic
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 45,
                                ),
                                onPressed: () {
                                  // Implement play logic
                                  if (!isPlaying) {
                                    playStreamSong();
                                    setState(() {
                                      isPlaying = true;
                                    });
                                  } else {
                                    audioPlayer.pause();
                                    isPaused = true;
                                    isPlaying = false;
                                    setState(() {});
                                  }

                                  /*
                                  if (!isPlaying) {
                                  } else {
                                    audioPlayer.pause();
                                  }
                                  */
                                },
                              ),
                            ),
                            /*
                            IconButton(
                              icon: Icon(Icons.pause),
                              onPressed: () {
                                // Implement pause logic
                              },
                            ),
                            */
                            Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.skip_next,
                                  size: 20,
                                ),
                                onPressed: () {
                                  // Implement skip to next song logic
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
