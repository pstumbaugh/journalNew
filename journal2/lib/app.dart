import 'imports.dart';

class JournalApp extends StatefulWidget {
  final SharedPreferences preferences;
  JournalApp({Key key, @required this.preferences}) : super(key: key);

  @override
  _JournalAppState createState() => _JournalAppState();
}

class _JournalAppState extends State<JournalApp> {
  static const THEME = 'dark';

  bool get theme => widget.preferences.getBool(THEME) ?? false;

  @override
  Widget build(BuildContext context) {
    final routes = {
      JournalEntries.route: (context) =>
          JournalEntries(modifier: themeChange, state: theme),
      NewJournalEntryForm.route: (context) =>
          NewJournalEntryForm(modifier: themeChange, state: theme),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journal',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: getTheme(),
      ),
      routes: routes,
    );
  }

//change theme from dark to light visa versa
  void themeChange(state) {
    setState(() {
      widget.preferences.setBool(THEME, state);
    });
  }

//set app theme, default dark
  Brightness getTheme() => theme ? Brightness.dark : Brightness.light;
}
