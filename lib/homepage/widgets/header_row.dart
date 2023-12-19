import 'package:flutter/material.dart';

class HeaderRow extends StatefulWidget {
  HeaderRow({Key? key}) : super(key: key);

  @override
  _HeaderRowState createState() => _HeaderRowState();
}

class _HeaderRowState extends State<HeaderRow> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        15,
        20,
        15,
        15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hello, User',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.settings,
          ),
        ],
      ),
    );
  }
}
