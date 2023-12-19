import 'package:flutter/material.dart';

class SearchCards extends StatelessWidget {
  const SearchCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            CardGenre(),
            CardGenre(),
          ],
        ),
        Row(
          children: [
            CardGenre(),
            CardGenre(),
          ],
        ),
      ],
    );
  }
}

class CardGenre extends StatelessWidget {
  const CardGenre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 160,
        height: 90,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(
                children: [
                  Text(
                    'hip hop',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              Transform.rotate(
                angle: 0.5,
                child: Image.network(
                  'https://cdn.platinumlist.net/upload/artist/lij_michael_655-orig1536230833.jpg',
                  width: 70,
                  height: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
