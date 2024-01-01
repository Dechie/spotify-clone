import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

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
  late Song playSong;

  @override
  void initState() {
    super.initState();
    playSong = widget.song;
  }

  void playStreamSong() async {
    var dio = Dio();

    Response response = await dio.get('url');

    Directory dir = await getApplicationDocumentsDirectory();
    File audioFile = File('${dir.path}/audio.mp3');

    await audioFile.writeAsBytes(response.data);

    AudioPlayer player = AudioPlayer();

    await player.play(DeviceFileSource(audioFile.path));
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
                                    style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    widget.song.title,
                                    style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
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
                            value: 0,
                            onChanged: (value) {}),
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
                                icon: const Icon(
                                  Icons.play_arrow,
                                  size: 45,
                                ),
                                onPressed: () {
                                  // Implement play logic
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
