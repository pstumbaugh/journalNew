import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:core';

import '../models/journal_provider.dart';

class JournalDetailScreen extends StatefulWidget {
  static const routeName = '/journal-detail';

  @override
  _JournalDetailScreenState createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
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

  Widget _displayTitle(String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
      ),
    );
  }

  Widget _displayBody(String body) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(30, 10, 20, 15),
      child: Text(
        body,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final journalId = ModalRoute.of(context).settings.arguments
        as String; // retrieving ID from routes passed
    final loadedJournal = Provider.of<Journals>(context).findById(journalId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedJournal.title),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
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
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        _displayTitle(loadedJournal.title),
                        _displayBody(loadedJournal.body),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
