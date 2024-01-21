import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/constants.dart';
import 'package:spotify_clone/homepage/homepage.dart';
import 'package:spotify_clone/library/library.dart';
import 'package:spotify_clone/profile/profile.dart';
import 'package:spotify_clone/providers/song_provider.dart';
import 'package:spotify_clone/providers/song_upload.dart';
import 'package:spotify_clone/providers/the_auth.dart';
import 'package:spotify_clone/search/search.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    await Firebase.initializeApp();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProvider(create: (context) => SongProvider()),
          ChangeNotifierProvider(create: (context) => UploadProvider()),
        ],
        child: MyApp(prefs: prefs),
      ),
    );
  } catch (e) {
    print('failed initializing firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.prefs,
  });

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.mainGreen),
      ),
      themeMode: ThemeMode.dark,
      home: AnimatedSplashScreen(
        splash: Image.asset(
          'assets/images/logo.png',
          width: 80,
          height: 80,
        ),
        nextScreen: const Home(),
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
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(0),
          child: SvgPicture.asset('assets/svg/user-profile.svg'),
        ),
        label: "Me",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List _pages = [
      HomePage(),
      Library(),
      const Search(),
      ProfileScreen(),
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
