import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/auth/login.dart';
import 'package:spotify_clone/providers/auth_provider.dart';

import '../auth/register.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? thisUser;
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    String? token = Provider.of<AuthProvider>(context).userToken;
    isLoggedIn = token != null && token.isNotEmpty;

    return Scaffold(
      body: Center(
        child: isLoggedIn ? buildLoggedInUI(context) : buildLoggedOutUI(),
      ),
    );
  }

  Widget buildLoggedInUI(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.playlist_add,
          color: Colors.grey,
        ),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Center(
          child: Wrap(
            children: [
              Text(
                thisUser.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoggedOutUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'log in to see your profile',
        ),
        ElevatedButton(
          onPressed: () async {
            User registeredUser = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SignUpPage(),
              ),
            );
            if (registeredUser != null) {
              setState(() {
                isLoggedIn = true;
                thisUser = registeredUser;
              });
            }
          },
          child: const Text('Log In'),
        )
      ],
    );
  }
}
