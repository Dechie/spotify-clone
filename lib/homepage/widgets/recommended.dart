import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../models/song.dart';

class Recommended extends StatefulWidget {
  const Recommended({
    super.key,
    required this.url,
    required this.categorySongs,
  });

  final List<Song> categorySongs;

  final String url;

  @override
  State<Recommended> createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  /*
  late Uint8List imageBytes;
  late String errorMsg;

  _RecommendedState() {
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
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categorySongs.length,
        itemBuilder: (context, index) => Row(
          children: [
            RecommCard(
              url: widget.url,
              song: widget.categorySongs[index],
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class RecommCard extends StatelessWidget {
  const RecommCard({
    super.key,
    required this.url,
    required this.song,
  });

  final String url;
  final Song song;

  @override
  Widget build(BuildContext context) {
    print('this image\'s url: ${song.imageUrl}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          //url,
          song.imageUrl!,
          width: 130,
          height: 130,
        ),
        const SizedBox(height: 8),
        Text(
          //'kutty pattas',
          song.artist,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          //'Single, Santhosh',
          song.title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
