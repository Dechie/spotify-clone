import 'package:flutter/material.dart';

class Recent extends StatelessWidget {
  const Recent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CardRow(),
        CardRow(),
        //CardRow(),
      ],
    );
  }
}

class CardRow extends StatelessWidget {
  const CardRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cardsBuild(
          'https://i.pinimg.com/originals/cf/59/b9/cf59b95b507ab3a9736c269e81ddafc7.png',
          'Liked Songs',
        ),
        cardsBuild(
          'https://i.pinimg.com/originals/cf/59/b9/cf59b95b507ab3a9736c269e81ddafc7.png',
          'Liked Songs',
        ),
      ],
    );
  }
}

Card cardsBuild(String img, String txt) {
  return Card(
    color: Colors.grey.shade800,
    child: SizedBox(
      width: 165,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Image.network(
              img,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                4,
                17,
                15,
                17,
              ),
              child: Text(txt),
            ),
          )
        ],
      ),
    ),
  );
}
