import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/auth/auth_service.dart';

import '../models/user.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  User _user = User(name: '', email: '', token: '');
  String _token = '';

  bool get authenticated => _isLoggedIn;
  User get authedUser => _user;
  String get userToken => _token;

  final FlutterSecureStorage storage = FlutterSecureStorage();

  void register(User user) async {
    print(user.toString());

    AuthService authService = AuthService();

    var (token, stCode) = await authService.registerUser(user);

    if (stCode == 201) {
      _isLoggedIn = true;
      _token = token;
      _user = user;
      _user.token = token;
      storeToken(token);
      print(token);
      notifyListeners();
    }
  }

  Future<void> tryToken(String token) async {
    AuthService authService = AuthService();
    var authedUser = await authService.loginWithToken(token);

    if (authedUser != null) {
      _user = authedUser;
      _isLoggedIn = true;
      _token = token;
      _user.token = token;
      print('user with token: $authedUser');
      notifyListeners();
    }
  }

  void storeToken(String tokenValue) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      //await storage.write(key: 'token', value: tokenValue);
      await prefs
          .setString('token', tokenValue)
          .then((value) => print('saved token: $tokenValue'));
    } catch (e) {
      print(e);
    }
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
