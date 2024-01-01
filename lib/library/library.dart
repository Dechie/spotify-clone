import 'package:flutter/material.dart';
import 'package:spotify_clone/library/widgets/common.dart';
import 'package:spotify_clone/library/widgets/playlists.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final _style = const TextStyle(
    fontSize: 27,
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          child: AppBar(
            bottom: TabBar(
              tabs: [
                Text(
                  "Playlist",
                  style: _style,
                ),
                Text(
                  "Artists",
                  style: _style,
                ),
                Text(
                  "Artists",
                  style: _style,
                ),
              ],
            ),
          ),
          preferredSize: const Size.fromHeight(kToolbarHeight),
        ),
        body: const TabBarView(
          children: [
            Playlists(),
            Common(),
            Common(),
          ],
        ),
      ),
    );
  }
}
