import 'package:flutter/material.dart';
import './screens/create_journal_screen.dart';
import 'package:provider/provider.dart';

import './models/theme_provider.dart';
import './models/journal_provider.dart';

import './screens/welcome_screen.dart';
import './screens/journal_detail_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      builder: (_) => ThemeProvider(isLightTheme: true),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Journals(),
        ),
      ],
      child: MaterialApp(
        title: 'Journal',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.getThemeData,
        home: WelcomeScreen(),
        routes: {
          CreateJournalScreen.routeName: (context) => CreateJournalScreen(),
          JournalDetailScreen.routeName: (context) => JournalDetailScreen(),
        },
      ),
    );
  }
}
