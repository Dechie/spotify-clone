import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/models/user.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._prefs);
  SharedPreferences _prefs;

  bool _isLoggedIn = false;
  String? _userToken;

  bool get isLoggedIn => _isLoggedIn;
  String? get userToken => _userToken;

  void updateUserToken(String token) {
    _userToken = token;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> login() async {
    await _prefs.setBool('isLoggedIn', true);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<String> registerUser(User user) async {
    String? userData = _prefs.getString('loggedInUser');

    if (userData != null) {
      userData = user.toString();
      _prefs.setString('loggedInUser', userData);
      notifyListeners();
      return 'new register';
    } else {
      return 'already registered';
    }
  }

  void updateLoggedInStatus({
    required bool isLoggedIn,
    required String token,
  }) {
    isLoggedIn = isLoggedIn;
    token = token;
    notifyListeners();
  }
}
