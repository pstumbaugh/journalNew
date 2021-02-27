import 'package:flutter/material.dart';

import '../widgets/journal_drawer.dart';

class JournalScaffold extends StatefulWidget {
  static const route = '/';

  final body;
  final floatingActionButton;
  final modifier;
  final state;
  String title;

  JournalScaffold(
      {Key key,
      @required this.body,
      this.floatingActionButton,
      this.title,
      this.modifier,
      this.state})
      : super(key: key);

  @override
  _JournalScaffoldState createState() => _JournalScaffoldState();
}

class _JournalScaffoldState extends State<JournalScaffold> {
  final lists = List<Map>.generate(200, (index) {
    return {
      'title': 'Journal entry $index',
      'subtitle': 'Subtitle text $index'
    };
  });

  @override
  Widget build(BuildContext context) {
    return ThemeDrawer(
        key: widget.key,
        body: widget.body,
        floatingActionButton: widget.floatingActionButton,
        title: widget.title,
        state: widget.state,
        modifier: widget.modifier);
  }
}
