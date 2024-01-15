import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/auth/auth_new/my_register.dart';

import '../models/user.dart';
import '../providers/the_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AfterLayoutMixin<ProfileScreen> {
  User? thisUser;
  bool isLoggedIn = false;
  String? token, userStringified;
  bool loginStat = false;
  bool loginCheckCompleted = false;

  var authProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    readToken();
  }

  void readToken() async {
    try {
      String thisToken;
      late SharedPreferences prefs;

      SharedPreferences.getInstance().then((SharedPreferences sp) async {
        prefs = sp;
        token = prefs.getString('token');
        thisToken = prefs.getString('token') ?? '';
        // will be null if never previously saved
        if (token == null) {
          token = '---';
          print(token);
        } else {
          print(thisToken);

          await Provider.of<Auth>(context, listen: false).tryToken(thisToken);
        }
        setState(() {});
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Auth>(
        builder: (context, auth, child) {
          return auth.authenticated
              ? buildLoggedInUI(
                  context,
                  auth.authedUser,
                )
              : buildLoggedOutUI();
        },
      ),
    );
  }

  Widget buildLoggedInUI(BuildContext context, User user) {
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
              Text(user.name),
              const SizedBox(height: 10),
              Text(user.email),
              const SizedBox(height: 10),
              Text(user.token!),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoggedOutUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'log in to see your profile',
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RegisterScreen(),
                ),
              );
            },
            child: const Text('Log In'),
          )
        ],
      ),
    );
  }
}
