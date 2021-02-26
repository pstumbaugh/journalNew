import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel {
  final key;
  bool state;
  SharedPreferences prefs;

  ThemeModel({@required this.state, @required this.prefs, @required this.key});

  void changeTheme(state) {
    prefs.setBool(key, state);
  }

  Brightness getTheme() => key ? Brightness.dark : Brightness.light;
}

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}

//sets specifics for the dark theme
final darkTheme = ThemeMode.dark;

//sets specifics for the light theme
final lightTheme = ThemeMode.light;
