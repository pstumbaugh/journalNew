import 'imports.dart';

class MyApp extends StatefulWidget {
  final SharedPreferences preferences;
  MyApp({Key key, @required this.preferences}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
