import '../imports.dart';

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
  ThemeMode _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeMode themeData) async {
    notifyListeners();
  }
}

final darkTheme = ThemeMode.dark;

final lightTheme = ThemeMode.light;
