import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/player/player_screen.dart';
import 'package:spotify_clone/providers/song_provider.dart';

import '../../models/song.dart';
import '../../models/song_local.dart';

class HorizontalList extends StatefulWidget {
  const HorizontalList({
    super.key,
    required this.categorySongs,
  });

  final List<Song> categorySongs;

  @override
  State<HorizontalList> createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  var songProvider;

  @override
  void initState() {
    super.initState();

    songProvider = Provider.of<SongProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, value, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 195,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              0,
              10,
              20,
              10,
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categorySongs.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () async {
                  if (songProvider.isCurrentlyPlaying) {
                    songProvider.stopSong();
                    await Future.delayed(const Duration(milliseconds: 500));
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(
                        song: widget.categorySongs[index],
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      //url,
                      widget.categorySongs[index].imageUrl!,
                      width: 130,
                      height: 130,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      //'kutty pattas',
                      widget.categorySongs[index].artist,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      //'Single, Santhosh',
                      widget.categorySongs[index].title,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(width: 12),
            ),
          ),
        );
      },
    );
  }
}

class HorizontalListLocal extends StatefulWidget {
  const HorizontalListLocal({
    super.key,
    required this.localSongs,
  });

  final List<SongLocal> localSongs;

  @override
  State<HorizontalListLocal> createState() => _HorizontalListLocalState();
}

class _HorizontalListLocalState extends State<HorizontalListLocal> {
  var songProvider;

  @override
  void initState() {
    super.initState();

    songProvider = Provider.of<SongProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, value, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 195,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              0,
              10,
              20,
              10,
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.localSongs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    if (songProvider.isCurrentlyPlaying) {
                      songProvider.stopSong();
                      await Future.delayed(const Duration(milliseconds: 500));
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          song: Song.fromLocal(widget.localSongs[index]),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        //url,
                        //widget.localSongs[index].imageUrl!,
                        '',
                        width: 130,
                        height: 130,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        //'kutty pattas',
                        widget.localSongs[index].artist,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        //'Single, Santhosh',
                        widget.localSongs[index].title,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 12),
            ),
          ),
        );
      },
    );
  }
}
