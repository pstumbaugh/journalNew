import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/journal_provider.dart';
import '../models/journal.dart';
import '../models/theme_provider.dart';

import '../widgets/journal_list_item.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Journals>(context).retrieveJournalData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  Widget _progreeIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _displayListOfJournals(List<Journal> loadedJournals) {
    return Flexible(
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        itemCount: loadedJournals.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: loadedJournals[i],
          child: JournalListItem(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _loadedJournals = Provider.of<Journals>(context);
    final journals = _loadedJournals.journals;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Journal'),
      ),
      body: _isLoading
          ? _progreeIndicator()
          : LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Switch(
                                value: themeProvider.isLightTheme,
                                onChanged: (val) {
                                  setState(
                                    () {
                                      themeProvider.setThemeData = val;
                                    },
                                  );
                                  final SharedPreferences prefs =
                                      SharedPreferences.getInstance()
                                          as SharedPreferences;
                                  prefs.setString('theme',
                                      themeProvider.isLightTheme.toString());
                                },
                              ),
                            ],
                          ),
                        ),
                        _displayListOfJournals(journals),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/create-new-journal');
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: themeProvider.getThemeData == lightTheme
              ? Colors.black
              : Colors.white,
        ),
      ),
    );
  }
}
