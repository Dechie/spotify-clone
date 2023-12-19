import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Playlists extends StatelessWidget {
  const Playlists({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            ListTile(
              leading: Image.network(
                  'https://i.pinimg.com/originals/cf/59/b9/cf59b95b507ab3a9736c269e81ddafc7.png'),
              title: const Text('Liked Songs'),
              subtitle: const Text('1546 songs'),
            ),
            ListTile(
              leading: Image.network(
                  'https://i.pinimg.com/originals/cf/59/b9/cf59b95b507ab3a9736c269e81ddafc7.png'),
              title: const Text('Liked Songs'),
              subtitle: const Text('1546 songs'),
            ),
            ListTile(
              leading: Image.network(
                  'https://i.pinimg.com/originals/cf/59/b9/cf59b95b507ab3a9736c269e81ddafc7.png'),
              title: const Text('Liked Songs'),
              subtitle: const Text('1546 songs'),
            ),
            ListTile(
              leading: Image.network(
                  'https://i.pinimg.com/originals/cf/59/b9/cf59b95b507ab3a9736c269e81ddafc7.png'),
              title: const Text('Liked Songs'),
              subtitle: const Text('1546 songs'),
            ),
          ],
        ),
      ),
    );
  }
}
