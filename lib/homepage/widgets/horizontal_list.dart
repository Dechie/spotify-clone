import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:spotify_clone/player/player_screen.dart';

import '../../models/song.dart';

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
  /*
  late Uint8List imageBytes;
  late String errorMsg;

  _HorizontalListState() {
    final FirebaseStorage thestorage = FirebaseStorage.instance;

    final FirebaseStorage storage = FirebaseStorage._(
      app: Firebase.app,
      storageBucket: 'gs://my-project.appspot.com',
    );
    storage
        .ref()
        .child('selfies/me2.jpg')
        .getData(10000000)
        .then((data) => setState(() {
              imageBytes = data!;
            }))
        .catchError((e) => setState(() {
              errorMsg = e.error;
            }));
  }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new ListView(
          children: <Widget>[
            img,
          ],
        ));
  */

  @override
  Widget build(BuildContext context) {
    /*
    var img = imageBytes != null
        ? Image.memory(
            imageBytes,
            fit: BoxFit.cover,
          )
        : Text(errorMsg != null ? errorMsg : "Loading...");
        */

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
            onTap: () {
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
  }
}
