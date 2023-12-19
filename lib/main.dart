import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spotify_clone/homepage/homepage.dart';
import 'package:spotify_clone/library/library.dart';
import 'package:spotify_clone/search/search.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    runApp(const MyApp());
  } catch (e) {
    print('failed initializing firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/logo.png'),
        nextScreen: Home(),
        pageTransitionType: PageTransitionType.fade,
        duration: 5000,
        backgroundColor: Colors.black,
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int cIndex = 0;

  List<BottomNavigationBarItem> navigationIcons() {
    return [
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.network(
            'https://cdn0.iconfinder.com/data/icons/spotify-line-ui-kit/100/home-line-128.png',
            width: 25,
            height: 23,
            color: Colors.grey,
          ),
        ),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.network(
            'https://cdn0.iconfinder.com/data/icons/spotify-line-ui-kit/100/your-library-line-128.png',
            width: 25,
            height: 23,
            color: Colors.grey,
          ),
        ),
        label: "Your Library",
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.network(
            'https://cdn0.iconfinder.com/data/icons/spotify-line-ui-kit/100/search-line-128.png',
            width: 25,
            height: 23,
            color: Colors.grey,
          ),
        ),
        label: "Search",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List _pages = [
      HomePage(),
      Library(),
      const Search(),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: cIndex,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        iconSize: 20,
        onTap: (int val) {
          setState(() {
            cIndex = val;
          });
        },
        type: BottomNavigationBarType.fixed,
        elevation: 50,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: navigationIcons(),
      ),
      body: _pages[cIndex],
    );
  }
}
