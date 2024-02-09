import 'package:flutter/material.dart';
import 'package:spotify_clone/search/search_cards.dart';

import 'widgets/search_box.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                SearchBox(),
                Text(
                  'your top genres',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                SearchCards(),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
